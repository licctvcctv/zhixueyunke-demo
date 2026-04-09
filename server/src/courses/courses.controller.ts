import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/courses')
export class CoursesController {
  constructor(private coursesService: CoursesService) {}

  @Get()
  findAll(@Query('category') category?: string) {
    return this.coursesService.findAll(category);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.coursesService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() body: any) {
    return this.coursesService.create(body);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/lessons')
  addLesson(@Param('id') id: string, @Body() body: any) {
    return this.coursesService.addLesson(+id, body);
  }

  @Get(':id/comments')
  getComments(@Param('id') id: string) {
    return this.coursesService.getComments(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/comments')
  addComment(@Param('id') id: string, @Body() body: { content: string }, @Request() req) {
    return this.coursesService.addComment(+id, req.user.id, req.user.name, body.content);
  }
}
