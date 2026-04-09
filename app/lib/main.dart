import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/main_page.dart';
import 'pages/course_detail_page.dart';
import 'pages/video_player_page.dart';
import 'pages/post_detail_page.dart';
import 'pages/create_post_page.dart';
import 'pages/settings_page.dart';
import 'pages/about_page.dart';
import 'pages/qa_list_page.dart';
import 'pages/ask_question_page.dart';
import 'pages/edit_profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService()..init(),
      child: MaterialApp(
        title: '智学云课',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF4A90D9),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4A90D9),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0.5,
            centerTitle: true,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90D9),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        home: Consumer<AuthService>(
          builder: (context, auth, _) {
            if (!auth.isInitialized) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (auth.isLoggedIn) return const MainPage();
            return const LoginPage();
          },
        ),
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/main': (context) => const MainPage(),
          '/courseDetail': (context) => const CourseDetailPage(),
          '/videoPlayer': (context) => const VideoPlayerPage(),
          '/postDetail': (context) => const PostDetailPage(),
          '/createPost': (context) => const CreatePostPage(),
          '/settings': (context) => const SettingsPage(),
          '/about': (context) => const AboutPage(),
          '/qa_list': (context) => const QaListPage(),
          '/ask_question': (context) => const AskQuestionPage(),
          '/editProfile': (context) => const EditProfilePage(),
        },
      ),
    );
  }
}
