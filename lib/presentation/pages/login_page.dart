import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/liquid_widgets.dart';
import 'attendance_dashboard_page.dart';

/// Kirish (Login) sahifasi - "Kirish" frame'iga mos premium dizayn.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    // TODO: Auth repository orqali login logikasi qo'shiladi.
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AttendanceDashboardPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              const Text(
                'Kirish',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Assalomalaykum! Tizimga\nkirish pastda',
                style: TextStyle(fontSize: 15, color: AppColors.textGrey),
              ),
              const SizedBox(height: 40),
              _buildTextField(
                controller: _phoneController,
                hint: 'Telefon Raqam',
                icon: Icons.phone_outlined,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hint: 'Parolingiz',
                icon: Icons.lock_outline,
                obscure: true,
              ),
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Parolingiz esdan chiqdimi?',
                  style: TextStyle(color: AppColors.primaryBlue, fontSize: 13),
                ),
              ),
              const SizedBox(height: 28),
              LiquidButton(
                text: 'Kirish',
                isLoading: _isLoading,
                onPressed: _handleLogin,
              ),
              const Spacer(),
              const Center(
                child: Text(
                  'Akkaunt yaratish',
                  style: TextStyle(color: AppColors.textGrey),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.15)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.textGrey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
