import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/liquid_widgets.dart';
import 'face_id_prep_page.dart';

class AttendanceDashboardPage extends StatefulWidget {
  const AttendanceDashboardPage({super.key});

  @override
  State<AttendanceDashboardPage> createState() => _AttendanceDashboardPageState();
}

class _AttendanceDashboardPageState extends State<AttendanceDashboardPage> {
  int _selectedNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildUserCard(context),
              const SizedBox(height: 28),
              const Text(
                'Topshiriqlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              _buildTaskCard(
                icon: Icons.cleaning_services_outlined,
                title: 'Tozalikga Rioya hudud',
                subtitle: 'hududdiy tozalik',
                reportTime: '1 soatlik hisobot',
                endTime: 'tugash vaqti 15:00',
              ),
              const SizedBox(height: 16),
              _buildTaskCard(
                icon: Icons.inventory_2_outlined,
                title: 'Mahsulot Joylab Chqish',
                subtitle: 'Polka Toldrsh',
                reportTime: '1 soatlik hisobot',
                endTime: 'tugash vaqti 15:00',
              ),
              const SizedBox(height: 24),
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

  Widget _buildUserCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const FaceIdPrepPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF5A9DFF), Color(0xFF3D7FFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryBlue.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primaryBlue, size: 30),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Javohir Hamroyev',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'ichki do\'kon ishchisi',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withOpacity(0.2), height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: Colors.white.withOpacity(0.9), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'chor - 16 - iyun',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white.withOpacity(0.9), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'face id dan o\'tish',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String reportTime,
    required String endTime,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.black,
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.withOpacity(0.15), height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.orangeAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    reportTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.access_time, color: AppColors.primaryBlue, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    endTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
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
