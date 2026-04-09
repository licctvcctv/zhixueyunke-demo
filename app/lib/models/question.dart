class QuestionModel {
  final int id;
  final int courseId;
  final String authorName;
  final String title;
  final String content;
  final int answerCount;
  final bool solved;
  final DateTime createdAt;

  QuestionModel({
    required this.id,
    required this.courseId,
    required this.authorName,
    required this.title,
    required this.content,
    required this.answerCount,
    required this.solved,
    required this.createdAt,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'] ?? 0,
      courseId: json['courseId'] ?? 0,
      authorName: json['authorName'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      answerCount: json['answerCount'] ?? 0,
      solved: (json['solved'] == 1 || json['solved'] == true),
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
