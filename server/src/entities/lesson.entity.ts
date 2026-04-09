import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity()
export class Lesson {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  courseId: number;

  @Column()
  title: string;

  @Column({ default: '' })
  videoUrl: string;

  @Column({ default: 0 })
  duration: number;

  @Column({ default: 0 })
  orderNum: number;
}
