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

  factory AnswerModel.fromJson(Map<String, dynamic> json) {
    return AnswerModel(
      id: json['id'] ?? 0,
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
      isAccepted: json['isAccepted'] == true || json['isAccepted'] == 1,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
