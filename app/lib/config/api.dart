class Api {
  // 真机测试时改为电脑局域网IP，如 http://192.168.x.x:3000
  // Android模拟器用 http://10.0.2.2:3000
  // iOS模拟器用 http://localhost:3000
  // 编译时覆盖: flutter run --dart-define=API_URL=http://x.x.x.x:3000
  static String baseUrl = const String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:3000',
  );

  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String profile = '/api/auth/profile';

  // Courses
  static const String courses = '/api/courses';
  static const String myEnrolled = '/api/courses/my/enrolled';

  // Posts
  static const String posts = '/api/posts';

  // QA
  static const String qa = '/api/qa';

  // Classes
  static const String classes = '/api/classes';
}
