import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class Course {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  title: string;

  @Column({ default: '' })
  description: string;

  @Column({ default: '' })
  coverImage: string;

  @Column()
  teacherName: string;

  @Column({ default: '编程' })
  category: string;

  @Column({ type: 'float', default: 4.5 })
  rating: number;

  @Column({ default: 0 })
  studentCount: number;

  @Column({ default: 1 })
  status: number;

  @CreateDateColumn()
  createdAt: Date;
}
