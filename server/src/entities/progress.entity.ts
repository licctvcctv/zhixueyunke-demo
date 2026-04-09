import { Entity, PrimaryGeneratedColumn, Column, UpdateDateColumn } from 'typeorm';

@Entity()
export class Progress {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @Column()
  courseId: number;

  @Column()
  lessonId: number;

  @Column({ default: 0 })
  completed: number;

  @UpdateDateColumn()
  updatedAt: Date;
}
