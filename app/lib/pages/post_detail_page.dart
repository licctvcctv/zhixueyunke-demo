import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/api.dart';
import '../config/colors.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils/time_utils.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({Key? key}) : super(key: key);

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  final _commentController = TextEditingController();
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isSending = false;
  Post? _post;
  late int _likes;
  late bool _isLiked;
  bool _isFollowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _post = ModalRoute.of(context)!.settings.arguments as Post;
      _likes = _post!.likes;
      _isLiked = _post!.isLiked;
      _fetchPostDetail();
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String get _currentUserId =>
      Provider.of<AuthService>(context, listen: false).currentUser?.id ?? '';

  bool get _isPostOwner =>
      _currentUserId.isNotEmpty && _post != null && _currentUserId == _post!.authorId;

  Future<void> _fetchPostDetail() async {
    try {
      final response = await ApiService().get('${Api.posts}/${_post!.id}');
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['likes'] != null) {
          _likes = data['likes'];
        }
        if (data['isLiked'] != null) {
          _isLiked = data['isLiked'];
        }
        if (data['comments'] != null) {
          setState(() {
            _comments = (data['comments'] as List)
                .map((c) => Comment(
                      id: c['id']?.toString() ?? '',
                      authorId: c['authorId']?.toString() ??
                          c['userId']?.toString() ??
                          '',
                      author: c['authorName'] ?? c['author'] ?? '',
                      content: c['content'] ?? '',
                      createdAt: c['createdAt'] ?? '',
                    ))
                .toList();
          });
        }
      }
    } catch (e) {
      debugPrint('获取帖子详情失败: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _toggleLike() async {
    try {
      final response =
          await ApiService().post('${Api.posts}/${_post!.id}/like');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _likes = response.data['likes'] ?? (_likes + 1);
          _isLiked = true;
        });
      }
    } catch (e) {
      debugPrint('点赞失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('点赞失败，请重试')),
        );
      }
    }
  }

  Future<void> _deletePost() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除帖子'),
        content: const Text('确定要删除这条帖子吗？删除后不可恢复。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final response =
          await ApiService().delete('${Api.posts}/${_post!.id}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('删除帖子失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除失败，请重试')),
        );
      }
    }
  }

  Future<void> _deleteComment(Comment comment) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除评论'),
        content: const Text('确定要删除这条评论吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    try {
      final response = await ApiService()
          .delete('${Api.posts}/${_post!.id}/comments/${comment.id}');
      if (response.statusCode == 200 || response.statusCode == 204) {
        await _fetchPostDetail();
      }
    } catch (e) {
      debugPrint('删除评论失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('删除评论失败，请重试')),
        );
      }
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.trim().isEmpty) return;
    setState(() => _isSending = true);
    try {
      final response = await ApiService().post(
        '${Api.posts}/${_post!.id}/comments',
        data: {'content': _commentController.text.trim()},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        _commentController.clear();
        FocusScope.of(context).unfocus();
        await _fetchPostDetail();
      }
    } catch (e) {
      debugPrint('发送评论失败: $e, postId=${_post?.id}');
      if (mounted) {
        String msg = '发送评论失败，请重试';
        if (e.toString().contains('401')) {
          msg = '请先登录后再评论';
        } else if (e.toString().contains('404')) {
          msg = '帖子不存在或已被删除';
        }
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
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
        actions: [
          if (_isPostOwner)
            IconButton(
              onPressed: _deletePost,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              tooltip: '删除帖子',
            ),
        ],
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
                                  TimeUtils.timeAgo(post.createdAt),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            OutlinedButton(
                              onPressed: () {
                                setState(() => _isFollowed = !_isFollowed);
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: _isFollowed
                                    ? Colors.grey
                                    : const Color(0xFF4A90D9),
                                side: BorderSide(
                                    color: _isFollowed
                                        ? Colors.grey
                                        : const Color(0xFF4A90D9)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16),
                                minimumSize: const Size(0, 32),
                              ),
                              child: Text(
                                  _isFollowed ? '已关注' : '关注',
                                  style: const TextStyle(fontSize: 13)),
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
                            GestureDetector(
                              onTap: _toggleLike,
                              child: _buildActionButton(
                                _isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                '$_likes',
                                color:
                                    _isLiked ? Colors.red : Colors.grey[600]!,
                              ),
                            ),
                            const SizedBox(width: 32),
                            _buildActionButton(Icons.chat_bubble_outline,
                                '${_comments.length}'),
                            const SizedBox(width: 32),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('功能开发中')),
                                );
                              },
                              child: _buildActionButton(
                                  Icons.bookmark_border, '收藏'),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('功能开发中')),
                                );
                              },
                              child: _buildActionButton(Icons.share, '分享'),
                            ),
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
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_comments.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          '暂无评论，快来发表第一条评论吧',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ),
                    )
                  else
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
                        final isCommentOwner = _currentUserId.isNotEmpty &&
                            _currentUserId == comment.authorId;
                        return GestureDetector(
                          onLongPress: isCommentOwner
                              ? () => _deleteComment(comment)
                              : null,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundColor: AppColors.fromId(index),
                                child: Text(
                                  comment.author.isNotEmpty
                                      ? comment.author[0]
                                      : '?',
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
                                          TimeUtils.timeAgo(comment.createdAt),
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
                          ),
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
                  onTap: _isSending ? null : _addComment,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isSending
                          ? Colors.grey
                          : const Color(0xFF4A90D9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: _isSending
                        ? const Padding(
                            padding: EdgeInsets.all(10),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
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

  Widget _buildActionButton(IconData icon, String label, {Color? color}) {
    final c = color ?? Colors.grey[600]!;
    return Row(
      children: [
        Icon(icon, size: 20, color: c),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: c),
        ),
      ],
    );
  }
}
