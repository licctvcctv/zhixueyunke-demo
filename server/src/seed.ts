import 'reflect-metadata';
import { DataSource } from 'typeorm';
import { join } from 'path';
import * as bcrypt from 'bcrypt';
import { User } from './entities/user.entity';
import { Course } from './entities/course.entity';
import { Lesson } from './entities/lesson.entity';
import { ClassEntity } from './entities/class.entity';
import { ClassMember } from './entities/class-member.entity';
import { Post } from './entities/post.entity';
import { Comment } from './entities/comment.entity';
import { Question } from './entities/question.entity';
import { Answer } from './entities/answer.entity';
import { Enrollment } from './entities/enrollment.entity';
import { Progress } from './entities/progress.entity';

const VIDEO_URL = 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4';

async function seed() {
  const ds = new DataSource({
    type: 'better-sqlite3',
    database: join(__dirname, '..', 'data.db'),
    entities: [User, Course, Lesson, ClassEntity, ClassMember, Post, Comment, Question, Answer, Enrollment, Progress],
    synchronize: true,
  });
  await ds.initialize();
  console.log('数据库已连接');

  // Clear all tables
  await ds.getRepository(Progress).clear();
  await ds.getRepository(Enrollment).clear();
  await ds.getRepository(Answer).clear();
  await ds.getRepository(Question).clear();
  await ds.getRepository(Comment).clear();
  await ds.getRepository(Post).clear();
  await ds.getRepository(ClassMember).clear();
  await ds.getRepository(ClassEntity).clear();
  await ds.getRepository(Lesson).clear();
  await ds.getRepository(Course).clear();
  await ds.getRepository(User).clear();

  const userRepo = ds.getRepository(User);
  const courseRepo = ds.getRepository(Course);
  const lessonRepo = ds.getRepository(Lesson);
  const classRepo = ds.getRepository(ClassEntity);
  const memberRepo = ds.getRepository(ClassMember);
  const postRepo = ds.getRepository(Post);
  const commentRepo = ds.getRepository(Comment);
  const questionRepo = ds.getRepository(Question);
  const answerRepo = ds.getRepository(Answer);

  // ===== Users =====
  const hashedAdmin = await bcrypt.hash('admin123', 10);
  const hashedUser = await bcrypt.hash('123456', 10);

  const admin = await userRepo.save(userRepo.create({
    name: '管理员', email: 'admin@demo.com', password: hashedAdmin, role: 'admin', avatar: '', bio: '系统管理员',
  }));
  const student1 = await userRepo.save(userRepo.create({
    name: '张三', email: 'zhangsan@demo.com', password: hashedUser, avatar: '', bio: '计算机科学专业大三学生',
  }));
  const student2 = await userRepo.save(userRepo.create({
    name: '李四', email: 'lisi@demo.com', password: hashedUser, avatar: '', bio: '数学专业大二学生',
  }));
  const student3 = await userRepo.save(userRepo.create({
    name: '王五', email: 'wangwu@demo.com', password: hashedUser, avatar: '', bio: '英语专业大四学生',
  }));

  console.log('用户数据已创建');

  // ===== Courses =====
  const coursesData = [
    { title: 'Python编程入门', description: '从零开始学习Python编程语言，掌握基本语法、数据结构和面向对象编程。', teacherName: '刘教授', category: '编程', rating: 4.8, studentCount: 156, coverImage: '' },
    { title: 'Java高级编程', description: '深入学习Java多线程、集合框架、IO流和网络编程等高级特性。', teacherName: '陈教授', category: '编程', rating: 4.6, studentCount: 98, coverImage: '' },
    { title: '高等数学（上）', description: '涵盖极限、导数、积分等核心内容，配合大量习题讲解。', teacherName: '赵教授', category: '数学', rating: 4.7, studentCount: 230, coverImage: '' },
    { title: '线性代数', description: '系统学习矩阵、向量空间、特征值等线性代数核心概念。', teacherName: '赵教授', category: '数学', rating: 4.5, studentCount: 180, coverImage: '' },
    { title: '大学英语四级备考', description: '针对CET-4考试的听力、阅读、写作和翻译专项训练。', teacherName: '周教授', category: '英语', rating: 4.4, studentCount: 320, coverImage: '' },
    { title: '大学物理（力学篇）', description: '经典力学基础，包括牛顿定律、能量守恒、动量守恒等内容。', teacherName: '孙教授', category: '物理', rating: 4.3, studentCount: 145, coverImage: '' },
    { title: 'UI/UX设计基础', description: '学习用户界面和用户体验设计的基本原则和工具使用。', teacherName: '吴教授', category: '设计', rating: 4.9, studentCount: 88, coverImage: '' },
    { title: 'Web前端开发实战', description: '从HTML/CSS/JavaScript到React框架，完成多个实战项目。', teacherName: '刘教授', category: '编程', rating: 4.7, studentCount: 210, coverImage: '' },
  ];

  const courses = [];
  for (const cd of coursesData) {
    courses.push(await courseRepo.save(courseRepo.create(cd)));
  }
  console.log('课程数据已创建');

  // ===== Lessons =====
  const lessonTitles: Record<string, string[]> = {
    'Python编程入门': ['Python环境搭建与第一个程序', '变量与数据类型', '条件语句与循环', '函数定义与调用', '面向对象编程基础'],
    'Java高级编程': ['多线程编程入门', 'Java集合框架详解', 'IO流与文件操作', 'Java网络编程'],
    '高等数学（上）': ['极限的概念与性质', '导数的定义与计算', '微分中值定理', '不定积分', '定积分及其应用'],
    '线性代数': ['行列式', '矩阵及其运算', '向量空间', '特征值与特征向量'],
    '大学英语四级备考': ['听力技巧精讲', '阅读理解方法论', '写作模板与范文', '翻译技巧总结'],
    '大学物理（力学篇）': ['质点运动学', '牛顿运动定律', '功与能量', '动量与冲量', '刚体力学基础'],
    'UI/UX设计基础': ['设计思维导论', 'Figma工具入门', '色彩与排版', '交互设计原则'],
    'Web前端开发实战': ['HTML5语义化标签', 'CSS3布局与动画', 'JavaScript ES6+', 'React组件开发', 'React状态管理'],
  };

  for (const course of courses) {
    const titles = lessonTitles[course.title] || [];
    for (let i = 0; i < titles.length; i++) {
      await lessonRepo.save(lessonRepo.create({
        courseId: course.id,
        title: titles[i],
        videoUrl: VIDEO_URL,
        duration: 1200 + Math.floor(Math.random() * 1800),
        orderNum: i + 1,
      }));
    }
  }
  console.log('课时数据已创建');

  // ===== Classes =====
  const class1 = await classRepo.save(classRepo.create({
    name: '2024级计算机科学A班', description: '计算机科学与技术专业2024级A班', teacherName: '刘教授', studentCount: 2,
  }));
  const class2 = await classRepo.save(classRepo.create({
    name: '2024级数学B班', description: '数学与应用数学专业2024级B班', teacherName: '赵教授', studentCount: 1,
  }));
  const class3 = await classRepo.save(classRepo.create({
    name: '2024级英语C班', description: '英语专业2024级C班', teacherName: '周教授', studentCount: 1,
  }));

  // Class members
  await memberRepo.save(memberRepo.create({ classId: class1.id, userId: student1.id, role: 'student' }));
  await memberRepo.save(memberRepo.create({ classId: class1.id, userId: student2.id, role: 'student' }));
  await memberRepo.save(memberRepo.create({ classId: class2.id, userId: student2.id, role: 'student' }));
  await memberRepo.save(memberRepo.create({ classId: class3.id, userId: student3.id, role: 'student' }));
  console.log('班级数据已创建');

  // ===== Posts =====
  const postsData = [
    { authorId: student1.id, authorName: '张三', content: '今天学了Python的列表推导式，感觉写法好简洁！大家有什么好的Python学习资源推荐吗？', likes: 12, commentCount: 2 },
    { authorId: student2.id, authorName: '李四', content: '线性代数的特征值计算太难了，有没有同学一起讨论一下？周末可以在图书馆一起学习。', likes: 8, commentCount: 1 },
    { authorId: student3.id, authorName: '王五', content: '分享一个英语学习技巧：每天坚持听BBC新闻15分钟，一个月后听力会有明显提升！', likes: 25, commentCount: 2 },
    { authorId: student1.id, authorName: '张三', content: '完成了Web前端的第一个React项目，虽然还很简单，但感觉收获很大！继续加油💪', likes: 18, commentCount: 1 },
    { authorId: student2.id, authorName: '李四', content: '高数期中考试大家准备得怎么样？我整理了一份复习笔记，需要的同学可以找我。', likes: 30, commentCount: 2 },
    { authorId: student3.id, authorName: '王五', content: '推荐一本设计类的好书《Don\'t Make Me Think》，对理解用户体验设计很有帮助。', likes: 15, commentCount: 1 },
  ];

  const posts = [];
  for (const pd of postsData) {
    posts.push(await postRepo.save(postRepo.create(pd)));
  }
  console.log('帖子数据已创建');

  // ===== Comments on posts =====
  const postComments = [
    { targetType: 'post', targetId: posts[0].id, authorId: student2.id, authorName: '李四', content: '推荐《Python编程：从入门到实践》这本书，非常适合初学者！' },
    { targetType: 'post', targetId: posts[0].id, authorId: student3.id, authorName: '王五', content: '我也在学Python，可以一起交流一下。' },
    { targetType: 'post', targetId: posts[1].id, authorId: student1.id, authorName: '张三', content: '我周末有空，可以一起去图书馆学习。' },
    { targetType: 'post', targetId: posts[2].id, authorId: student1.id, authorName: '张三', content: '谢谢分享，我试试这个方法！' },
    { targetType: 'post', targetId: posts[2].id, authorId: student2.id, authorName: '李四', content: '除了BBC，VOA也不错，语速会慢一些。' },
    { targetType: 'post', targetId: posts[3].id, authorId: student2.id, authorName: '李四', content: '厉害！React确实很有意思，加油！' },
    { targetType: 'post', targetId: posts[4].id, authorId: student1.id, authorName: '张三', content: '可以分享一下你的笔记吗？' },
    { targetType: 'post', targetId: posts[4].id, authorId: student3.id, authorName: '王五', content: '我也需要，高数太难了😭' },
    { targetType: 'post', targetId: posts[5].id, authorId: student1.id, authorName: '张三', content: '这本书确实不错，我之前也看过！' },
  ];
  for (const c of postComments) {
    await commentRepo.save(commentRepo.create(c));
  }

  // ===== Comments on courses =====
  const courseComments = [
    { targetType: 'course', targetId: courses[0].id, authorId: student1.id, authorName: '张三', content: '老师讲得很清楚，Python入门推荐这门课！' },
    { targetType: 'course', targetId: courses[0].id, authorId: student2.id, authorName: '李四', content: '课程内容很丰富，练习题也很有针对性。' },
    { targetType: 'course', targetId: courses[2].id, authorId: student2.id, authorName: '李四', content: '赵教授讲的高数通俗易懂，强烈推荐！' },
    { targetType: 'course', targetId: courses[4].id, authorId: student3.id, authorName: '王五', content: '听力部分讲得特别好，跟着练了两周听力提高了不少。' },
    { targetType: 'course', targetId: courses[7].id, authorId: student1.id, authorName: '张三', content: '实战项目很有意思，边学边做效果非常好。' },
  ];
  for (const c of courseComments) {
    await commentRepo.save(commentRepo.create(c));
  }
  console.log('评论数据已创建');

  // ===== Questions =====
  const questionsData = [
    { courseId: courses[0].id, authorId: student1.id, authorName: '张三', title: 'Python中列表和元组的区别是什么？', content: '列表和元组看起来很相似，请问它们的主要区别是什么？在什么场景下应该使用哪个？', answerCount: 2, solved: 1 },
    { courseId: courses[0].id, authorId: student2.id, authorName: '李四', title: 'Python装饰器怎么理解？', content: '看了好几遍装饰器的教程还是不太明白，能不能用通俗的方式解释一下？', answerCount: 1, solved: 0 },
    { courseId: courses[1].id, authorId: student1.id, authorName: '张三', title: 'Java中synchronized和Lock的区别？', content: '这两种同步方式各有什么优缺点？实际开发中应该怎么选择？', answerCount: 1, solved: 1 },
    { courseId: courses[2].id, authorId: student2.id, authorName: '李四', title: '极限的epsilon-delta定义怎么理解？', content: '课本上的定义太抽象了，能不能举个具体的例子说明一下？', answerCount: 1, solved: 0 },
    { courseId: courses[2].id, authorId: student1.id, authorName: '张三', title: '不定积分的换元法技巧', content: '换元法总是不知道该怎么选择合适的替换变量，有什么规律吗？', answerCount: 1, solved: 0 },
    { courseId: courses[3].id, authorId: student2.id, authorName: '李四', title: '矩阵的秩怎么计算？', content: '课上讲了初等行变换求秩的方法，但遇到比较大的矩阵还是容易算错。', answerCount: 1, solved: 0 },
    { courseId: courses[4].id, authorId: student3.id, authorName: '王五', title: '英语四级听力如何提高？', content: '每次听力都是最薄弱的环节，有没有什么高效的练习方法？', answerCount: 2, solved: 1 },
    { courseId: courses[5].id, authorId: student1.id, authorName: '张三', title: '牛顿第二定律F=ma的适用条件？', content: '是不是所有情况下都能用F=ma？有没有不适用的场景？', answerCount: 1, solved: 0 },
    { courseId: courses[6].id, authorId: student3.id, authorName: '王五', title: 'Figma中如何创建组件？', content: '想学习Figma的组件系统，如何创建可复用的组件？', answerCount: 1, solved: 0 },
    { courseId: courses[7].id, authorId: student1.id, authorName: '张三', title: 'React中useState和useReducer的选择？', content: '什么时候用useState，什么时候用useReducer更合适？', answerCount: 1, solved: 0 },
  ];

  const questions = [];
  for (const qd of questionsData) {
    questions.push(await questionRepo.save(questionRepo.create(qd)));
  }
  console.log('问答数据已创建');

  // ===== Answers =====
  const answersData = [
    { questionId: questions[0].id, authorId: student2.id, authorName: '李四', content: '列表是可变的(mutable)，元组是不可变的(immutable)。列表用方括号[]，元组用圆括号()。如果数据不需要修改，用元组更安全也更高效。', isAccepted: 1 },
    { questionId: questions[0].id, authorId: student3.id, authorName: '王五', content: '补充一下，元组可以作为字典的键，列表不行。因为字典的键需要是不可变类型。', isAccepted: 0 },
    { questionId: questions[1].id, authorId: student1.id, authorName: '张三', content: '装饰器本质上就是一个函数，它接受一个函数作为参数，返回一个新的函数。可以理解为在不修改原函数代码的情况下，给函数添加新功能。', isAccepted: 0 },
    { questionId: questions[2].id, authorId: student2.id, authorName: '李四', content: 'synchronized是Java内置的关键字，使用简单但不够灵活。Lock是接口，提供了更多功能如可中断锁、超时锁、公平锁等。简单场景用synchronized，复杂场景用Lock。', isAccepted: 1 },
    { questionId: questions[3].id, authorId: student1.id, authorName: '张三', content: '可以这样理解：对于任意小的正数ε，都能找到一个正数δ，使得当x与a的距离小于δ时，f(x)与L的距离小于ε。通俗说就是x越接近a，f(x)就越接近L。', isAccepted: 0 },
    { questionId: questions[4].id, authorId: student2.id, authorName: '李四', content: '一般来说，看被积函数中有没有复合函数的结构。如果有√(a²-x²)试试x=asinθ，有1+x²试试x=tanθ。多做题就会有感觉了。', isAccepted: 0 },
    { questionId: questions[5].id, authorId: student1.id, authorName: '张三', content: '建议用初等行变换把矩阵化成行阶梯形，非零行的个数就是秩。注意变换过程中不要出现计算错误，可以多检查几遍。', isAccepted: 0 },
    { questionId: questions[6].id, authorId: student1.id, authorName: '张三', content: '我的方法是：1.每天精听一篇短文 2.跟读模仿 3.做真题听力反复听。坚持一个月会有明显提升！', isAccepted: 1 },
    { questionId: questions[6].id, authorId: student2.id, authorName: '李四', content: '推荐用BBC Learning English和VOA慢速英语来练习，循序渐进效果很好。', isAccepted: 0 },
    { questionId: questions[7].id, authorId: student2.id, authorName: '李四', content: 'F=ma适用于惯性参考系中的宏观低速物体。在接近光速时需要用相对论力学，微观粒子需要用量子力学。', isAccepted: 0 },
    { questionId: questions[8].id, authorId: student1.id, authorName: '张三', content: '在Figma中选择要组件化的元素，然后使用快捷键Ctrl+Alt+K(或右键菜单)创建组件。之后就可以在其他地方插入这个组件的实例了。', isAccepted: 0 },
    { questionId: questions[9].id, authorId: student2.id, authorName: '李四', content: '简单的状态用useState就够了。当状态逻辑复杂、有多个子值、下一个状态依赖上一个状态时，useReducer更合适。', isAccepted: 0 },
  ];

  for (const ad of answersData) {
    await answerRepo.save(answerRepo.create(ad));
  }
  console.log('回答数据已创建');

  // ===== Enrollments =====
  const enrollmentRepo = ds.getRepository(Enrollment);
  const progressRepoSeed = ds.getRepository(Progress);

  // 张三报名前3门课程
  for (let i = 0; i < 3; i++) {
    await enrollmentRepo.save(enrollmentRepo.create({ userId: student1.id, courseId: courses[i].id }));
  }
  // 李四报名第3和第5门课程
  await enrollmentRepo.save(enrollmentRepo.create({ userId: student2.id, courseId: courses[2].id }));
  await enrollmentRepo.save(enrollmentRepo.create({ userId: student2.id, courseId: courses[4].id }));
  console.log('报名数据已创建');

  // ===== Progress =====
  // 张三完成 Python编程入门 前2个课时
  const pythonLessons = await ds.getRepository(Lesson).find({
    where: { courseId: courses[0].id },
    order: { orderNum: 'ASC' },
  });
  for (let i = 0; i < 2 && i < pythonLessons.length; i++) {
    await progressRepoSeed.save(progressRepoSeed.create({
      userId: student1.id,
      courseId: courses[0].id,
      lessonId: pythonLessons[i].id,
      completed: 1,
    }));
  }
  console.log('学习进度数据已创建');

  console.log('\n===== 种子数据创建完成 =====');
  console.log('管理员账号: admin@demo.com / admin123');
  console.log('学生账号: zhangsan@demo.com / 123456');
  console.log('学生账号: lisi@demo.com / 123456');
  console.log('学生账号: wangwu@demo.com / 123456');

  await ds.destroy();
}

seed().catch((err) => {
  console.error('种子数据创建失败:', err);
  process.exit(1);
});
