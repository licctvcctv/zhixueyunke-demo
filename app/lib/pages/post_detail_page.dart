import 'package:flutter/material.dart';
import '../config/colors.dart';
import '../models/post.dart';
import '../models/comment.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _commentController = TextEditingController();

  final List<Comment> _comments = [
    Comment(id: '1', author: '学习者A', content: '说得太对了，我也有同样的感受！', createdAt: '1小时前'),
    Comment(id: '2', author: '学习者B', content: '谢谢分享，收藏了！', createdAt: '2小时前'),
    Comment(id: '3', author: '学习者C', content: '请问具体是哪个课程呢？想一起学习', createdAt: '3小时前'),
    Comment(id: '4', author: '学习者D', content: '非常有帮助的分享，期待更多内容！', createdAt: '5小时前'),
    Comment(id: '5', author: '学习者E', content: '已关注，互相学习进步', createdAt: '昨天'),
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isEmpty) return;
    setState(() {
      _comments.insert(
        0,
        Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          author: '我',
          content: _commentController.text.trim(),
          createdAt: '刚刚',
        ),
      );
      _commentController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final post = ModalRoute.of(context)!.settings.arguments as Post;

    final postColorIndex = int.tryParse(post.id) ?? 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('帖子详情'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.fromId(postColorIndex),
                              child: Text(
                                post.author[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.author,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  post.createdAt,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF4A90D9),
                                side: const BorderSide(
                                    color: Color(0xFF4A90D9)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                minimumSize: const Size(0, 32),
                              ),
                              child: const Text('关注', style: TextStyle(fontSize: 13)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          post.content,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                        if (post.imageUrl.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                size: 48,
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _buildActionButton(
                                Icons.favorite_border, '${post.likes}'),
                            const SizedBox(width: 32),
                            _buildActionButton(Icons.chat_bubble_outline,
                                '${_comments.length}'),
                            const SizedBox(width: 32),
                            _buildActionButton(
                                Icons.bookmark_border, '收藏'),
                            const Spacer(),
                            _buildActionButton(Icons.share, '分享'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Divider
                  Container(
                    height: 8,
                    color: Colors.grey[50],
                  ),

                  // Comments header
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '全部评论 (${_comments.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Comments list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _comments.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 24,
                      color: Colors.grey[100],
                    ),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.fromId(index),
                            child: Text(
                              comment.author[0],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      comment.author,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      comment.createdAt,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[400],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  comment.content,
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.4,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Bottom comment input
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).padding.bottom + 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: '写评论...',
                        hintStyle: TextStyle(fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _addComment,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
