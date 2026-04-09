class User {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String bio;
  final String role;
  final int status;
  final String createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatar = '',
    this.bio = '',
    this.role = 'user',
    this.status = 1,
    this.createdAt = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? '',
      bio: json['bio'] ?? '',
      role: json['role'] ?? 'user',
      status: json['status'] ?? 1,
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'bio': bio,
      'role': role,
      'status': status,
      'createdAt': createdAt,
    };
  }
}
