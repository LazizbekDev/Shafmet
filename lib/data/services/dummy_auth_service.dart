import '../../domain/models/user_role.dart';

class DummyAuthService {
  /// Dummy login function.
  /// 1/1 -> Employee
  /// 2/2 -> Manager
  /// 3/3 -> Admin
  static Future<UserRole?> login(String phone, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network request
    
    if (phone == '1' && password == '1') {
      return UserRole.employee;
    } else if (phone == '2' && password == '2') {
      return UserRole.manager;
    } else if (phone == '3' && password == '3') {
      return UserRole.admin;
    }
    
    return null; // Invalid credentials
  }
}
