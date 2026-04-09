import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final String coverImage;
  final String teacherName;
  final String videoUrl;
  final String category;
  final int studentCount;
  final double rating;
  final List<Lesson> lessons;

  Course({
    required this.id,
    required this.title,
    required this.description,
    this.coverImage = '',
    required this.teacherName,
    this.videoUrl = '',
    required this.category,
    this.studentCount = 0,
    this.rating = 5.0,
    this.lessons = const [],
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      coverImage: json['coverImage'] ?? '',
      teacherName: json['teacherName'] ?? '',
      videoUrl: json['videoUrl'] ?? '',
      category: json['category'] ?? '',
      studentCount: json['studentCount'] ?? 0,
      rating: (json['rating'] ?? 5.0).toDouble(),
      lessons: (json['lessons'] as List?)
              ?.map((e) => Lesson.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'coverImage': coverImage,
      'teacherName': teacherName,
      'videoUrl': videoUrl,
      'category': category,
      'studentCount': studentCount,
      'rating': rating,
      'lessons': lessons.map((e) => e.toJson()).toList(),
    };
  }
}
