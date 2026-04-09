import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { join } from 'path';
import { User } from './entities/user.entity';
import { Course } from './entities/course.entity';
import { Lesson } from './entities/lesson.entity';
import { ClassEntity } from './entities/class.entity';
import { ClassMember } from './entities/class-member.entity';
import { Post } from './entities/post.entity';
import { Comment } from './entities/comment.entity';
import { Question } from './entities/question.entity';
import { Answer } from './entities/answer.entity';
import { AuthModule } from './auth/auth.module';
import { CoursesModule } from './courses/courses.module';
import { ClassesModule } from './classes/classes.module';
import { PostsModule } from './posts/posts.module';
import { QaModule } from './qa/qa.module';
import { AdminModule } from './admin/admin.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'better-sqlite3',
      database: join(__dirname, '..', 'data.db'),
      entities: [User, Course, Lesson, ClassEntity, ClassMember, Post, Comment, Question, Answer],
      synchronize: true,
    }),
    AuthModule,
    CoursesModule,
    ClassesModule,
    PostsModule,
    QaModule,
    AdminModule,
  ],
})
export class AppModule {}
