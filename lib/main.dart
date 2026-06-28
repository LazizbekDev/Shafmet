import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'presentation/pages/login_page.dart';

void main() {
  runApp(const AttendanceApp());
}

/// Ilovaning asosiy kirish nuqtasi (Frame 57 - Splash dan keyin Login Screen'ga o'tadi).
class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Davomat Nazorati',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}
