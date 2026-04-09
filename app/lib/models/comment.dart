class Comment {
  final String id;
  final String author;
  final String content;
  final String createdAt;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id']?.toString() ?? '',
      author: json['author'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
