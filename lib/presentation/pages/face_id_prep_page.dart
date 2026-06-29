import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/dashboard_shared_widgets.dart';
import 'face_scan_page.dart';
import 'login_page.dart';

class FaceIdPrepPage extends StatefulWidget {
  final String type;
  const FaceIdPrepPage({super.key, required this.type});

  @override
  State<FaceIdPrepPage> createState() => _FaceIdPrepPageState();
}

class _FaceIdPrepPageState extends State<FaceIdPrepPage> {
  int _selectedNavIndex = 0;
  String _firstName = 'Hodim';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('user_first_name') ?? 'Hodim';
    });
  }

  void _onNavTapped(int index) {
    if (index == 3) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      setState(() => _selectedNavIndex = index);
      if (index == 0) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: _buildDetailsCard(context),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DashboardSharedWidgets.buildBottomNav(_selectedNavIndex, _onNavTapped),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'salom',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _firstName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                height: 1.2,
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/logo.png',
          height: 36,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.diamond_outlined, color: AppColors.primaryBlue, size: 36);
          },
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final isCheckIn = widget.type == 'check-in';
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isCheckIn ? Colors.black : Colors.orange.shade800,
                child: const Icon(Icons.alarm, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isCheckIn ? 'Ishga Kelish' : 'Ishdan Ketish',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '8:00 dan 19:00',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textGrey.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            isCheckIn 
              ? 'Ishga kelganligizni tasdiqlang va\nbemalol o\'z ish faoliyatingizni davom\nettiring'
              : 'Ishdan ketayotganingizni tasdiqlang va\nkuningiz xayrli yakunlansin',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Rasmga olish orqali face id dan o\'ting',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => FaceScanPage(type: widget.type)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5A9DFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.camera_alt_outlined, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Rasmga Olish',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
