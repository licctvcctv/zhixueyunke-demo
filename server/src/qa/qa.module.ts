import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Question } from '../entities/question.entity';
import { Answer } from '../entities/answer.entity';
import { QaService } from './qa.service';
import { QaController } from './qa.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Question, Answer])],
  controllers: [QaController],
  providers: [QaService],
})
export class QaModule {}
