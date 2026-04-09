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
import { Enrollment } from './entities/enrollment.entity';
import { Progress } from './entities/progress.entity';
import { Like } from './entities/like.entity';
import { AuthModule } from './auth/auth.module';
import { CoursesModule } from './courses/courses.module';
import { ClassesModule } from './classes/classes.module';
import { PostsModule } from './posts/posts.module';
import { QaModule } from './qa/qa.module';
import { AdminModule } from './admin/admin.module';
import { UploadModule } from './upload/upload.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'sqljs',
      autoSave: true,
      location: join(__dirname, '..', 'data.db'),
      entities: [User, Course, Lesson, ClassEntity, ClassMember, Post, Comment, Question, Answer, Enrollment, Progress, Like],
      synchronize: true,
    }),
    AuthModule,
    CoursesModule,
    ClassesModule,
    PostsModule,
    QaModule,
    AdminModule,
    UploadModule,
  ],
})
export class AppModule {}
