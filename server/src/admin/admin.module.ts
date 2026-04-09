import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../entities/user.entity';
import { Course } from '../entities/course.entity';
import { Lesson } from '../entities/lesson.entity';
import { Post } from '../entities/post.entity';
import { Comment } from '../entities/comment.entity';
import { ClassEntity } from '../entities/class.entity';
import { Question } from '../entities/question.entity';
import { AdminService } from './admin.service';
import { AdminController } from './admin.controller';

@Module({
  imports: [TypeOrmModule.forFeature([User, Course, Lesson, Post, Comment, ClassEntity, Question])],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
