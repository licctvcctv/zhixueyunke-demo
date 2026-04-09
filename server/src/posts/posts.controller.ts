import { Controller, Get, Post as HttpPost, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { PostsService } from './posts.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/posts')
export class PostsController {
  constructor(private postsService: PostsService) {}

  @Get()
  findAll(@Query('search') search?: string) {
    return this.postsService.findAll(search);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.postsService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard)
  @HttpPost()
  create(@Body() body: { content: string; imageUrl?: string }, @Request() req) {
    return this.postsService.create(req.user.id, req.user.name, body.content, body.imageUrl);
  }

  @UseGuards(JwtAuthGuard)
  @HttpPost(':id/comments')
  addComment(@Param('id') id: string, @Body() body: { content: string }, @Request() req) {
    return this.postsService.addComment(+id, req.user.id, req.user.name, body.content);
  }

  @UseGuards(JwtAuthGuard)
  @HttpPost(':id/like')
  like(@Param('id') id: string, @Request() req) {
    return this.postsService.like(+id, req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id')
  delete(@Param('id') id: string, @Request() req) {
    return this.postsService.deleteOwn(+id, req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Delete(':id/comments/:commentId')
  deleteComment(@Param('commentId') commentId: string, @Request() req) {
    return this.postsService.deleteOwnComment(+commentId, req.user.id);
  }
}
