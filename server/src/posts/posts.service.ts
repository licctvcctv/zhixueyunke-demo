import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post } from '../entities/post.entity';
import { Comment } from '../entities/comment.entity';
import { Like } from '../entities/like.entity';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post) private postRepo: Repository<Post>,
    @InjectRepository(Comment) private commentRepo: Repository<Comment>,
    @InjectRepository(Like) private likeRepo: Repository<Like>,
  ) {}

  async findAll(search?: string) {
    let query = this.postRepo.createQueryBuilder('post');
    if (search) {
      const like = `%${search}%`;
      query = query.where('(post.content LIKE :s OR post.authorName LIKE :s)', { s: like });
    }
    query = query.orderBy('post.createdAt', 'DESC');
    return query.getMany();
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

  async like(postId: number, userId: number) {
    const post = await this.postRepo.findOne({ where: { id: postId } });
    if (!post) throw new NotFoundException('帖子不存在');
    const existing = await this.likeRepo.findOne({
      where: { userId, targetType: 'post', targetId: postId },
    });
    if (existing) {
      await this.likeRepo.remove(existing);
      post.likes = Math.max(0, post.likes - 1);
      await this.postRepo.save(post);
      return { likes: post.likes, isLiked: false };
    } else {
      const like = this.likeRepo.create({ userId, targetType: 'post', targetId: postId });
      await this.likeRepo.save(like);
      post.likes += 1;
      await this.postRepo.save(post);
      return { likes: post.likes, isLiked: true };
    }
  }

  async deleteOwn(postId: number, userId: number) {
    const post = await this.postRepo.findOne({ where: { id: postId } });
    if (!post) throw new NotFoundException('帖子不存在');
    if (post.authorId !== userId) throw new ForbiddenException('只能删除自己的帖子');
    await Promise.all([
      this.commentRepo.delete({ targetType: 'post', targetId: postId }),
      this.likeRepo.delete({ targetType: 'post', targetId: postId }),
    ]);
    await this.postRepo.remove(post);
    return { message: '已删除' };
  }

  async deleteOwnComment(commentId: number, userId: number) {
    const comment = await this.commentRepo.findOne({ where: { id: commentId } });
    if (!comment) throw new NotFoundException('评论不存在');
    if (comment.authorId !== userId) throw new ForbiddenException('只能删除自己的评论');
    const post = await this.postRepo.findOne({ where: { id: comment.targetId } });
    await this.commentRepo.remove(comment);
    if (post) {
      post.commentCount = Math.max(0, post.commentCount - 1);
      await this.postRepo.save(post);
    }
    return { message: '已删除' };
  }
}
