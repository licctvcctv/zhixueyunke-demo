class Comment {
  final String id;
  final String authorId;
  final String author;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    this.authorId = '',
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? json['userId']?.toString() ?? '',
      author: json['authorName'] ?? json['author'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'author': author,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
