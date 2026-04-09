class AnswerModel {
  final int id;
  final String authorName;
  final String content;
  final bool isAccepted;
  final DateTime createdAt;

  AnswerModel({
    required this.id,
    required this.authorName,
    required this.content,
    required this.isAccepted,
    required this.createdAt,
  });
}
