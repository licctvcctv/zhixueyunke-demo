import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from '../entities/post.entity';
import { Comment } from '../entities/comment.entity';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post) private postRepo: Repository<Post>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
  ) {}

  async findAll() {
    return this.postRepo.find({ order: { createdAt: 'DESC' } });
  }

  async findOne(id: number) {
    const post = await this.postRepo.findOne({ where: { id } });
    if (!post) throw new NotFoundException('帖子不存在');
    const comments = await this.commentRepo.find({
      where: { targetType: 'post', targetId: id },
      order: { createdAt: 'ASC' },
    });
    return { ...post, comments };
  }

  async create(authorId: number, authorName: string, content: string, imageUrl?: string) {
    const post = this.postRepo.create({ authorId, authorName, content, imageUrl: imageUrl || '' });
    return this.postRepo.save(post);
  }

  async addComment(postId: number, authorId: number, authorName: string, content: string) {
    const post = await this.postRepo.findOne({ where: { id: postId } });
    if (!post) throw new NotFoundException('帖子不存在');
    const comment = this.commentRepo.create({
      targetType: 'post',
      targetId: postId,
      authorId,
      authorName,
      content,
    });
    await this.commentRepo.save(comment);
    post.commentCount += 1;
    await this.postRepo.save(post);
    return comment;
  }

  async like(postId: number) {
    const post = await this.postRepo.findOne({ where: { id: postId } });
    if (!post) throw new NotFoundException('帖子不存在');
    post.likes += 1;
    await this.postRepo.save(post);
    return { likes: post.likes };
  }
}
