import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/dashboard_shared_widgets.dart';
import 'login_page.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  int _selectedNavIndex = 0;
  bool _showPresent = true; // true = kelganlar, false = kelmaganlar

  void _onNavTapped(int index) {
    if (index == 3) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      if (index == 0) {
        Navigator.of(context).pop();
      }
      setState(() => _selectedNavIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildTitleToggle(),
                  const SizedBox(height: 16),
                  _buildSearchBar(),
                  const SizedBox(height: 24),
                  _buildTableHeader(),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: 5,
                separatorBuilder: (_, __) => Divider(color: Colors.grey.withValues(alpha: 0.1), height: 1),
                itemBuilder: (context, index) {
                  return _buildEmployeeRow();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: DashboardSharedWidgets.buildBottomNav(_selectedNavIndex, _onNavTapped),
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

  Widget _buildTitleToggle() {
    return Row(
      children: [
        const Text(
          'Ishchilar Nazorati ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _showPresent = true),
          child: Text(
            'kelganlar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _showPresent ? AppColors.primaryBlue : AppColors.textGrey.withValues(alpha: 0.5),
            ),
          ),
        ),
        const Text(
          ' / ',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textGrey,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _showPresent = false),
          child: Text(
            'kelmaganlar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: !_showPresent ? Colors.redAccent : AppColors.textGrey.withValues(alpha: 0.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.search, color: AppColors.textGrey.withValues(alpha: 0.5)),
          hintText: 'Nimadir qidiring...',
          hintStyle: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.5)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(flex: 2, child: Text('Isim Familiya', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text('Lavozimi', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Vaqti', textAlign: TextAlign.right, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildEmployeeRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Expanded(
            flex: 2,
            child: Text(
              'Hamroyev Javohir',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textDark),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              _showPresent ? 'Buxgalter' : 'Sotuv do\'kon',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.primaryBlue.withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              _showPresent ? '8:00' : '0:00',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: _showPresent ? AppColors.primaryBlue : Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
