import 'package:flutter/material.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  List<Post> get _mockPosts => [
        Post(
          id: '1',
          author: '学习达人小明',
          content: '今天完成了Flutter课程的第三章，终于搞懂了状态管理的概念！Provider真的很方便，推荐大家学习。分享一下我的学习笔记，希望对大家有帮助。',
          imageUrl: 'placeholder',
          likes: 128,
          commentsCount: 32,
          createdAt: '2小时前',
        ),
        Post(
          id: '2',
          author: '数学爱好者',
          content: '高等数学期末复习心得分享：重点关注极限、导数和积分三大板块，多做历年真题很有帮助。王老师的课讲得特别好，建议反复看几遍。加油！',
          likes: 89,
          commentsCount: 15,
          createdAt: '3小时前',
        ),
        Post(
          id: '3',
          author: '英语小达人',
          content: '刚过了英语四级，分享一些备考经验：每天坚持听力练习30分钟，阅读理解要注意时间分配，作文多背模板。张老师的冲刺课非常有效！',
          imageUrl: 'placeholder',
          likes: 256,
          commentsCount: 48,
          createdAt: '5小时前',
        ),
        Post(
          id: '4',
          author: '代码侠',
          content: '有没有一起学Python的小伙伴？我创建了一个学习小组，每周一起讨论课程内容和编程练习。感兴趣的同学评论区留言哦！',
          likes: 67,
          commentsCount: 23,
          createdAt: '昨天',
        ),
        Post(
          id: '5',
          author: '设计师小王',
          content: '分享一个UI设计小技巧：在做移动端界面设计时，按钮的最小触摸区域应该保持在44x44pt以上，这样用户体验会更好。另外，色彩搭配建议使用60-30-10原则。',
          likes: 178,
          commentsCount: 29,
          createdAt: '昨天',
        ),
        Post(
          id: '6',
          author: '物理学霸',
          content: '物理课的力学部分终于学完了！牛顿三大定律是基础中的基础，大家一定要理解透彻。赵教授的讲解非常深入浅出，特别是那个弹簧振子的例子，让我豁然开朗。',
          imageUrl: 'placeholder',
          likes: 95,
          commentsCount: 18,
          createdAt: '2天前',
        ),
        Post(
          id: '7',
          author: '考研党',
          content: '距离考研还有200天，今天开始制定详细的复习计划。数学每天3小时，英语2小时，专业课2小时。有一起备考的同学吗？互相监督打卡！',
          likes: 312,
          commentsCount: 67,
          createdAt: '2天前',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('学习社区'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0.5,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/createPost');
        },
        backgroundColor: const Color(0xFF4A90D9),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemCount: _mockPosts.length,
        itemBuilder: (context, index) {
          return PostCard(
            post: _mockPosts[index],
            onTap: () {
              Navigator.pushNamed(
                context,
                '/postDetail',
                arguments: _mockPosts[index],
              );
            },
          );
        },
      ),
    );
  }
}
