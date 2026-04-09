import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ClassEntity } from '../entities/class.entity';
import { ClassMember } from '../entities/class-member.entity';
import { Course } from '../entities/course.entity';
import { Post } from '../entities/post.entity';
import { User } from '../entities/user.entity';

@Injectable()
export class ClassesService {
  constructor(
    @InjectRepository(ClassEntity) private classRepo: Repository<ClassEntity>,
    @InjectRepository(ClassMember) private memberRepo: Repository<ClassMember>,
    @InjectRepository(Course) private courseRepo: Repository<Course>,
    @InjectRepository(Post) private postRepo: Repository<Post>,
    @InjectRepository(User) private userRepo: Repository<User>,
  ) {}

  async findAll() {
    return this.classRepo.find({ order: { createdAt: 'DESC' } });
  }

  async findOne(id: number) {
    const cls = await this.classRepo.findOne({ where: { id } });
    if (!cls) throw new NotFoundException('班级不存在');
    const members = await this.memberRepo.find({ where: { classId: id } });
    const memberDetails = await this.enrichMembers(members);
    const courses = await this.courseRepo.find({
      where: { teacherName: cls.teacherName },
      order: { createdAt: 'DESC' },
      take: 4,
    });
    const posts = await this.postRepo.find({
      order: { createdAt: 'DESC' },
      take: 4,
    });
    return { ...cls, members: memberDetails, courses, posts };
  }

  async create(data: Partial<ClassEntity>) {
    const cls = this.classRepo.create(data);
    return this.classRepo.save(cls);
  }

  async join(classId: number, userId: number) {
    const cls = await this.classRepo.findOne({ where: { id: classId } });
    if (!cls) throw new NotFoundException('班级不存在');
    const existing = await this.memberRepo.findOne({ where: { classId, userId } });
    if (existing) throw new BadRequestException('已加入该班级');
    const member = this.memberRepo.create({ classId, userId, role: 'student' });
    await this.memberRepo.save(member);
    cls.studentCount += 1;
    await this.classRepo.save(cls);
    return { message: '加入成功' };
  }

  async getJoinedClassIds(userId: number): Promise<number[]> {
    const members = await this.memberRepo.find({ where: { userId } });
    return members.map(m => m.classId);
  }

  async getMembers(classId: number) {
    const members = await this.memberRepo.find({ where: { classId } });
    return this.enrichMembers(members);
  }

  private async enrichMembers(members: ClassMember[]) {
    if (members.length === 0) return [];
    const userIds = members.map(m => m.userId);
    const users = await this.userRepo
      .createQueryBuilder('user')
      .where('user.id IN (:...ids)', { ids: userIds })
      .getMany();
    const userMap = new Map(users.map(u => [u.id, u.name]));
    return members.map(m => ({ ...m, userName: userMap.get(m.userId) || '未知' }));
  }
}
