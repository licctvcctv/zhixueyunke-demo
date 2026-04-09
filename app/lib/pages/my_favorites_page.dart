import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api.dart';
import '../models/course.dart';
import '../services/api_service.dart';
import '../widgets/course_card.dart';

class MyFavoritesPage extends StatefulWidget {
  const MyFavoritesPage({Key? key}) : super(key: key);

  @override
  State<MyFavoritesPage> createState() => _MyFavoritesPageState();
}

class _MyFavoritesPageState extends State<MyFavoritesPage> {
  List<Course> _favorites = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('favorite_courses') ?? [];
    if (ids.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final response = await ApiService().get(Api.courses);
      final all =
          (response.data as List).map((e) => Course.fromJson(e)).toList();
      if (mounted) {
        setState(() {
          _favorites = all.where((c) => ids.contains(c.id)).toList();
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('加载收藏失败: $e');
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('我的收藏')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('暂无收藏课程',
                          style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadFavorites,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _favorites.length,
                    itemBuilder: (context, index) {
                      final course = _favorites[index];
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
    );
  }
}
