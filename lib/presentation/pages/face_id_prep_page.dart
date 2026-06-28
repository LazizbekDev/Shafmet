import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'face_scan_page.dart';

class FaceIdPrepPage extends StatefulWidget {
  const FaceIdPrepPage({super.key});

  @override
  State<FaceIdPrepPage> createState() => _FaceIdPrepPageState();
}

class _FaceIdPrepPageState extends State<FaceIdPrepPage> {
  int _selectedNavIndex = 0;

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
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'salom',
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'javohir',
              style: TextStyle(
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
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
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
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.black,
                child: Icon(Icons.alarm, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ishga Kelish',
                    style: TextStyle(
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
                      color: AppColors.textGrey.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'ishga kelganligizni tasdiqlang va\nbemalol oz ish faoliyatingizni davm\nettiring',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textGrey.withOpacity(0.8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'rasmga olish orqali face id dan oting',
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
                  MaterialPageRoute(builder: (_) => const FaceScanPage()),
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

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _navItem(Icons.home_filled, 'asosiy', 0),
              _navItem(Icons.calendar_today_outlined, '', 1),
              _navItem(Icons.chat_bubble_outline, '', 2),
              _navItem(Icons.person_outline, '', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isSelected = _selectedNavIndex == index;
    
    if (isSelected && label.isNotEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        if (index == 0) {
          Navigator.of(context).pop();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Icon(
          icon,
          color: isSelected ? AppColors.primaryBlue : AppColors.textGrey.withOpacity(0.6),
          size: 24,
        ),
      ),
    );
  }
}
