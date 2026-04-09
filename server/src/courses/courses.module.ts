import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Course } from '../entities/course.entity';
import { Lesson } from '../entities/lesson.entity';
import { Comment } from '../entities/comment.entity';
import { CoursesService } from './courses.service';
import { CoursesController } from './courses.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Course, Lesson, Comment])],
  controllers: [CoursesController],
  providers: [CoursesService],
})
export class CoursesModule {}
