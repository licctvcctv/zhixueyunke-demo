import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';
import '../config/api.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  String? get token => _token;

  // Mock user for demo
  static final User _mockUser = User(
    id: '1',
    name: '张三',
    email: 'zhangsan@example.com',
    avatar: '',
    bio: '热爱学习，追求卓越',
  );

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      _isLoggedIn = true;
      _currentUser = _mockUser;
      ApiService().setToken(_token!);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService().post(Api.login, data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200) {
        _token = response.data['token'];
        _currentUser = User.fromJson(response.data['user']);
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        ApiService().setToken(_token!);
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Server unreachable, use mock data for demo
      debugPrint('服务器无法连接，使用模拟数据: $e');
    }

    // Mock login for demo
    _token = 'mock_token_123';
    _currentUser = _mockUser;
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    notifyListeners();
    return true;
  }

  Future<bool> register(String name, String email, String password) async {
    try {
      final response = await ApiService().post(Api.register, data: {
        'name': name,
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        return await login(email, password);
      }
    } catch (e) {
      debugPrint('服务器无法连接，使用模拟数据: $e');
    }

    // Mock register for demo
    _token = 'mock_token_123';
    _currentUser = User(
      id: '2',
      name: name,
      email: email,
      avatar: '',
      bio: '',
    );
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', _token!);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _currentUser = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    ApiService().clearToken();
    notifyListeners();
  }
}
