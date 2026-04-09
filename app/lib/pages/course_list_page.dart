import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../widgets/course_card.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key}) : super(key: key);

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  String _selectedCategory = '全部';

  final List<String> _categories = ['全部', '编程', '数学', '英语', '物理', '设计'];

  final List<Course> _allCourses = [
    Course(
      id: '1',
      title: 'Flutter移动开发实战',
      description:
          '本课程从零开始讲解Flutter跨平台开发框架，涵盖Dart语言基础、Flutter组件体系、状态管理、网络请求、数据持久化等核心内容。通过多个实战项目，帮助学员掌握移动应用开发的核心技能。适合有一定编程基础的同学学习。',
      teacherName: '李教授',
      category: '编程',
      studentCount: 2341,
      rating: 4.9,
      lessons: [
        Lesson(id: '1', title: 'Flutter简介与环境搭建', duration: '15:30', order: 1),
        Lesson(id: '2', title: 'Dart语言基础语法', duration: '22:10', order: 2),
        Lesson(id: '3', title: 'Flutter基础组件', duration: '18:45', order: 3),
        Lesson(id: '4', title: '布局与样式', duration: '20:00', order: 4),
        Lesson(id: '5', title: '状态管理入门', duration: '25:15', order: 5),
        Lesson(id: '6', title: '网络请求与数据解析', duration: '19:30', order: 6),
      ],
    ),
    Course(
      id: '2',
      title: '高等数学精讲',
      description:
          '全面系统讲解高等数学知识，包括极限、导数、积分、微分方程等重要章节。通过大量例题和练习，帮助学生建立扎实的数学基础，提高分析问题和解决问题的能力。',
      teacherName: '王老师',
      category: '数学',
      studentCount: 3562,
      rating: 4.8,
      lessons: [
        Lesson(id: '7', title: '函数与极限', duration: '30:00', order: 1),
        Lesson(id: '8', title: '导数与微分', duration: '28:15', order: 2),
        Lesson(id: '9', title: '不定积分', duration: '25:40', order: 3),
        Lesson(id: '10', title: '定积分及其应用', duration: '32:00', order: 4),
      ],
    ),
    Course(
      id: '3',
      title: '大学英语四级冲刺',
      description:
          '针对大学英语四级考试的全面备考课程，包含听力、阅读、写作、翻译四大模块的解题技巧和真题训练。',
      teacherName: '张老师',
      category: '英语',
      studentCount: 5120,
      rating: 4.7,
      lessons: [
        Lesson(id: '11', title: '听力理解技巧', duration: '20:00', order: 1),
        Lesson(id: '12', title: '阅读理解方法', duration: '25:30', order: 2),
        Lesson(id: '13', title: '写作模板精讲', duration: '22:00', order: 3),
      ],
    ),
    Course(
      id: '4',
      title: 'Python人工智能入门',
      description:
          '从Python基础语法开始，逐步深入到数据分析、机器学习和深度学习的核心概念。通过实际案例让学生理解AI的基本原理。',
      teacherName: '陈教授',
      category: '编程',
      studentCount: 1893,
      rating: 4.9,
      lessons: [
        Lesson(id: '14', title: 'Python基础语法', duration: '18:00', order: 1),
        Lesson(id: '15', title: 'NumPy与数据处理', duration: '24:00', order: 2),
        Lesson(id: '16', title: '机器学习概论', duration: '30:00', order: 3),
      ],
    ),
    Course(
      id: '5',
      title: 'UI设计基础教程',
      description: '学习界面设计的基本原理，掌握Figma设计工具的使用方法，培养设计思维和审美能力。',
      teacherName: '刘老师',
      category: '设计',
      studentCount: 1245,
      rating: 4.6,
      lessons: [
        Lesson(id: '17', title: '设计原理与色彩理论', duration: '20:00', order: 1),
        Lesson(id: '18', title: 'Figma工具入门', duration: '18:30', order: 2),
      ],
    ),
    Course(
      id: '6',
      title: '大学物理（力学篇）',
      description: '系统讲解经典力学的基本概念和规律，包括牛顿运动定律、动量守恒、能量守恒等核心内容。',
      teacherName: '赵教授',
      category: '物理',
      studentCount: 2100,
      rating: 4.8,
      lessons: [
        Lesson(id: '19', title: '质点运动学', duration: '25:00', order: 1),
        Lesson(id: '20', title: '牛顿运动定律', duration: '28:00', order: 2),
      ],
    ),
    Course(
      id: '7',
      title: 'Java Web开发入门',
      description:
          '从Java基础到Web开发的完整学习路径，涵盖Servlet、JSP、Spring框架等核心技术。',
      teacherName: '孙老师',
      category: '编程',
      studentCount: 1756,
      rating: 4.5,
      lessons: [
        Lesson(id: '21', title: 'Java基础回顾', duration: '20:00', order: 1),
        Lesson(id: '22', title: 'Servlet与JSP', duration: '25:00', order: 2),
      ],
    ),
    Course(
      id: '8',
      title: '线性代数核心精讲',
      description: '深入浅出地讲解线性代数的核心概念，包括矩阵运算、向量空间、特征值等重要内容。',
      teacherName: '周教授',
      category: '数学',
      studentCount: 2890,
      rating: 4.7,
      lessons: [
        Lesson(id: '23', title: '矩阵与行列式', duration: '30:00', order: 1),
        Lesson(id: '24', title: '向量空间', duration: '28:00', order: 2),
      ],
    ),
    Course(
      id: '9',
      title: '商务英语实用会话',
      description: '针对职场场景的英语口语课程，提升商务沟通能力，涵盖会议、谈判、演示等常见场景。',
      teacherName: '吴老师',
      category: '英语',
      studentCount: 980,
      rating: 4.4,
      lessons: [
        Lesson(id: '25', title: '商务自我介绍', duration: '15:00', order: 1),
        Lesson(id: '26', title: '会议英语', duration: '20:00', order: 2),
      ],
    ),
    Course(
      id: '10',
      title: '电磁学基础',
      description: '系统讲解电磁学的基本理论，包括库仑定律、电场、磁场、电磁感应等内容。',
      teacherName: '赵教授',
      category: '物理',
      studentCount: 1560,
      rating: 4.6,
      lessons: [
        Lesson(id: '27', title: '静电场', duration: '26:00', order: 1),
        Lesson(id: '28', title: '磁场与安培力', duration: '24:00', order: 2),
      ],
    ),
  ];

  List<Course> get _filteredCourses {
    if (_selectedCategory == '全部') return _allCourses;
    return _allCourses
        .where((c) => c.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('全部课程'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          // Category chips
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      selectedColor: const Color(0xFF4A90D9),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey[700],
                        fontSize: 14,
                      ),
                      backgroundColor: Colors.grey[100],
                      onSelected: (selected) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Course grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _filteredCourses.length,
              itemBuilder: (context, index) {
                final course = _filteredCourses[index];
                return CourseCard(
                  course: course,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/courseDetail',
                      arguments: course,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
