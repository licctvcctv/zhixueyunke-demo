import 'package:flutter/material.dart';
import '../config/api.dart';
import '../config/colors.dart';
import '../models/course.dart';
import '../services/api_service.dart';
import '../utils/time_utils.dart';
import 'qa_list_page.dart';

class CourseDetailPage extends StatefulWidget {
  const CourseDetailPage({Key? key}) : super(key: key);

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _reviewController = TextEditingController();
  Course? _fullCourse;
  List<Map<String, dynamic>> _reviews = [];
  bool _isLoadingCourse = true;
  bool _isLoadingReviews = true;
  bool _enrolled = false;
  bool _enrolling = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final course = ModalRoute.of(context)!.settings.arguments as Course;
      _fetchCourseDetail(course.id);
      _fetchReviews(course.id);
      _checkEnrollment(course.id);
    });
  }

  Future<void> _checkEnrollment(String courseId) async {
    try {
      final response = await ApiService().get(Api.myEnrolled);
      final list = response.data as List;
      final enrolled = list.any((e) => (e['id']?.toString() ?? '') == courseId);
      if (mounted) {
        setState(() => _enrolled = enrolled);
      }
    } catch (e) {
      // If not logged in or request fails, leave as not enrolled
      debugPrint('检查报名状态失败: $e');
    }
  }

  Future<void> _enrollCourse(String courseId) async {
    setState(() => _enrolling = true);
    try {
      await ApiService().post('${Api.courses}/$courseId/enroll');
      if (mounted) {
        setState(() {
          _enrolled = true;
          _enrolling = false;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('报名成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _enrolling = false);
        // If already enrolled (400), set enrolled to true
        final errMsg = e.toString();
        if (errMsg.contains('400') || errMsg.contains('已报名')) {
          setState(() => _enrolled = true);
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('报名失败，请重试')),
          );
        }
      }
    }
  }

  Future<void> _addReview(String courseId) async {
    if (_reviewController.text.trim().isEmpty) return;
    try {
      await ApiService().post('${Api.courses}/$courseId/comments', data: {
        'content': _reviewController.text.trim(),
      });
      _reviewController.clear();
      FocusScope.of(context).unfocus();
      await _fetchReviews(courseId);
    } catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('评论失败，请重试')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _fetchCourseDetail(String courseId) async {
    try {
      final response = await ApiService().get('${Api.courses}/$courseId');
      if (response.statusCode == 200) {
        setState(() {
          _fullCourse = Course.fromJson(response.data);
        });
      }
    } catch (e) {
      debugPrint('获取课程详情失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingCourse = false);
      }
    }
  }

  Future<void> _fetchReviews(String courseId) async {
    try {
      final response =
          await ApiService().get('${Api.courses}/$courseId/comments');
      if (response.statusCode == 200) {
        final data = response.data;
        final list = data is List ? data : (data['comments'] ?? data['data'] ?? []);
        setState(() {
          _reviews = List<Map<String, dynamic>>.from(list);
        });
      }
    } catch (e) {
      debugPrint('获取课程评价失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoadingReviews = false);
      }
    }
  }

  Color _getCoverColor(String id) => AppColors.fromId(id);

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)!.settings.arguments as Course;
    // Use full course data if loaded, otherwise use the passed-in course
    final displayCourse = _fullCourse ?? course;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 220,
                    pinned: true,
                    backgroundColor: _getCoverColor(course.id),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              _getCoverColor(course.id),
                              _getCoverColor(course.id).withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Icon(
                                Icons.play_circle_outline,
                                size: 64,
                                color: Colors.white.withOpacity(0.9),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                displayCourse.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayCourse.title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: const Color(0xFF4A90D9),
                                child: Text(
                                  displayCourse.teacherName[0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayCourse.teacherName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Icon(Icons.star,
                                  size: 16, color: Colors.amber[600]),
                              const SizedBox(width: 4),
                              Text(
                                displayCourse.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Icon(Icons.person,
                                  size: 16, color: Colors.grey[400]),
                              const SizedBox(width: 4),
                              Text(
                                '${displayCourse.studentCount}人已学',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4A90D9).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              displayCourse.category,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF4A90D9),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPersistentHeader(
                    pinned: true,
                    delegate: _TabBarDelegate(
                      TabBar(
                        controller: _tabController,
                        labelColor: const Color(0xFF4A90D9),
                        unselectedLabelColor: Colors.grey[500],
                        indicatorColor: const Color(0xFF4A90D9),
                        indicatorWeight: 3,
                        tabs: const [
                          Tab(text: '简介'),
                          Tab(text: '目录'),
                          Tab(text: '评价'),
                        ],
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  // Introduction tab
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '课程简介',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          displayCourse.description,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.8,
                            color: Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '你将学到',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLearnItem('掌握核心概念和基本原理'),
                        _buildLearnItem('具备独立解决问题的能力'),
                        _buildLearnItem('理解实际应用场景和最佳实践'),
                        _buildLearnItem('完成课程项目实战'),
                        const SizedBox(height: 20),
                        const Text(
                          '适合人群',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildLearnItem('对${displayCourse.category}感兴趣的学生'),
                        _buildLearnItem('希望系统学习提升技能的从业者'),
                        _buildLearnItem('准备相关考试的备考人员'),
                      ],
                    ),
                  ),

                  // Lessons tab
                  _isLoadingCourse
                      ? const Center(child: CircularProgressIndicator())
                      : displayCourse.lessons.isEmpty
                          ? Center(
                              child: Text(
                                '暂无课时',
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: displayCourse.lessons.length,
                              itemBuilder: (context, index) {
                                final lesson = displayCourse.lessons[index];
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4A90D9)
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '${lesson.order}',
                                          style: const TextStyle(
                                            color: Color(0xFF4A90D9),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(
                                      lesson.title,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    subtitle: Text(
                                      lesson.duration,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.play_circle_fill,
                                      color: const Color(0xFF4A90D9)
                                          .withOpacity(0.7),
                                    ),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/videoPlayer',
                                        arguments: {
                                          'lesson': lesson,
                                          'courseTitle': displayCourse.title,
                                        },
                                      );
                                    },
                                  ),
                                );
                              },
                            ),

                  // Reviews tab
                  Column(
                    children: [
                      Expanded(
                        child: _isLoadingReviews
                            ? const Center(child: CircularProgressIndicator())
                            : _reviews.isEmpty
                                ? Center(
                                    child: Text(
                                      '暂无评价，快来评价吧',
                                      style: TextStyle(color: Colors.grey[400]),
                                    ),
                                  )
                                : ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: _reviews.length,
                                    itemBuilder: (context, index) {
                                      final review = _reviews[index];
                                      return _buildReviewCard(
                                        review['authorName'] ??
                                            review['author'] ??
                                            '匿名',
                                        (review['rating'] ?? 5.0).toDouble(),
                                        review['content'] ?? '',
                                        review['createdAt'] ?? '',
                                      );
                                    },
                                  ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(color: Colors.grey.shade200),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _reviewController,
                                decoration: const InputDecoration(
                                  hintText: '写评价...',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  isDense: true,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.send,
                                  color: Color(0xFF4A90D9)),
                              onPressed: () => _addReview(course.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const QaListPage()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.question_answer,
                          color: Colors.grey[600], size: 22),
                      const SizedBox(height: 2),
                      Text(
                        '问答',
                        style:
                            TextStyle(fontSize: 11, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: _enrolled
                        ? ElevatedButton(
                            onPressed: () {
                              final c = _fullCourse ?? course;
                              if (c.lessons.isNotEmpty) {
                                Navigator.pushNamed(
                                  context,
                                  '/videoPlayer',
                                  arguments: {
                                    'lesson': c.lessons[0],
                                    'courseTitle': c.title,
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              '继续学习',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: _enrolling
                                ? null
                                : () => _enrollCourse(course.id),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A90D9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _enrolling
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    '报名课程',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearnItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF50C878), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
      String name, double rating, String content, String date) {
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
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF4A90D9),
                child: Text(
                  name.isNotEmpty ? name[0] : '?',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              ...List.generate(5, (i) {
                return Icon(
                  i < rating.floor() ? Icons.star : Icons.star_border,
                  size: 14,
                  color: Colors.amber[600],
                );
              }),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            TimeUtils.timeAgo(date),
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _TabBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      child: tabBar,
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}
