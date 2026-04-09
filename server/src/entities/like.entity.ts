import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Like {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @Column()
  targetType: string; // 'post'

  @Column()
  targetId: number;

  @CreateDateColumn()
  createdAt: Date;
}
