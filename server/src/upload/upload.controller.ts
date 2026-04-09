import { Controller, Post, UseInterceptors, UploadedFile, UseGuards, BadRequestException } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { AdminGuard } from '../auth/admin.guard';
import { diskStorage } from 'multer';
import { join } from 'path';

const SAFE_EXT: Record<string, string> = {
  'video/mp4': '.mp4',
  'video/webm': '.webm',
  'video/quicktime': '.mov',
  'video/x-msvideo': '.avi',
  'video/x-matroska': '.mkv',
};

@Controller('api/upload')
@UseGuards(JwtAuthGuard, AdminGuard)
export class UploadController {
  @Post('video')
  @UseInterceptors(FileInterceptor('file', {
    storage: diskStorage({
      destination: join(__dirname, '..', '..', 'uploads'),
      filename: (req, file, cb) => {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1e9);
        const ext = SAFE_EXT[file.mimetype] ?? '.mp4';
        cb(null, `video-${uniqueSuffix}${ext}`);
      },
    }),
    limits: { fileSize: 500 * 1024 * 1024 }, // 500MB
    fileFilter: (req, file, cb) => {
      if (!SAFE_EXT[file.mimetype]) {
        cb(new BadRequestException('只能上传视频文件 (mp4/webm/mov/avi/mkv)'), false);
        return;
      }
      cb(null, true);
    },
  }))
  uploadVideo(@UploadedFile() file: Express.Multer.File) {
    if (!file) throw new BadRequestException('请选择视频文件');
    return {
      url: `/uploads/${file.filename}`,
      originalName: file.originalname,
      size: file.size,
    };
  }
}
