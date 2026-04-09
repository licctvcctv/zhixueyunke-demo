import 'package:flutter/material.dart';
import '../models/class_model.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailPage({Key? key, required this.classModel}) : super(key: key);

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, String>> _mockStudents = const [
    {'name': '张三', 'role': '班长'},
    {'name': '李四', 'role': '学习委员'},
    {'name': '王五', 'role': '同学'},
    {'name': '赵六', 'role': '同学'},
    {'name': '孙七', 'role': '同学'},
    {'name': '周八', 'role': '同学'},
    {'name': '吴九', 'role': '同学'},
    {'name': '郑十', 'role': '同学'},
    {'name': '钱十一', 'role': '同学'},
    {'name': '陈十二', 'role': '同学'},
  ];

  final List<Map<String, String>> _mockCourses = const [
    {'title': 'Flutter移动开发实战', 'teacher': '李教授', 'count': '2341'},
    {'title': '数据结构与算法', 'teacher': '王老师', 'count': '1890'},
    {'title': '计算机网络基础', 'teacher': '张老师', 'count': '1562'},
    {'title': '操作系统原理', 'teacher': '陈教授', 'count': '1200'},
  ];

  final List<Map<String, String>> _mockPosts = const [
    {'title': '关于期中考试安排的通知', 'date': '2024-03-15', 'content': '期中考试将于4月10日至4月14日进行，请同学们做好复习准备。'},
    {'title': '课程实验报告提交提醒', 'date': '2024-03-12', 'content': '请各位同学在3月20日前提交第二次实验报告，逾期不予受理。'},
    {'title': '班级春游活动报名', 'date': '2024-03-10', 'content': '本周六组织班级春游活动，有意参加的同学请在群内接龙报名。'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cls = widget.classModel;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(cls.name)),
      body: Column(
        children: [
          // Class info header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF5F6FA),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cls.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  cls.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.person, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      '教师：${cls.teacherName}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 20),
                    Icon(Icons.people, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      '${cls.studentCount}名成员',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tab bar
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF4A90D9),
            unselectedLabelColor: Colors.grey[500],
            indicatorColor: const Color(0xFF4A90D9),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: '成员'),
              Tab(text: '课程'),
              Tab(text: '动态'),
            ],
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembersTab(),
                _buildCoursesTab(),
                _buildPostsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _mockStudents.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final student = _mockStudents[index];
        final colors = [
          const Color(0xFF4A90D9),
          const Color(0xFF50C878),
          const Color(0xFFFF6B6B),
          const Color(0xFFFFB347),
          const Color(0xFFDDA0DD),
        ];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: colors[index % colors.length],
            child: Text(
              student['name']![0],
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          title: Text(student['name']!, style: const TextStyle(fontSize: 14)),
          trailing: student['role'] != '同学'
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90D9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    student['role']!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF4A90D9),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildCoursesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockCourses.length,
      itemBuilder: (context, index) {
        final course = _mockCourses[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90D9).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book,
                    color: Color(0xFF4A90D9), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course['title']!,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course['teacher']}  |  ${course['count']}人已学',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[300], size: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPostsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mockPosts.length,
      itemBuilder: (context, index) {
        final post = _mockPosts[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.campaign,
                      size: 18, color: Color(0xFFFF6B6B)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      post['title']!,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post['content']!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post['date']!,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      },
    );
  }
}
