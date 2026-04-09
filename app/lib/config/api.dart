class Api {
  // 局域网IP，真机和模拟器都能访问
  static String baseUrl = 'http://192.168.6.165:3000';

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
