import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import 'qa_list_page.dart';
import 'class_list_page.dart';
import 'my_courses_page.dart';
import 'course_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Course> _hotCourses = [];
  bool _loadingCourses = true;

  @override
  void initState() {
    super.initState();
    _loadHotCourses();
  }

  Future<void> _loadHotCourses() async {
    try {
      final response = await ApiService().get(Api.courses);
      final list = (response.data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() {
        _hotCourses = list.take(5).toList();
        _loadingCourses = false;
      });
    } catch (e) {
      setState(() { _loadingCourses = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Text('智学云课', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF4A90D9))),
                    const Spacer(),
                    IconButton(icon: const Icon(Icons.search, color: Colors.grey), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.grey), onPressed: () {}),
                  ],
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
                    _buildQuickAccess(Icons.menu_book, '我的课程', const Color(0xFFFF6B6B), onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCoursesPage()));
                    }),
                    _buildQuickAccess(Icons.question_answer, '课程问答', const Color(0xFFFFB347), onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QaListPage()));
                    }),
                    _buildQuickAccess(Icons.groups, '我的班级', const Color(0xFF50C878), onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassListPage()));
                    }),
                    _buildQuickAccess(Icons.calendar_today, '全部课程', const Color(0xFF4A90D9), onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseListPage()));
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 快捷入口 section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text(
                  '快捷入口',
                  style: TextStyle(
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
                    _buildShortcutItem(context, Icons.menu_book, '我的课程', const Color(0xFF4A90D9), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCoursesPage()));
                    }),
                    _buildShortcutItem(context, Icons.groups, '我的班级', const Color(0xFF50C878), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const ClassListPage()));
                    }),
                    _buildShortcutItem(context, Icons.question_answer, '课程问答', const Color(0xFFFF6B6B), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const QaListPage()));
                    }),
                    _buildShortcutItem(context, Icons.history, '学习记录', const Color(0xFFFFB347), () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const MyCoursesPage()));
                    }),
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
                child: _loadingCourses
                    ? const Center(child: CircularProgressIndicator())
                    : _hotCourses.isEmpty
                        ? const Center(child: Text('暂无课程'))
                        : ListView.builder(
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
                detail: '各院系注意：2024年春季学期期末考试将于6月15日-6月30日进行，请各位同学提前做好复习准备，合理安排考试时间。具体考试安排请关注各院系教务通知。',
              ),
              _buildAnnouncementItem(
                '新课上线：人工智能与机器学习导论',
                '2024-03-14',
                Icons.new_releases,
                const Color(0xFF4A90D9),
                detail: '由陈教授主讲的《人工智能与机器学习导论》已正式上线，课程涵盖机器学习基础、深度学习、自然语言处理等前沿内容，欢迎选课学习。',
              ),
              _buildAnnouncementItem(
                '系统升级维护通知（3月20日凌晨）',
                '2024-03-13',
                Icons.info_outline,
                const Color(0xFFFFB347),
                detail: '为提升平台性能，系统将于3月20日凌晨2:00-6:00进行升级维护，届时平台将暂停服务，请提前做好学习安排，给您带来不便敬请谅解。',
              ),
              _buildAnnouncementItem(
                '优秀学员表彰：恭喜以下同学获得学习之星',
                '2024-03-12',
                Icons.star_outline,
                const Color(0xFF50C878),
                detail: '恭喜张三、李四、王五同学获得本月"学习之星"称号，他们在本月学习时长、课程完成率等方面表现优异，特此表彰！',
              ),
              _buildAnnouncementItem(
                '关于开展线上学习竞赛活动的通知',
                '2024-03-11',
                Icons.emoji_events_outlined,
                const Color(0xFFDDA0DD),
                detail: '为激发学习热情，平台将于4月1日-4月30日举办线上学习竞赛，设置丰厚奖品，欢迎广大同学踊跃参与！',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccess(IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
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
      String title, String date, IconData icon, Color color, {String? detail}) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title, style: const TextStyle(fontSize: 16)),
            content: Text(detail ?? '暂无详细内容', style: const TextStyle(fontSize: 14, height: 1.6)),
            actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('关闭'))],
          ),
        );
      },
      child: Container(
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
      ),
    );
  }
}
