class TimeUtils {
  /// 将 ISO 时间字符串转为友好格式："刚刚", "5分钟前", "1小时前", "昨天", "3天前", "2024-03-15"
  static String timeAgo(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inSeconds < 60) return '刚刚';
      if (diff.inMinutes < 60) return '${diff.inMinutes}分钟前';
      if (diff.inHours < 24) return '${diff.inHours}小时前';
      if (diff.inDays < 7) return '${diff.inDays}天前';
      if (diff.inDays < 365) return '${date.month}月${date.day}日';
      return '${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}';
    } catch (e) {
      return dateStr; // fallback to raw string
    }
  }

  /// 将 DateTime 转为友好格式
  static String timeAgoFromDate(DateTime? date) {
    if (date == null) return '';
    return timeAgo(date.toIso8601String());
  }

  /// 将秒数转为 "29:57" 格式
  static String formatDuration(dynamic seconds) {
    final s = seconds is int ? seconds : (int.tryParse(seconds.toString()) ?? 0);
    final min = s ~/ 60;
    final sec = s % 60;
    return '${min}:${sec.toString().padLeft(2, "0")}';
  }
}
