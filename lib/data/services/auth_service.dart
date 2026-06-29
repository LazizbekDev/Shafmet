import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/user_role.dart';
import '../../core/network/api_client.dart';

class AuthService {
  static final Dio _dio = ApiClient().dio;

  /// Tizimga kirish
  static Future<UserRole?> login(String username, String password) async {
    try {
      final response = await _dio.post(
        'auth/login',
        data: {
          'username': username,
          'password': password,
        },
      );

      print(username + password);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;
        
        // Agar backend '{ "status": "success", "data": { ... } }' formatida qaytarsa:
        final data = responseData['data'] ?? responseData;
        
        final String? token = data['token'] ?? data['access'];
        final int roleId = data['user']?['role'] ?? data['role'] ?? 1;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          
          final userMap = data['user'] ?? data;
          await prefs.setString('user_first_name', userMap['first_name'] ?? '');
          await prefs.setString('user_last_name', userMap['last_name'] ?? '');
          await prefs.setString('user_position', userMap['position'] ?? 'Hodim');

          switch (roleId) {
            case 1:
              return UserRole.employee;
            case 2:
              return UserRole.manager;
            case 3:
              return UserRole.admin;
            default:
              return UserRole.employee;
          }
        }
      }
      return null;
    } catch (e) {
      print('Login xatosi: $e');
      return null;
    }
  }

  /// Tizimdan chiqish
  static Future<void> logout() async {
    try {
      await _dio.post('auth/logout');
    } catch (e) {
      print('Logout xatosi: $e');
    } finally {
      // Xato bo'lsa ham local tokenni va ma'lumotlarni o'chirib yuboramiz
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_first_name');
      await prefs.remove('user_last_name');
      await prefs.remove('user_position');
    }
  }
}
