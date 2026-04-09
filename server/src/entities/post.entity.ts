import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Post {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  authorId: number;

  @Column()
  authorName: string;

  @Column('text')
  content: string;

  @Column({ default: '' })
  imageUrl: string;

  @Column({ default: 0 })
  likes: number;

  @Column({ default: 0 })
  commentCount: number;

  @CreateDateColumn()
  createdAt: Date;
}
