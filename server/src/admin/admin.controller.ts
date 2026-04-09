import { Controller, Get, Post, Put, Patch, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/admin')
@UseGuards(JwtAuthGuard)
export class AdminController {
  constructor(private adminService: AdminService) {}

  private parsePagination(page?: string, pageSize?: string, skip?: string, limit?: string) {
    const p = page ? +page : undefined;
    const ps = pageSize ? +pageSize : undefined;
    return {
      skip: p && ps ? (p - 1) * ps : (skip ? +skip : 0),
      limit: ps || (limit ? +limit : 20),
    };
  }

  @Get('stats')
  getStats(@Request() req) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getStats();
  }

  // ===== 用户管理 =====
  @Get('users')
  getUsers(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getUsers(pg.skip, pg.limit, search);
  }

  @Patch('users/:id')
  updateUser(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateUser(+id, body);
  }

  @Put('users/:id/status')
  updateUserStatus(@Param('id') id: string, @Body() body: { status: string }, @Request() req) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateUser(+id, { status: body.status });
  }

  // ===== 课程管理 =====
  @Get('courses')
  getCourses(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getCourses(pg.skip, pg.limit, search);
  }

  @Put('courses/:id')
  updateCourse(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateCourse(+id, body);
  }

  @Delete('courses/:id')
  deleteCourse(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteCourse(+id);
  }

  // ===== 课时管理 =====
  @Get('courses/:id/lessons')
  getCourseLessons(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getCourseLessons(+id);
  }

  @Post('courses/:id/lessons')
  createLesson(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.createLesson(+id, body);
  }

  @Put('lessons/:id')
  updateLesson(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateLesson(+id, body);
  }

  @Delete('lessons/:id')
  deleteLesson(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteLesson(+id);
  }

  // ===== 帖子管理 =====
  @Get('posts')
  getPosts(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getPosts(pg.skip, pg.limit, search);
  }

  @Get('posts/:id/comments')
  getPostComments(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getPostComments(+id);
  }

  @Delete('posts/:id/comments/:commentId')
  deletePostComment(@Request() req, @Param('id') id: string, @Param('commentId') commentId: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteComment(+commentId);
  }

  @Get('posts/:id')
  getPostDetail(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getPostDetail(+id);
  }

  @Delete('posts/:id')
  deletePost(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deletePost(+id);
  }

  // ===== 班级管理 =====
  @Get('classes')
  getClasses(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getClasses(pg.skip, pg.limit, search);
  }

  @Post('classes')
  createClass(@Request() req, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.createClass(body);
  }

  @Put('classes/:id')
  updateClass(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateClass(+id, body);
  }

  @Get('classes/:id/members')
  getClassDetail(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getClassDetail(+id);
  }

  @Delete('classes/:id')
  deleteClass(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteClass(+id);
  }

  // ===== 问答管理 =====
  @Get('questions')
  getQuestions(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getQuestions(pg.skip, pg.limit, search);
  }

  @Delete('questions/:id')
  deleteQuestion(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteQuestion(+id);
  }

  // ===== 评论管理 =====
  @Get('comments')
  getComments(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getComments(pg.skip, pg.limit, search);
  }

  @Delete('comments/:id')
  deleteComment(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteComment(+id);
  }

  // ===== 教师管理 =====
  @Get('teachers')
  getTeachers(@Request() req, @Query('page') page?: string, @Query('pageSize') pageSize?: string, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    const pg = this.parsePagination(page, pageSize, skip, limit);
    return this.adminService.getTeachers(pg.skip, pg.limit, search);
  }

  @Post('teachers')
  createTeacher(@Request() req, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.createTeacher(body);
  }

  @Patch('teachers/:id')
  updateTeacher(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateUser(+id, body);
  }

  @Get('teachers/:id/courses')
  getTeacherCourses(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getTeacherCourses(+id);
  }
}
