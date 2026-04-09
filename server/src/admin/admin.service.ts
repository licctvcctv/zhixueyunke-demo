import { Injectable, ForbiddenException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, MoreThanOrEqual, Like } from 'typeorm';
import * as bcrypt from 'bcrypt';
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

  async updateUser(id: number, data: { name?: string; email?: string; role?: string; bio?: string; status?: any }) {
    const updateData: Partial<User> = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.email !== undefined) updateData.email = data.email;
    if (data.bio !== undefined) updateData.bio = data.bio;
    if (data.role !== undefined && ['admin', 'teacher', 'user'].includes(data.role)) {
      updateData.role = data.role;
    }
    if (data.status !== undefined) {
      if (typeof data.status === 'string') {
        updateData.status = data.status === 'active' ? 1 : 0;
      } else {
        updateData.status = data.status;
      }
    }
    await this.userRepo.update(id, updateData);
    const user = await this.userRepo.findOne({ where: { id } });
    if (!user) throw new NotFoundException('用户不存在');
    const { password, ...rest } = user;
    return { ...rest, status: rest.status === 1 ? 'active' : 'disabled' };
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

  async updateCourse(id: number, data: { title?: string; description?: string; category?: string; teacherName?: string }) {
    const updateData: Partial<Course> = {};
    if (data.title !== undefined) updateData.title = data.title;
    if (data.description !== undefined) updateData.description = data.description;
    if (data.category !== undefined) updateData.category = data.category;
    if (data.teacherName !== undefined) updateData.teacherName = data.teacherName;
    await this.courseRepo.update(id, updateData);
    const course = await this.courseRepo.findOne({ where: { id } });
    if (!course) throw new NotFoundException('课程不存在');
    return { ...course, instructor: course.teacherName };
  }

  async deleteCourse(id: number) {
    await Promise.all([
      this.lessonRepo.delete({ courseId: id }),
      this.commentRepo.delete({ targetType: 'course', targetId: id }),
    ]);
    await this.courseRepo.delete(id);
    return { message: '已删除' };
  }

  // ===== 课时管理 =====
  async getCourseLessons(courseId: number) {
    const lessons = await this.lessonRepo.find({
      where: { courseId },
      order: { orderNum: 'ASC' },
    });
    return { list: lessons };
  }

  async createLesson(courseId: number, data: { title: string; videoUrl?: string; duration?: number; orderNum?: number }) {
    const course = await this.courseRepo.findOne({ where: { id: courseId } });
    if (!course) throw new NotFoundException('课程不存在');
    const lesson = this.lessonRepo.create({
      courseId,
      title: data.title,
      videoUrl: data.videoUrl || '',
      duration: data.duration || 0,
      orderNum: data.orderNum || 0,
    });
    return this.lessonRepo.save(lesson);
  }

  async updateLesson(id: number, data: { title?: string; videoUrl?: string; duration?: number; orderNum?: number }) {
    const updateData: Partial<Lesson> = {};
    if (data.title !== undefined) updateData.title = data.title;
    if (data.videoUrl !== undefined) updateData.videoUrl = data.videoUrl;
    if (data.duration !== undefined) updateData.duration = data.duration;
    if (data.orderNum !== undefined) updateData.orderNum = data.orderNum;
    await this.lessonRepo.update(id, updateData);
    const lesson = await this.lessonRepo.findOne({ where: { id } });
    if (!lesson) throw new NotFoundException('课时不存在');
    return lesson;
  }

  async deleteLesson(id: number) {
    await this.lessonRepo.delete(id);
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

  async getPostDetail(id: number) {
    const post = await this.postRepo.findOne({ where: { id } });
    if (!post) throw new NotFoundException('帖子不存在');
    const comments = await this.commentRepo.find({
      where: { targetType: 'post', targetId: id },
      order: { createdAt: 'ASC' },
    });
    return { ...post, comments };
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

  async updateClass(id: number, data: { name?: string; description?: string; teacherName?: string }) {
    const updateData: Partial<ClassEntity> = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.description !== undefined) updateData.description = data.description;
    if (data.teacherName !== undefined) updateData.teacherName = data.teacherName;
    await this.classRepo.update(id, updateData);
    const cls = await this.classRepo.findOne({ where: { id } });
    if (!cls) throw new NotFoundException('班级不存在');
    return cls;
  }

  async getClassDetail(id: number) {
    const cls = await this.classRepo.findOne({ where: { id } });
    if (!cls) throw new NotFoundException('班级不存在');

    // 获取成员列表
    const members = await this.classMemberRepo.find({ where: { classId: id } });
    const memberUsers = [];
    for (const m of members) {
      const user = await this.userRepo.findOne({ where: { id: m.userId } });
      if (user) {
        const { password, ...rest } = user;
        memberUsers.push({ ...rest, memberRole: m.role, joinedAt: m.joinedAt });
      }
    }

    // 获取该教师名下的课程列表
    const courses = await this.courseRepo.find({ where: { teacherName: cls.teacherName } });

    return { ...cls, members: memberUsers, courses };
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

  // ===== 教师管理 =====
  async getTeachers() {
    const teachers = await this.userRepo.find({ where: { role: 'teacher' }, order: { createdAt: 'DESC' } });
    return teachers.map(({ password, ...rest }) => ({
      ...rest,
      status: rest.status === 1 ? 'active' : 'disabled',
    }));
  }

  async createTeacher(data: { name: string; email: string; password?: string; bio?: string }) {
    const exists = await this.userRepo.findOne({ where: { email: data.email } });
    if (exists) {
      // 如果用户已存在，将其角色改为 teacher
      exists.role = 'teacher';
      if (data.name) exists.name = data.name;
      if (data.bio) exists.bio = data.bio;
      const saved = await this.userRepo.save(exists);
      const { password, ...rest } = saved;
      return { ...rest, status: rest.status === 1 ? 'active' : 'disabled' };
    }
    const hashed = await bcrypt.hash(data.password || 'teacher123', 10);
    const user = this.userRepo.create({
      name: data.name,
      email: data.email,
      password: hashed,
      role: 'teacher',
      bio: data.bio || '',
    });
    const saved = await this.userRepo.save(user);
    const { password, ...rest } = saved;
    return { ...rest, status: rest.status === 1 ? 'active' : 'disabled' };
  }
}
