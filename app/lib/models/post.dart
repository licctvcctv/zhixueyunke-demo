class Post {
  final String id;
  final String authorId;
  final String author;
  final String content;
  final String imageUrl;
  final int likes;
  final bool isLiked;
  final int commentsCount;
  final String createdAt;

  Post({
    required this.id,
    this.authorId = '',
    required this.author,
    required this.content,
    this.imageUrl = '',
    this.likes = 0,
    this.isLiked = false,
    this.commentsCount = 0,
    required this.createdAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? json['userId']?.toString() ?? '',
      author: json['authorName'] ?? json['author'] ?? '',
      content: json['content'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      commentsCount: json['commentCount'] ?? json['commentsCount'] ?? 0,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'author': author,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'isLiked': isLiked,
      'commentsCount': commentsCount,
      'createdAt': createdAt,
    };
  }
}
