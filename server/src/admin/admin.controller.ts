import { Controller, Get, Post, Put, Patch, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { AdminService } from './admin.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/admin')
@UseGuards(JwtAuthGuard)
export class AdminController {
  constructor(private adminService: AdminService) {}

  @Get('stats')
  getStats(@Request() req) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getStats();
  }

  // ===== 用户管理 =====
  @Get('users')
  getUsers(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getUsers(skip ? +skip : 0, limit ? +limit : 20, search);
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
  getCourses(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getCourses(skip ? +skip : 0, limit ? +limit : 20, search);
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
  getPosts(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getPosts(skip ? +skip : 0, limit ? +limit : 20, search);
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
  getClasses(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getClasses(skip ? +skip : 0, limit ? +limit : 20, search);
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

  @Post('classes/:id/courses')
  getClassCourses(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    // 返回该班级详情（含教师课程列表）
    return this.adminService.getClassDetail(+id);
  }

  @Delete('classes/:id')
  deleteClass(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteClass(+id);
  }

  // ===== 问答管理 =====
  @Get('questions')
  getQuestions(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getQuestions(skip ? +skip : 0, limit ? +limit : 20, search);
  }

  @Delete('questions/:id')
  deleteQuestion(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteQuestion(+id);
  }

  // ===== 教师管理 =====
  @Get('teachers')
  getTeachers(@Request() req) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getTeachers();
  }

  @Post('teachers')
  createTeacher(@Request() req, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.createTeacher(body);
  }
}
