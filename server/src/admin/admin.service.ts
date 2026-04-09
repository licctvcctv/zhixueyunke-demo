import { Injectable, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual, Like } from 'typeorm';
import { User } from '../entities/user.entity';
import { Course } from '../entities/course.entity';
import { Post } from '../entities/post.entity';
import { ClassEntity } from '../entities/class.entity';
import { ClassMember } from '../entities/class-member.entity';
import { Question } from '../entities/question.entity';
import { Answer } from '../entities/answer.entity';
import { Lesson } from '../entities/lesson.entity';
import { Comment } from '../entities/comment.entity';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    @InjectRepository(Course) private courseRepo: Repository<Course>,
    @InjectRepository(Post) private postRepo: Repository<Post>,
    @InjectRepository(ClassEntity) private classRepo: Repository<ClassEntity>,
    @InjectRepository(ClassMember) private classMemberRepo: Repository<ClassMember>,
    @InjectRepository(Question) private questionRepo: Repository<Question>,
    @InjectRepository(Answer) private answerRepo: Repository<Answer>,
    @InjectRepository(Lesson) private lessonRepo: Repository<Lesson>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
  ) {}

  checkAdmin(role: string) {
    if (role !== 'admin') throw new ForbiddenException('需要管理员权限');
  }

  async getStats() {
    const oneWeekAgo = new Date();
    oneWeekAgo.setDate(oneWeekAgo.getDate() - 7);

    const [totalUsers, totalCourses, totalPosts, totalClasses, totalQuestions, newUsersThisWeek, recentUsersRaw, recentCourses] =
      await Promise.all([
        this.userRepo.count(),
        this.courseRepo.count(),
        this.postRepo.count(),
        this.classRepo.count(),
        this.questionRepo.count(),
        this.userRepo.count({ where: { createdAt: MoreThanOrEqual(oneWeekAgo) } }),
        this.userRepo.find({ order: { createdAt: 'DESC' }, take: 5 }),
        this.courseRepo.find({ order: { createdAt: 'DESC' }, take: 5 }),
      ]);

    const recentUsers = recentUsersRaw.map(({ password, ...rest }) => rest);

    return {
      totalUsers,
      totalCourses,
      totalPosts,
      totalClasses,
      totalQuestions,
      newUsersThisWeek,
      recentUsers,
      recentCourses,
    };
  }

  async getUsers(skip = 0, limit = 20, search?: string) {
    const qb = this.userRepo.createQueryBuilder('u');
    if (search) {
      qb.where('u.name LIKE :s OR u.email LIKE :s', { s: `%${search}%` });
    }
    qb.orderBy('u.createdAt', 'DESC').skip(skip).take(limit);
    const [users, total] = await qb.getManyAndCount();
    const list = users.map(({ password, ...u }) => ({
      ...u,
      status: u.status === 1 ? 'active' : 'disabled',
    }));
    return { list, total };
  }

  async updateUser(id: number, data: Partial<User>) {
    await this.userRepo.update(id, data);
    const user = await this.userRepo.findOne({ where: { id } });
    const { password, ...rest } = user;
    return rest;
  }

  async getCourses(skip = 0, limit = 20, search?: string) {
    const qb = this.courseRepo.createQueryBuilder('c');
    if (search) {
      qb.where('c.title LIKE :s OR c.teacherName LIKE :s', { s: `%${search}%` });
    }
    qb.orderBy('c.createdAt', 'DESC').skip(skip).take(limit);
    const [data, total] = await qb.getManyAndCount();
    const list = data.map((c) => ({ ...c, instructor: c.teacherName }));
    return { list, total };
  }

  async deleteCourse(id: number) {
    await Promise.all([
      this.lessonRepo.delete({ courseId: id }),
      this.commentRepo.delete({ targetType: 'course', targetId: id }),
    ]);
    await this.courseRepo.delete(id);
    return { message: '已删除' };
  }

  async getPosts(skip = 0, limit = 20, search?: string) {
    const qb = this.postRepo.createQueryBuilder('p');
    if (search) {
      qb.where('p.content LIKE :s OR p.authorName LIKE :s', { s: `%${search}%` });
    }
    qb.orderBy('p.createdAt', 'DESC').skip(skip).take(limit);
    const [list, total] = await qb.getManyAndCount();
    return { list, total };
  }

  async deletePost(id: number) {
    await this.commentRepo.delete({ targetType: 'post', targetId: id });
    await this.postRepo.delete(id);
    return { message: '已删除' };
  }

  async getClasses(skip = 0, limit = 20, search?: string) {
    const qb = this.classRepo.createQueryBuilder('c');
    if (search) {
      qb.where('c.name LIKE :s OR c.teacherName LIKE :s', { s: `%${search}%` });
    }
    qb.orderBy('c.createdAt', 'DESC').skip(skip).take(limit);
    const [list, total] = await qb.getManyAndCount();
    return { list, total };
  }

  async deleteClass(id: number) {
    await this.classMemberRepo.delete({ classId: id });
    await this.classRepo.delete(id);
    return { message: '已删除' };
  }

  async getQuestions(skip = 0, limit = 20, search?: string) {
    const qb = this.questionRepo.createQueryBuilder('q');
    if (search) {
      qb.where('q.title LIKE :s OR q.content LIKE :s', { s: `%${search}%` });
    }
    qb.orderBy('q.createdAt', 'DESC').skip(skip).take(limit);
    const [list, total] = await qb.getManyAndCount();
    return { list, total };
  }

  async deleteQuestion(id: number) {
    await this.answerRepo.delete({ questionId: id });
    await this.questionRepo.delete(id);
    return { message: '已删除' };
  }
}
