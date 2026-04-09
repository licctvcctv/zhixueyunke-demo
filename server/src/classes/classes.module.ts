import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ClassEntity } from '../entities/class.entity';
import { ClassMember } from '../entities/class-member.entity';
import { User } from '../entities/user.entity';
import { ClassesService } from './classes.service';
import { ClassesController } from './classes.controller';

@Module({
  imports: [TypeOrmModule.forFeature([ClassEntity, ClassMember, User])],
  controllers: [ClassesController],
  providers: [ClassesService],
})
export class ClassesModule {}
