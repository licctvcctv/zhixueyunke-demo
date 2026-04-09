import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Answer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  questionId: number;

  @Column()
  authorId: number;

  @Column()
  authorName: string;

  @Column('text')
  content: string;

  @Column({ default: 0 })
  isAccepted: number;

  @CreateDateColumn()
  createdAt: Date;
}
