import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Question } from '../entities/question.entity';
import { Answer } from '../entities/answer.entity';

@Injectable()
export class QaService {
  constructor(
    @InjectRepository(Question) private questionRepo: Repository<Question>,
    @InjectRepository(Answer) private answerRepo: Repository<Answer>,
  ) {}

  async findAll(courseId?: number) {
    const where: any = {};
    if (courseId) where.courseId = courseId;
    return this.questionRepo.find({ where, order: { createdAt: 'DESC' } });
  }

  async findOne(id: number) {
    const question = await this.questionRepo.findOne({ where: { id } });
    if (!question) throw new NotFoundException('问题不存在');
    const answers = await this.answerRepo.find({
      where: { questionId: id },
      order: { isAccepted: 'DESC', createdAt: 'ASC' },
    });
    return { ...question, answers };
  }

  async create(data: { courseId: number; title: string; content: string; authorId: number; authorName: string }) {
    const question = this.questionRepo.create(data);
    return this.questionRepo.save(question);
  }

  async addAnswer(questionId: number, authorId: number, authorName: string, content: string) {
    const question = await this.questionRepo.findOne({ where: { id: questionId } });
    if (!question) throw new NotFoundException('问题不存在');
    const answer = this.answerRepo.create({ questionId, authorId, authorName, content });
    await this.answerRepo.save(answer);
    question.answerCount += 1;
    await this.questionRepo.save(question);
    return answer;
  }

  async acceptAnswer(questionId: number, answerId: number) {
    const answer = await this.answerRepo.findOne({ where: { id: answerId, questionId } });
    if (!answer) throw new NotFoundException('回答不存在');
    answer.isAccepted = 1;
    const question = await this.questionRepo.findOne({ where: { id: questionId } });
    if (question) {
      question.solved = 1;
      await Promise.all([this.answerRepo.save(answer), this.questionRepo.save(question)]);
    } else {
      await this.answerRepo.save(answer);
    }
    return { message: '已采纳' };
  }
}
