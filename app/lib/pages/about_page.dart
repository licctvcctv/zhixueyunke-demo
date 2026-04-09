import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('关于我们'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40),

            // App icon
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFF4A90D9),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF4A90D9).withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school,
                size: 48,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '智学云课',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'v1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),

            // Description
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '智学云课是一款专注于在线教育的移动学习平台。我们致力于为广大学子提供优质、便捷的学习体验。平台汇聚了众多名师精品课程，涵盖编程、数学、英语、物理、设计等多个学科领域。\n\n我们的愿景是让每一位学习者都能享受到高品质的教育资源，让学习变得更加简单、高效、有趣。',
                style: TextStyle(
                  fontSize: 14,
                  height: 1.8,
                  color: Colors.grey[700],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Features
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildFeatureItem(
                      Icons.video_library, '海量课程', '涵盖多个学科的优质课程资源'),
                  _divider(),
                  _buildFeatureItem(
                      Icons.people, '学习社区', '与同学互动交流，分享学习心得'),
                  _divider(),
                  _buildFeatureItem(
                      Icons.analytics, '学习追踪', '记录学习进度，科学规划学习计划'),
                  _divider(),
                  _buildFeatureItem(
                      Icons.offline_bolt, '离线学习', '支持课程下载，随时随地学习'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Contact info
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildContactItem(Icons.email_outlined, '联系邮箱',
                      'support@zhixueyunke.com'),
                  const SizedBox(height: 12),
                  _buildContactItem(
                      Icons.language, '官方网站', 'www.zhixueyunke.com'),
                  const SizedBox(height: 12),
                  _buildContactItem(
                      Icons.phone_outlined, '客服电话', '400-888-9999'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Text(
              'Copyright 2024 智学云课 版权所有',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF4A90D9).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF4A90D9), size: 22),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 10),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, color: Color(0xFF4A90D9)),
        ),
      ],
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 68, color: Colors.grey[100]);
  }
}
