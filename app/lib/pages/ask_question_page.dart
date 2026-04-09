import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../config/api.dart';
import '../models/course.dart';

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({Key? key}) : super(key: key);

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<Course> _courses = [];
  Course? _selectedCourse;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    try {
      final response = await ApiService().get(Api.courses);
      final list = (response.data as List)
          .map((e) => Course.fromJson(e as Map<String, dynamic>))
          .toList();
      if (mounted) setState(() => _courses = list);
    } catch (_) {}
  }

  Future<void> _submit() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入问题标题')),
      );
      return;
    }
    if (_selectedCourse == null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择关联课程')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await ApiService().post(Api.qa, data: {
        'courseId': int.tryParse(_selectedCourse!.id) ?? 1,
        'title': _titleController.text.trim(),
        'content': _contentController.text.trim().isNotEmpty
            ? _contentController.text.trim()
            : _titleController.text.trim(),
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('提问成功')),
          );
          Navigator.pop(context, true);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('提问失败，请重试')),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('提问'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 18, height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      '发布',
                      style: TextStyle(
                        color: Color(0xFF4A90D9),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '选择课程',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Course>(
                  isExpanded: true,
                  hint: const Text('请选择关联课程',
                      style: TextStyle(fontSize: 14, color: Colors.grey)),
                  value: _selectedCourse,
                  items: _courses.map((c) {
                    return DropdownMenuItem<Course>(
                      value: c,
                      child: Text(c.title, style: const TextStyle(fontSize: 14)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCourse = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              '问题标题',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: InputDecoration(
                hintText: '请简要描述你的问题',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),

            const Text(
              '问题描述',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 8,
              maxLength: 1000,
              decoration: InputDecoration(
                hintText: '请详细描述你的问题，以便他人更好地回答',
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F6FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
