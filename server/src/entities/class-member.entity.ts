import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class ClassMember {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  classId: number;

  @Column()
  userId: number;

  @Column({ default: 'student' })
  role: string;

  @CreateDateColumn()
  joinedAt: Date;
}
