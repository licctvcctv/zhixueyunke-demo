import { Controller, Get, Post, Body, Param, UseGuards, Request } from '@nestjs/common';
import { ClassesService } from './classes.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/classes')
export class ClassesController {
  constructor(private classesService: ClassesService) {}

  @Get()
  findAll() {
    return this.classesService.findAll();
  }

  @UseGuards(JwtAuthGuard)
  @Get('my/joined')
  getMyJoined(@Request() req) {
    return this.classesService.getJoinedClassIds(req.user.id);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.classesService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() body: any) {
    return this.classesService.create(body);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/join')
  join(@Param('id') id: string, @Request() req) {
    return this.classesService.join(+id, req.user.id);
  }

  @Get(':id/members')
  getMembers(@Param('id') id: string) {
    return this.classesService.getMembers(+id);
  }
}
