import 'package:flutter/material.dart';
import '../config/api.dart';
import '../models/class_model.dart';
import '../services/api_service.dart';

class ClassDetailPage extends StatefulWidget {
  final ClassModel classModel;

  const ClassDetailPage({Key? key, required this.classModel}) : super(key: key);

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _courses = [];
  List<Map<String, dynamic>> _posts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchClassDetail();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchClassDetail() async {
    try {
      final response =
          await ApiService().get('${Api.classes}/${widget.classModel.id}');
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          if (data['members'] != null) {
            _students = List<Map<String, dynamic>>.from(data['members']);
          }
          if (data['courses'] != null) {
            _courses = List<Map<String, dynamic>>.from(data['courses']);
          }
          if (data['posts'] != null) {
            _posts = List<Map<String, dynamic>>.from(data['posts']);
          }
        });
      }
    } catch (e) {
      debugPrint('获取班级详情失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
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
    if (_students.isEmpty) {
      return Center(
        child: Text('暂无成员数据', style: TextStyle(color: Colors.grey[400])),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _students.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final student = _students[index];
        final name = student['name'] ?? student['userName'] ?? '未知';
        final role = student['role'] ?? '同学';
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
              name.toString().isNotEmpty ? name.toString()[0] : '?',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          title: Text(name.toString(), style: const TextStyle(fontSize: 14)),
          trailing: role != '同学'
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A90D9).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role.toString(),
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
    if (_courses.isEmpty) {
      return Center(
        child: Text('暂无课程数据', style: TextStyle(color: Colors.grey[400])),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
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
                      course['title'] ?? '',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${course['teacherName'] ?? course['teacher'] ?? ''}  |  ${course['studentCount'] ?? course['count'] ?? 0}人已学',
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
    if (_posts.isEmpty) {
      return Center(
        child: Text('暂无动态数据', style: TextStyle(color: Colors.grey[400])),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
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
                      post['title'] ?? '',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                post['content'] ?? '',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post['createdAt'] ?? post['date'] ?? '',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      },
    );
  }
}
