import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class DashboardSharedWidgets {
  static Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  static Widget buildAttendanceStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('15', 'Kelganlar', AppColors.primaryBlue),
        _buildStatCard('1', 'Kelmaganlar', Colors.redAccent),
        _buildStatCard('2', 'Kechikkanlar', Colors.orangeAccent),
      ],
    );
  }

  static Widget buildTasksStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('70%', 'Sotuv do\'kon', AppColors.primaryBlue),
        _buildStatCard('10%', 'Sotuvtashqi', Colors.redAccent),
        _buildStatCard('90%', 'Buxgalterlar', Colors.green),
      ],
    );
  }

  static Widget _buildStatCard(String value, String title, Color valueColor) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget buildGpsTrackingDummy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Gps Nazorat'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGpsCard(Colors.blueAccent),
            _buildGpsCard(Colors.pinkAccent),
            _buildGpsCard(Colors.orangeAccent),
          ],
        ),
      ],
    );
  }

  static Widget _buildGpsCard(Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(Icons.change_history_rounded, color: color, size: 32),
        ),
      ),
    );
  }

  static Widget buildBottomNav(int selectedIndex, Function(int) onTap) {
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
              _navItem(Icons.home_filled, 'asosiy', 0, selectedIndex, onTap),
              _navItem(Icons.calendar_today_outlined, '', 1, selectedIndex, onTap),
              _navItem(Icons.chat_bubble_outline, '', 2, selectedIndex, onTap),
              _navItem(Icons.person_outline, '', 3, selectedIndex, onTap),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _navItem(IconData icon, String label, int index, int selectedIndex, Function(int) onTap) {
    final isSelected = selectedIndex == index;
    
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
      onTap: () => onTap(index),
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
