import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/lesson.dart';
import '../widgets/course_card.dart';
import 'qa_list_page.dart';
import 'class_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  List<Course> get _hotCourses => [
        Course(
          id: '1',
          title: 'Flutter移动开发实战',
          description: '从零开始学习Flutter跨平台开发',
          teacherName: '李教授',
          category: '编程',
          studentCount: 2341,
          rating: 4.9,
          lessons: [
            Lesson(id: '1', title: 'Flutter简介与环境搭建', duration: '15:30', order: 1),
            Lesson(id: '2', title: 'Dart语言基础', duration: '22:10', order: 2),
          ],
        ),
        Course(
          id: '2',
          title: '高等数学精讲',
          description: '大学高等数学全面系统讲解',
          teacherName: '王老师',
          category: '数学',
          studentCount: 3562,
          rating: 4.8,
          lessons: [],
        ),
        Course(
          id: '3',
          title: '大学英语四级冲刺',
          description: '英语四级考试技巧与真题解析',
          teacherName: '张老师',
          category: '英语',
          studentCount: 5120,
          rating: 4.7,
          lessons: [],
        ),
        Course(
          id: '4',
          title: 'Python人工智能入门',
          description: 'Python编程与AI基础知识',
          teacherName: '陈教授',
          category: '编程',
          studentCount: 1893,
          rating: 4.9,
          lessons: [],
        ),
        Course(
          id: '5',
          title: 'UI设计基础教程',
          description: '界面设计原理与Figma工具使用',
          teacherName: '刘老师',
          category: '设计',
          studentCount: 1245,
          rating: 4.6,
          lessons: [],
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.search, color: Colors.grey[400], size: 22),
                      const SizedBox(width: 8),
                      Text(
                        '搜索课程、老师、知识点...',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4A90D9), Color(0xFF6BB5FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          Icons.school,
                          size: 140,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              '欢迎来到智学云课',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '海量优质课程，名师在线授课\n随时随地，想学就学',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Quick access icons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAccess(Icons.live_tv, '直播课', const Color(0xFFFF6B6B)),
                    _buildQuickAccess(Icons.assignment, '题库', const Color(0xFFFFB347)),
                    _buildQuickAccess(Icons.emoji_events, '排行榜', const Color(0xFF50C878)),
                    _buildQuickAccess(Icons.calendar_today, '课表', const Color(0xFF4A90D9)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 快捷入口 section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '快捷入口',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShortcutItem(context, Icons.menu_book, '我的课程', const Color(0xFF4A90D9), null),
                    _buildShortcutItem(context, Icons.groups, '我的班级', const Color(0xFF50C878), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassListPage()));
                    }),
                    _buildShortcutItem(context, Icons.question_answer, '课程问答', const Color(0xFFFF6B6B), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QaListPage()));
                    }),
                    _buildShortcutItem(context, Icons.history, '学习记录', const Color(0xFFFFB347), null),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Hot courses section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '热门课程',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        '查看更多 >',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: _hotCourses.length,
                  itemBuilder: (context, index) {
                    return CourseCard(
                      course: _hotCourses[index],
                      isHorizontal: true,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/courseDetail',
                          arguments: _hotCourses[index],
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Announcements section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '最新公告',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '更多 >',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _buildAnnouncementItem(
                '关于2024年春季学期期末考试安排的通知',
                '2024-03-15',
                Icons.campaign,
                const Color(0xFFFF6B6B),
              ),
              _buildAnnouncementItem(
                '新课上线：人工智能与机器学习导论',
                '2024-03-14',
                Icons.new_releases,
                const Color(0xFF4A90D9),
              ),
              _buildAnnouncementItem(
                '系统升级维护通知（3月20日凌晨）',
                '2024-03-13',
                Icons.info_outline,
                const Color(0xFFFFB347),
              ),
              _buildAnnouncementItem(
                '优秀学员表彰：恭喜以下同学获得学习之星',
                '2024-03-12',
                Icons.star_outline,
                const Color(0xFF50C878),
              ),
              _buildAnnouncementItem(
                '关于开展线上学习竞赛活动的通知',
                '2024-03-11',
                Icons.emoji_events_outlined,
                const Color(0xFFDDA0DD),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildShortcutItem(BuildContext context, IconData icon, String label, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementItem(
      String title, String date, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[300], size: 20),
        ],
      ),
    );
  }
}
