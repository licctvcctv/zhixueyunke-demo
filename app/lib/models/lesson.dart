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
    return Lesson(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      duration: json['duration'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      order: json['order'] ?? 0,
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
}
