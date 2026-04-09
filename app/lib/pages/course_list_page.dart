import 'dart:async';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../widgets/course_card.dart';
import '../services/api_service.dart';
import '../config/api.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({Key? key}) : super(key: key);

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '编程', '数学', '英语', '物理', '设计'];

  List<Course> _allCourses = [];
  bool _loading = true;
  String? _error;

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _searchKeyword = value.trim();
      });
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      setState(() { _loading = true; _error = null; });
      final Map<String, dynamic> params = {};
      if (_searchKeyword.isNotEmpty) {
        params['search'] = _searchKeyword;
      }
      final response = await ApiService().get(Api.courses, params: params.isNotEmpty ? params : null);
      final list = (response.data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() { _allCourses = list; _loading = false; });
    } catch (e) {
      setState(() { _error = '加载失败，请检查网络'; _loading = false; });
    }
  }

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
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: const InputDecoration(
                  hintText: '搜索课程...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),

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
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_error!, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadData,
                              child: const Text('重试'),
                            ),
                          ],
                        ),
                      )
                    : _filteredCourses.isEmpty
                        ? Center(
                            child: Text(
                              '没有找到相关课程',
                              style: TextStyle(color: Colors.grey[400]),
                            ),
                          )
                        : GridView.builder(
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
