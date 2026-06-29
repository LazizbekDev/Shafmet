import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/dashboard_shared_widgets.dart';
import '../widgets/profile_tab_widget.dart';
import 'face_id_prep_page.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  int _selectedNavIndex = 0;

  void _onNavTapped(int index) {
    setState(() => _selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedNavIndex,
          children: [
            _buildHomeTab(),
            _buildPlaceholderTab('Ish kunlari jadvali'),
            _buildPlaceholderTab('Bildirishnomalar'),
            _buildProfileTab(),
          ],
        ),
      ),
      bottomNavigationBar: DashboardSharedWidgets.buildBottomNav(
        _selectedNavIndex,
        _onNavTapped,
        labels: const ['asosiy', 'ish kunlari', 'bildirishnomalar', 'profil'],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildUserCard(context),
          const SizedBox(height: 24),
          DashboardSharedWidgets.buildSectionTitle('Ishchilar Nazorati'),
          DashboardSharedWidgets.buildAttendanceStatsRow(),
          const SizedBox(height: 12),
          DashboardSharedWidgets.buildSectionTitle('Ishchilar Vazifasi'),
          DashboardSharedWidgets.buildTasksStatsRow(),
          const SizedBox(height: 12),
          DashboardSharedWidgets.buildGpsTrackingDummy(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPlaceholderTab(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textGrey,
        ),
      ),
    );
  }

  Widget _buildProfileTab() {
    return const ProfileTabWidget(
      name: 'Javohir Hamroyev',
      role: 'Menejer',
      position: 'Nazoratchi',
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
          MaterialPageRoute(builder: (_) => const FaceIdPrepPage(type: 'check-in')),
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
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primaryBlue, size: 30),
                ),
                SizedBox(width: 14),
                Expanded(
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
                        'Menejer',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            Divider(color: Colors.white.withValues(alpha: 0.2), height: 1),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_month_outlined, color: Colors.white.withValues(alpha: 0.9), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'chor - 16 - iyun',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white.withValues(alpha: 0.9), size: 16),
                    const SizedBox(width: 6),
                    Text(
                      'face id dan o\'tish',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
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
}
