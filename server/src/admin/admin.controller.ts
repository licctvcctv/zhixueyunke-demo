import { Controller, Get, Put, Patch, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
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
    const numStatus = body.status === 'active' ? 1 : 0;
    return this.adminService.updateUser(+id, { status: numStatus } as any);
  }

  @Get('courses')
  getCourses(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getCourses(skip ? +skip : 0, limit ? +limit : 20, search);
  }

  @Delete('courses/:id')
  deleteCourse(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteCourse(+id);
  }

  @Get('posts')
  getPosts(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getPosts(skip ? +skip : 0, limit ? +limit : 20, search);
  }

  @Delete('posts/:id')
  deletePost(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deletePost(+id);
  }

  @Get('classes')
  getClasses(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string, @Query('search') search?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getClasses(skip ? +skip : 0, limit ? +limit : 20, search);
  }

  @Delete('classes/:id')
  deleteClass(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteClass(+id);
  }

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
}
