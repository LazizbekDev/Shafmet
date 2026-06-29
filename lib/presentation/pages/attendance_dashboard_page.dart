import 'package:attendance_app/presentation/pages/face_id_prep_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/dashboard_shared_widgets.dart';
import '../widgets/profile_tab_widget.dart';

class AttendanceDashboardPage extends StatefulWidget {
  const AttendanceDashboardPage({super.key});

  @override
  State<AttendanceDashboardPage> createState() => _AttendanceDashboardPageState();
}

class _AttendanceDashboardPageState extends State<AttendanceDashboardPage> {
  int _selectedNavIndex = 0;
  String _firstName = 'Hodim';
  String _lastName = '';
  String _position = 'Ishchi';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _firstName = prefs.getString('user_first_name') ?? 'Hodim';
      _lastName = prefs.getString('user_last_name') ?? '';
      _position = prefs.getString('user_position') ?? 'Ishchi';
    });
  }

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
    return ProfileTabWidget(
      name: '$_firstName $_lastName',
      role: 'Xodim',
      position: _position,
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

  Widget _buildUserCard(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            title: 'Ishga Kelish',
            icon: Icons.login_rounded,
            color: const Color(0xFF5A9DFF),
            type: 'check-in',
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            title: 'Ishdan Ketish',
            icon: Icons.logout_rounded,
            color: Colors.orange.shade800,
            type: 'check-out',
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required String type,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => FaceIdPrepPage(type: type)),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
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
            color: Colors.black.withValues(alpha: 0.04),
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
          Divider(color: Colors.grey.withValues(alpha: 0.15), height: 1),
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
}
