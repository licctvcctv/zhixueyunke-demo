import { Injectable, BadRequestException, UnauthorizedException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';
import { User } from '../entities/user.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User) private userRepo: Repository<User>,
    private jwtService: JwtService,
  ) {}

  private signToken(user: User) {
    const payload = { sub: user.id, email: user.email, role: user.role, name: user.name };
    return this.jwtService.sign(payload);
  }

  private sanitize(user: User) {
    const { password, ...rest } = user;
    return rest;
  }

  async register(name: string, email: string, password: string) {
    const exists = await this.userRepo.findOne({ where: { email } });
    if (exists) throw new BadRequestException('邮箱已注册');
    const hashed = await bcrypt.hash(password, 10);
    const user = this.userRepo.create({ name, email, password: hashed });
    const saved = await this.userRepo.save(user);
    return { token: this.signToken(saved), user: this.sanitize(saved) };
  }

  async login(email: string, password: string) {
    const user = await this.userRepo.findOne({ where: { email } });
    if (!user) throw new UnauthorizedException('邮箱或密码错误');
    const valid = await bcrypt.compare(password, user.password);
    if (!valid) throw new UnauthorizedException('邮箱或密码错误');
    if (user.status === 0) throw new UnauthorizedException('账号已被禁用');
    return { token: this.signToken(user), user: this.sanitize(user) };
  }

  async getProfile(userId: number) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new UnauthorizedException('用户不存在');
    return this.sanitize(user);
  }

  async updateProfile(userId: number, body: { name?: string; bio?: string; avatar?: string }) {
    const user = await this.userRepo.findOne({ where: { id: userId } });
    if (!user) throw new UnauthorizedException('用户不存在');
    if (body.name !== undefined) user.name = body.name;
    if (body.bio !== undefined) user.bio = body.bio;
    if (body.avatar !== undefined) user.avatar = body.avatar;
    const saved = await this.userRepo.save(user);
    return this.sanitize(saved);
  }
}
