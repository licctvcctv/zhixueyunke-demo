import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Course } from '../entities/course.entity';
import { Lesson } from '../entities/lesson.entity';
import { Comment } from '../entities/comment.entity';

@Injectable()
export class CoursesService {
  constructor(
    @InjectRepository(Course) private courseRepo: Repository<Course>,
    @InjectRepository(Lesson) private lessonRepo: Repository<Lesson>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
  ) {}

  async findAll(category?: string) {
    const where: any = {};
    if (category) where.category = category;
    const courses = await this.courseRepo.find({ where, order: { createdAt: 'DESC' } });
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
    return { ...course, lessons };
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
}
