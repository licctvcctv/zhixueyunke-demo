import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Comment {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  targetType: string;

  @Column()
  targetId: number;

  @Column()
  authorId: number;

  @Column()
  authorName: string;

  @Column('text')
  content: string;

  @CreateDateColumn()
  createdAt: Date;
}
