class ClassModel {
  final int id;
  final String name;
  final String description;
  final String teacherName;
  final int studentCount;
  final DateTime createdAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.description,
    required this.teacherName,
    required this.studentCount,
    required this.createdAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      teacherName: json['teacherName'] ?? '',
      studentCount: json['studentCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
