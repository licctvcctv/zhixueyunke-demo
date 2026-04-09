import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/class_model.dart';
import 'class_detail_page.dart';

class ClassListPage extends StatelessWidget {
  const ClassListPage({Key? key}) : super(key: key);

  List<ClassModel> get _mockClasses => [
        ClassModel(
          id: 1,
          name: '2024级计算机科学A班',
          description: '计算机科学与技术专业2024级A班，主要学习编程、算法与数据结构等核心课程。',
          teacherName: '李教授',
          studentCount: 45,
          createdAt: DateTime(2024, 9, 1),
        ),
        ClassModel(
          id: 2,
          name: '2024级数学B班',
          description: '数学与应用数学专业2024级B班，涵盖高等数学、线性代数等基础课程。',
          teacherName: '王老师',
          studentCount: 38,
          createdAt: DateTime(2024, 9, 1),
        ),
        ClassModel(
          id: 3,
          name: '2024级英语精读班',
          description: '大学英语精读提高班，注重阅读与写作能力的培养。',
          teacherName: '张老师',
          studentCount: 52,
          createdAt: DateTime(2024, 9, 5),
        ),
        ClassModel(
          id: 4,
          name: '2024级人工智能实验班',
          description: '人工智能方向实验班，学习机器学习、深度学习等前沿技术。',
          teacherName: '陈教授',
          studentCount: 30,
          createdAt: DateTime(2024, 9, 3),
        ),
        ClassModel(
          id: 5,
          name: '2024级UI设计研修班',
          description: '用户界面设计研修班，学习Figma、Sketch等设计工具及设计原理。',
          teacherName: '刘老师',
          studentCount: 28,
          createdAt: DateTime(2024, 9, 10),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final classes = _mockClasses;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('我的班级')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: classes.length,
        itemBuilder: (context, index) {
          final cls = classes[index];
          return _buildClassCard(context, cls);
        },
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassModel cls) {
    final color = AppColors.fromId(cls.id);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ClassDetailPage(classModel: cls),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.class_, color: color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cls.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        cls.teacherName,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.people, size: 14, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        '${cls.studentCount}人',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF50C878).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '已加入',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF50C878),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
