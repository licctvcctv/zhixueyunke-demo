import 'package:flutter/material.dart';
import '../models/question.dart';
import 'qa_detail_page.dart';
import 'ask_question_page.dart';

class QaListPage extends StatelessWidget {
  const QaListPage({Key? key}) : super(key: key);

  List<QuestionModel> get _mockQuestions => [
        QuestionModel(
          id: 1,
          courseId: 1,
          authorName: '张同学',
          title: 'Flutter中StatelessWidget和StatefulWidget的区别是什么？',
          content: '刚开始学Flutter，想了解这两种Widget的区别以及使用场景。',
          answerCount: 5,
          solved: true,
          createdAt: DateTime(2024, 3, 15),
        ),
        QuestionModel(
          id: 2,
          courseId: 1,
          authorName: '李同学',
          title: 'Dart中async和await的使用方法？',
          content: '异步编程一直是我的弱项，请问Dart中如何正确使用async/await？',
          answerCount: 3,
          solved: true,
          createdAt: DateTime(2024, 3, 14),
        ),
        QuestionModel(
          id: 3,
          courseId: 2,
          authorName: '王同学',
          title: '高等数学中极限的求解技巧有哪些？',
          content: '求不定式极限时经常出错，有什么好的方法和技巧吗？',
          answerCount: 8,
          solved: true,
          createdAt: DateTime(2024, 3, 13),
        ),
        QuestionModel(
          id: 4,
          courseId: 3,
          authorName: '赵同学',
          title: '英语四级听力如何有效提升？',
          content: '听力分数一直不理想，有没有推荐的练习方法？',
          answerCount: 6,
          solved: false,
          createdAt: DateTime(2024, 3, 12),
        ),
        QuestionModel(
          id: 5,
          courseId: 1,
          authorName: '孙同学',
          title: 'Flutter中如何实现页面间传参？',
          content: '我想在A页面跳转到B页面时传递一些数据，有哪些方式？',
          answerCount: 4,
          solved: true,
          createdAt: DateTime(2024, 3, 11),
        ),
        QuestionModel(
          id: 6,
          courseId: 4,
          authorName: '周同学',
          title: 'Python中列表推导式和生成器表达式有什么区别？',
          content: '两者语法相似，但在性能和使用场景上有什么不同？',
          answerCount: 2,
          solved: false,
          createdAt: DateTime(2024, 3, 10),
        ),
        QuestionModel(
          id: 7,
          courseId: 2,
          authorName: '钱同学',
          title: '微积分中泰勒展开式的应用场景？',
          content: '学了泰勒展开，但不清楚在哪些实际问题中会用到？',
          answerCount: 3,
          solved: false,
          createdAt: DateTime(2024, 3, 9),
        ),
        QuestionModel(
          id: 8,
          courseId: 5,
          authorName: '陈同学',
          title: 'Figma中Auto Layout怎么使用？',
          content: '自动布局功能总是调不好，求一个详细教程。',
          answerCount: 1,
          solved: false,
          createdAt: DateTime(2024, 3, 8),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final questions = _mockQuestions;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('课程问答')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: questions.length,
        itemBuilder: (context, index) {
          final q = questions[index];
          return _buildQuestionCard(context, q);
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4A90D9),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AskQuestionPage()),
          );
        },
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, QuestionModel q) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QaDetailPage(question: q)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    q.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (q.solved)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF50C878).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '已解决',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF50C878),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              q.content,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: const Color(0xFF4A90D9),
                  child: Text(
                    q.authorName[0],
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  q.authorName,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const Spacer(),
                Icon(Icons.chat_bubble_outline,
                    size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  '${q.answerCount}个回答',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
                const SizedBox(width: 12),
                Text(
                  '${q.createdAt.month}-${q.createdAt.day}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
