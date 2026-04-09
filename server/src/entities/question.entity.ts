import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Question {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  courseId: number;

  @Column()
  authorId: number;

  @Column()
  authorName: string;

  @Column('text')
  title: string;

  @Column('text')
  content: string;

  @Column({ default: 0 })
  answerCount: number;

  @Column({ default: 0 })
  solved: number;

  @CreateDateColumn()
  createdAt: Date;
}
