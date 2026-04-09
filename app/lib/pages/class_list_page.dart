import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../config/api.dart';
import '../models/class_model.dart';
import '../services/api_service.dart';
import 'class_detail_page.dart';

class ClassListPage extends StatefulWidget {
  const ClassListPage({Key? key}) : super(key: key);

  @override
  State<ClassListPage> createState() => _ClassListPageState();
}

class _ClassListPageState extends State<ClassListPage> {
  List<ClassModel> _classes = [];
  bool _loading = true;
  String? _error;
  final Set<int> _joinedClassIds = {};
  final Set<int> _joiningClassIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() { _loading = true; _error = null; });
      final response = await ApiService().get(Api.classes);
      final list = (response.data as List)
          .map((e) => ClassModel.fromJson(e as Map<String, dynamic>))
          .toList();
      setState(() { _classes = list; _loading = false; });
    } catch (e) {
      setState(() { _error = '加载失败，请检查网络'; _loading = false; });
    }
  }

  Future<void> _joinClass(int classId) async {
    setState(() => _joiningClassIds.add(classId));
    try {
      await ApiService().post('${Api.classes}/$classId/join');
      if (mounted) {
        setState(() {
          _joinedClassIds.add(classId);
          _joiningClassIds.remove(classId);
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('加入成功')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _joiningClassIds.remove(classId));
        final errMsg = e.toString();
        if (errMsg.contains('400') || errMsg.contains('已加入')) {
          setState(() => _joinedClassIds.add(classId));
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('已加入该班级')),
          );
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('加入失败，请重试')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('我的班级')),
      body: _loading
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
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _classes.length,
                  itemBuilder: (context, index) {
                    final cls = _classes[index];
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
            _joinedClassIds.contains(cls.id)
                ? Container(
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
                  )
                : GestureDetector(
                    onTap: _joiningClassIds.contains(cls.id)
                        ? null
                        : () => _joinClass(cls.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: _joiningClassIds.contains(cls.id)
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
                              '加入',
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4A90D9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
