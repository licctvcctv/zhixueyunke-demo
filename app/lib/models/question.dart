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
}
