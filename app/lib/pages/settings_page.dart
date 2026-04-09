import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotification = true;
  bool _autoPlay = false;
  bool _wifiOnly = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('设置'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Notification settings
          _buildSectionTitle('通知设置'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  '推送通知',
                  '接收课程更新和社区消息通知',
                  _pushNotification,
                  (val) => setState(() => _pushNotification = val),
                ),
                _divider(),
                _buildSwitchTile(
                  '夜间免打扰',
                  '22:00-8:00 不接收通知',
                  false,
                  (val) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Playback settings
          _buildSectionTitle('播放设置'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  '自动播放下一节',
                  '课程视频结束后自动播放下一节',
                  _autoPlay,
                  (val) => setState(() => _autoPlay = val),
                ),
                _divider(),
                _buildSwitchTile(
                  '仅Wi-Fi下载',
                  '移动网络下不自动下载视频',
                  _wifiOnly,
                  (val) => setState(() => _wifiOnly = val),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Display settings
          _buildSectionTitle('显示设置'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _buildSwitchTile(
                  '深色模式',
                  '切换至深色主题',
                  _darkMode,
                  (val) => setState(() => _darkMode = val),
                ),
                _divider(),
                ListTile(
                  title: const Text('字体大小', style: TextStyle(fontSize: 15)),
                  subtitle: Text('标准',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Other settings
          _buildSectionTitle('其他'),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('清除缓存', style: TextStyle(fontSize: 15)),
                  subtitle: Text('当前缓存 23.5 MB',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('缓存已清除')),
                    );
                  },
                ),
                _divider(),
                ListTile(
                  title: const Text('隐私政策', style: TextStyle(fontSize: 15)),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
                  onTap: () {},
                ),
                _divider(),
                ListTile(
                  title: const Text('用户协议', style: TextStyle(fontSize: 15)),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
                  onTap: () {},
                ),
                _divider(),
                ListTile(
                  title: const Text('检查更新', style: TextStyle(fontSize: 15)),
                  subtitle: Text('当前版本 1.0.0',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                  trailing: Icon(Icons.chevron_right, color: Colors.grey[300]),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已是最新版本')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 15)),
      subtitle: Text(subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF4A90D9),
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 16, endIndent: 16, color: Colors.grey[100]);
  }
}
