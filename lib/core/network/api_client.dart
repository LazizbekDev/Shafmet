import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio dio;

  // Singleton pattern
  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: dotenv.env['API_URL'] ?? 'http://192.168.1.7:8000/api/',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Tokenni avtomatik qo'shish uchun Interceptor
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // SharedPreferences'dan tokenni o'qiymiz
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');
        
        if (token != null && token.isNotEmpty) {
          if (!options.path.contains('auth/login')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
        }
        
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        // Agar 401 kelsa, tokenni o'chirish yoki refresh mantiqlarini shu yerda yozish mumkin
        return handler.next(e);
      },
    ));
  }
}
