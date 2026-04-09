import { Controller, Get, Patch, Delete, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
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
  getUsers(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getUsers(skip ? +skip : 0, limit ? +limit : 20);
  }

  @Patch('users/:id')
  updateUser(@Request() req, @Param('id') id: string, @Body() body: any) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.updateUser(+id, body);
  }

  @Get('courses')
  getCourses(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getCourses(skip ? +skip : 0, limit ? +limit : 20);
  }

  @Delete('courses/:id')
  deleteCourse(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deleteCourse(+id);
  }

  @Get('posts')
  getPosts(@Request() req, @Query('skip') skip?: string, @Query('limit') limit?: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.getPosts(skip ? +skip : 0, limit ? +limit : 20);
  }

  @Delete('posts/:id')
  deletePost(@Request() req, @Param('id') id: string) {
    this.adminService.checkAdmin(req.user.role);
    return this.adminService.deletePost(+id);
  }
}
