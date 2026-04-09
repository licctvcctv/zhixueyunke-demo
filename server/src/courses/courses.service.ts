import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Course } from '../entities/course.entity';
import { Lesson } from '../entities/lesson.entity';
import { Comment } from '../entities/comment.entity';
import { Enrollment } from '../entities/enrollment.entity';
import { Progress } from '../entities/progress.entity';

@Injectable()
export class CoursesService {
  constructor(
    @InjectRepository(Course) private courseRepo: Repository<Course>,
    @InjectRepository(Lesson) private lessonRepo: Repository<Lesson>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
    @InjectRepository(Enrollment) private enrollmentRepo: Repository<Enrollment>,
    @InjectRepository(Progress) private progressRepo: Repository<Progress>,
  ) {}

  async findAll(category?: string, search?: string) {
    let query = this.courseRepo.createQueryBuilder('course');
    if (category) query = query.where('course.category = :category', { category });
    if (search) {
      const like = `%${search}%`;
      query = query.andWhere('(course.title LIKE :s OR course.description LIKE :s OR course.teacherName LIKE :s)', { s: like });
    }
    query = query.orderBy('course.createdAt', 'DESC');
    const courses = await query.getMany();
    const result = [];
    for (const c of courses) {
      const lessonCount = await this.lessonRepo.count({ where: { courseId: c.id } });
      result.push({ ...c, lessonCount });
    }
    return result;
  }

  async findOne(id: number) {
    const course = await this.courseRepo.findOne({ where: { id } });
    if (!course) throw new NotFoundException('课程不存在');
    const lessons = await this.lessonRepo.find({ where: { courseId: id }, order: { orderNum: 'ASC' } });
    const formattedLessons = lessons.map(l => ({
      ...l,
      durationText: `${Math.floor(l.duration / 60)}:${String(l.duration % 60).padStart(2, '0')}`,
    }));
    return { ...course, lessons: formattedLessons };
  }

  async create(data: Partial<Course>) {
    const course = this.courseRepo.create(data);
    return this.courseRepo.save(course);
  }

  async addLesson(courseId: number, data: Partial<Lesson>) {
    const course = await this.courseRepo.findOne({ where: { id: courseId } });
    if (!course) throw new NotFoundException('课程不存在');
    const count = await this.lessonRepo.count({ where: { courseId } });
    const lesson = this.lessonRepo.create({ ...data, courseId, orderNum: count + 1 });
    return this.lessonRepo.save(lesson);
  }

  async getComments(courseId: number) {
    return this.commentRepo.find({
      where: { targetType: 'course', targetId: courseId },
      order: { createdAt: 'DESC' },
    });
  }

  async addComment(courseId: number, authorId: number, authorName: string, content: string) {
    const comment = this.commentRepo.create({
      targetType: 'course',
      targetId: courseId,
      authorId,
      authorName,
      content,
    });
    return this.commentRepo.save(comment);
  }

  // ===== Enrollment =====

  async enroll(courseId: number, userId: number) {
    const course = await this.courseRepo.findOne({ where: { id: courseId } });
    if (!course) throw new NotFoundException('课程不存在');
    const existing = await this.enrollmentRepo.findOne({ where: { courseId, userId } });
    if (existing) throw new BadRequestException('已报名该课程');
    const enrollment = this.enrollmentRepo.create({ courseId, userId });
    await this.enrollmentRepo.save(enrollment);
    course.studentCount = (course.studentCount || 0) + 1;
    await this.courseRepo.save(course);
    return enrollment;
  }

  async getEnrollments(userId: number) {
    const enrollments = await this.enrollmentRepo.find({ where: { userId } });
    const courses = [];
    for (const e of enrollments) {
      const course = await this.courseRepo.findOne({ where: { id: e.courseId } });
      if (course) courses.push(course);
    }
    return courses;
  }

  async isEnrolled(courseId: number, userId: number): Promise<boolean> {
    const enrollment = await this.enrollmentRepo.findOne({ where: { courseId, userId } });
    return !!enrollment;
  }

  // ===== Progress =====

  async updateProgress(userId: number, courseId: number, lessonId: number) {
    const course = await this.courseRepo.findOne({ where: { id: courseId } });
    if (!course) throw new NotFoundException('课程不存在');
    const lesson = await this.lessonRepo.findOne({ where: { id: lessonId, courseId } });
    if (!lesson) throw new NotFoundException('课时不存在');
    let progress = await this.progressRepo.findOne({ where: { userId, courseId, lessonId } });
    if (progress) {
      progress.completed = 1;
      return this.progressRepo.save(progress);
    }
    progress = this.progressRepo.create({ userId, courseId, lessonId, completed: 1 });
    return this.progressRepo.save(progress);
  }

  async getCourseProgress(userId: number, courseId: number) {
    return this.progressRepo.find({ where: { userId, courseId, completed: 1 } });
  }
}
