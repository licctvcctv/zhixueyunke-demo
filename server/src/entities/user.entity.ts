import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column({ unique: true })
  email: string;

  @Column()
  password: string;

  @Column({ default: '' })
  avatar: string;

  @Column({ default: '' })
  bio: string;

  @Column({ default: 'user' })
  role: string;

  @Column({ default: 1 })
  status: number;

  @CreateDateColumn()
  createdAt: Date;
}
