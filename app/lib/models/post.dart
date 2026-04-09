class Post {
  final String id;
  final String author;
  final String content;
  final String imageUrl;
  final int likes;
  final int commentsCount;
  final String createdAt;

  Post({
    required this.id,
    required this.author,
    required this.content,
    this.imageUrl = '',
    this.likes = 0,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      author: json['authorName'] ?? json['author'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      likes: json['likes'] ?? 0,
      commentsCount: json['commentCount'] ?? json['commentsCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'commentsCount': commentsCount,
      'createdAt': createdAt,
    };
  }
}
