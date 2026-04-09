import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'api_service.dart';
import '../config/api.dart';

class AuthService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoggedIn = false;
  bool _initialized = false;
  String? _token;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isInitialized => _initialized;
  String? get token => _token;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    if (_token != null) {
      ApiService().setToken(_token!);
      final success = await _fetchProfile();
      if (success) {
        _isLoggedIn = true;
      } else {
        // Token invalid, clear it
        _token = null;
        await prefs.remove('token');
        ApiService().clearToken();
      }
    }
    _initialized = true;
    notifyListeners();
  }

  Future<bool> _fetchProfile() async {
    try {
      final response = await ApiService().get(Api.profile);
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
        return true;
      }
    } catch (e) {
      debugPrint('获取用户信息失败: $e');
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await ApiService().post(Api.login, data: {
        'email': email,
        'password': password,
      });
      if (response.statusCode == 200 || response.statusCode == 201) {
        _token = response.data['token'];
        ApiService().setToken(_token!);
        // Try to get user from login response, otherwise fetch profile
        if (response.data['user'] != null) {
          _currentUser = User.fromJson(response.data['user']);
        } else {
          await _fetchProfile();
        }
        _isLoggedIn = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('登录失败: $e');
    }
    return false;
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
      debugPrint('注册失败: $e');
    }
    return false;
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
