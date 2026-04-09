import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { CoursesService } from './courses.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminGuard } from '../auth/admin.guard';

@Controller('api/courses')
export class CoursesController {
  constructor(private coursesService: CoursesService) {}

  @Get()
  findAll(@Query('category') category?: string, @Query('search') search?: string) {
    return this.coursesService.findAll(category, search);
  }

  @Get('my/enrolled')
  @UseGuards(JwtAuthGuard)
  getMyEnrolled(@Request() req) {
    return this.coursesService.getEnrollments(req.user.id);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.coursesService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard, AdminGuard)
  @Post()
  create(@Body() body: any) {
    return this.coursesService.create(body);
  }

  @UseGuards(JwtAuthGuard, AdminGuard)
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

  @UseGuards(JwtAuthGuard)
  @Post(':id/enroll')
  enroll(@Param('id') id: string, @Request() req) {
    return this.coursesService.enroll(+id, req.user.id);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/progress')
  updateProgress(@Param('id') id: string, @Body() body: { lessonId: number }, @Request() req) {
    return this.coursesService.updateProgress(req.user.id, +id, body.lessonId);
  }

  @UseGuards(JwtAuthGuard)
  @Get(':id/progress')
  getCourseProgress(@Param('id') id: string, @Request() req) {
    return this.coursesService.getCourseProgress(req.user.id, +id);
  }
}
