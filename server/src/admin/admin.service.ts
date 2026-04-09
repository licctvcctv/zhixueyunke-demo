import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { Course } from '../entities/course.entity';
import { Post } from '../entities/post.entity';
import { ClassEntity } from '../entities/class.entity';
import { Question } from '../entities/question.entity';
import { Lesson } from '../entities/lesson.entity';
import { Comment } from '../entities/comment.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Course) private courseRepo: Repository<Course>,
    @InjectRepository(Post) private postRepo: Repository<Post>,
    @InjectRepository(ClassEntity) private classRepo: Repository<ClassEntity>,
    @InjectRepository(Question) private questionRepo: Repository<Question>,
    @InjectRepository(Lesson) private lessonRepo: Repository<Lesson>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
  ) {}

  checkAdmin(role: string) {
    if (role !== 'admin') throw new ForbiddenException('需要管理员权限');
  }

  async getStats() {
    const [userCount, courseCount, postCount, classCount, questionCount, lessonCount, commentCount] =
      await Promise.all([
        this.userRepo.count(),
        this.courseRepo.count(),
        this.postRepo.count(),
        this.classRepo.count(),
        this.questionRepo.count(),
        this.lessonRepo.count(),
        this.commentRepo.count(),
      ]);
    return { userCount, courseCount, postCount, classCount, questionCount, lessonCount, commentCount };
  }

  async getUsers(skip = 0, limit = 20) {
    const [users, total] = await this.userRepo.findAndCount({
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });
    return { data: users.map(({ password, ...u }) => u), total };
  }

  async updateUser(id: number, data: Partial<User>) {
    await this.userRepo.update(id, data);
    const user = await this.userRepo.findOne({ where: { id } });
    const { password, ...rest } = user;
    return rest;
  }

  async getCourses(skip = 0, limit = 20) {
    const [data, total] = await this.courseRepo.findAndCount({
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });
    return { data, total };
  }

  async deleteCourse(id: number) {
    await Promise.all([
      this.lessonRepo.delete({ courseId: id }),
      this.commentRepo.delete({ targetType: 'course', targetId: id }),
    ]);
    await this.courseRepo.delete(id);
    return { message: '已删除' };
  }

  async getPosts(skip = 0, limit = 20) {
    const [data, total] = await this.postRepo.findAndCount({
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });
    return { data, total };
  }

  async deletePost(id: number) {
    await this.commentRepo.delete({ targetType: 'post', targetId: id });
    await this.postRepo.delete(id);
    return { message: '已删除' };
  }
}
