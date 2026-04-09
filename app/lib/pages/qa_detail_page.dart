import 'package:flutter/material.dart';
import '../models/question.dart';
import '../models/answer.dart';

class QaDetailPage extends StatefulWidget {
  final QuestionModel question;

  const QaDetailPage({Key? key, required this.question}) : super(key: key);

  @override
  State<QaDetailPage> createState() => _QaDetailPageState();
}

class _QaDetailPageState extends State<QaDetailPage> {
  final TextEditingController _answerController = TextEditingController();

  List<AnswerModel> get _mockAnswers => [
        AnswerModel(
          id: 1,
          authorName: '李教授',
          content:
              '这是一个很好的问题。简单来说，StatelessWidget是不可变的，一旦创建就不能改变其状态；而StatefulWidget可以在其生命周期内改变状态。当你的UI需要响应用户交互或数据变化时，应该使用StatefulWidget。',
          isAccepted: true,
          createdAt: DateTime(2024, 3, 15, 10, 30),
        ),
        AnswerModel(
          id: 2,
          authorName: '王同学',
          content:
              '补充一下，StatelessWidget适合用于纯展示性的组件，比如文本、图标等。StatefulWidget适合用于表单输入、动画、需要网络请求的页面等场景。',
          isAccepted: false,
          createdAt: DateTime(2024, 3, 15, 11, 20),
        ),
        AnswerModel(
          id: 3,
          authorName: '赵同学',
          content: '我的理解是：如果你的Widget不需要在创建后做任何改变，用StatelessWidget；如果需要根据用户操作或数据刷新UI，就用StatefulWidget。',
          isAccepted: false,
          createdAt: DateTime(2024, 3, 15, 14, 0),
        ),
      ];

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    final answers = _mockAnswers;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text('问题详情')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (q.solved)
                              Container(
                                margin: const EdgeInsets.only(right: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      const Color(0xFF50C878).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '已解决',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF50C878),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Text(
                                q.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          q.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: const Color(0xFF4A90D9),
                              child: Text(
                                q.authorName[0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              q.authorName,
                              style: TextStyle(
                                  fontSize: 13, color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${q.createdAt.year}-${q.createdAt.month.toString().padLeft(2, '0')}-${q.createdAt.day.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Answers section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: Colors.white,
                    child: Text(
                      '回答 (${answers.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ...answers.map((a) => _buildAnswerCard(a)),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),

          // Bottom input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F6FA),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: _answerController,
                        decoration: const InputDecoration(
                          hintText: '写下你的回答...',
                          hintStyle: TextStyle(fontSize: 13),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      if (_answerController.text.trim().isNotEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('回答已提交')),
                        );
                        _answerController.clear();
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          const Icon(Icons.send, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(AnswerModel answer) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: answer.isAccepted
                    ? const Color(0xFF50C878)
                    : const Color(0xFF4A90D9),
                child: Text(
                  answer.authorName[0],
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                answer.authorName,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              if (answer.isAccepted) ...[
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(
                    color: const Color(0xFF50C878).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '已采纳',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF50C878),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                '${answer.createdAt.month}-${answer.createdAt.day} ${answer.createdAt.hour}:${answer.createdAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            answer.content,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const Divider(height: 24),
        ],
      ),
    );
  }
}
