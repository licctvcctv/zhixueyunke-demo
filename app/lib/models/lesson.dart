class Lesson {
  final String id;
  final String title;
  final String duration;
  final String videoUrl;
  final int order;

  Lesson({
    required this.id,
    required this.title,
    required this.duration,
    this.videoUrl = '',
    required this.order,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    final durationText = json['durationText'];
    final rawDuration = json['duration'];
    return Lesson(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      duration: (durationText != null && durationText.toString().isNotEmpty)
          ? durationText.toString()
          : _formatDuration(rawDuration),
      videoUrl: json['videoUrl'] ?? '',
      order: json['orderNum'] ?? json['order'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'duration': duration,
      'videoUrl': videoUrl,
      'order': order,
    };
  }

  static String _formatDuration(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;

    final seconds = value is num ? value.toInt() : int.tryParse(value.toString());
    if (seconds == null) return value.toString();

    final minutes = seconds ~/ 60;
    final remainSeconds = seconds % 60;
    if (minutes <= 0) return '${remainSeconds}秒';
    return '${minutes}分${remainSeconds.toString().padLeft(2, '0')}秒';
  }
}
