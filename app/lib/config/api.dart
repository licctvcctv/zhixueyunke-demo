class Api {
  // Android模拟器用 10.0.2.2，真机改为电脑局域网IP
  static String baseUrl = 'http://10.0.2.2:3000';

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
