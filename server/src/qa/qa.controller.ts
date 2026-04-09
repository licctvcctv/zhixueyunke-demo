import { Controller, Get, Post, Body, Param, Query, UseGuards, Request } from '@nestjs/common';
import { QaService } from './qa.service';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';

@Controller('api/qa')
export class QaController {
  constructor(private qaService: QaService) {}

  @Get()
  findAll(@Query('courseId') courseId?: string) {
    return this.qaService.findAll(courseId ? +courseId : undefined);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.qaService.findOne(+id);
  }

  @UseGuards(JwtAuthGuard)
  @Post()
  create(@Body() body: { courseId: number; title: string; content: string }, @Request() req) {
    return this.qaService.create({
      courseId: body.courseId,
      title: body.title,
      content: body.content,
      authorId: req.user.id,
      authorName: req.user.name,
    });
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/answers')
  addAnswer(@Param('id') id: string, @Body() body: { content: string }, @Request() req) {
    return this.qaService.addAnswer(+id, req.user.id, req.user.name, body.content);
  }

  @UseGuards(JwtAuthGuard)
  @Post(':id/accept/:answerId')
  acceptAnswer(@Param('id') id: string, @Param('answerId') answerId: string) {
    return this.qaService.acceptAnswer(+id, +answerId);
  }
}
