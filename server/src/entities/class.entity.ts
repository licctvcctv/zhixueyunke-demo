import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('classes')
export class ClassEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ default: '' })
  description: string;

  @Column()
  teacherName: string;

  @Column({ default: 0 })
  studentCount: number;

  @Column({ default: 1 })
  status: number;

  @CreateDateColumn()
  createdAt: Date;
}
