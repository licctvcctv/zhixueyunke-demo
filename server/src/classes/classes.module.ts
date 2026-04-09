import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClassEntity } from '../entities/class.entity';
import { ClassMember } from '../entities/class-member.entity';
import { Course } from '../entities/course.entity';
import { Post } from '../entities/post.entity';
import { User } from '../entities/user.entity';
import { ClassesService } from './classes.service';
import { ClassesController } from './classes.controller';

@Module({
  imports: [TypeOrmModule.forFeature([ClassEntity, ClassMember, User, Course, Post])],
  controllers: [ClassesController],
  providers: [ClassesService],
})
export class ClassesModule {}
