import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../widgets/dashboard_shared_widgets.dart';
import 'login_page.dart';

/// Bu sahifa backend tayyor bo'lguncha developer preview sifatida ishlaydi.
/// Hodimning yuz rasmi va joylashuv ma'lumotlari backendga yuborilishi lozim bo'lgan
/// formatda ko'rsatiladi. Backend tayyor bo'lganda bu sahifa o'rniga API chaqiruvi qilinadi.
class AttendanceSubmitPreviewPage extends StatefulWidget {
  final Uint8List? faceImageBytes;
  final double? latitude;
  final double? longitude;

  /// GPS aniqlik radiusi metrda. Kichik = aniq (GPS ~5m, Network ~50-200m).
  final double? accuracyMeters;

  /// True bo'lsa Android da mock (soxta) GPS aniqlangan.
  final bool isMocked;

  final DateTime timestamp;

  const AttendanceSubmitPreviewPage({
    super.key,
    this.faceImageBytes,
    this.latitude,
    this.longitude,
    this.accuracyMeters,
    this.isMocked = false,
    required this.timestamp,
  });

  @override
  State<AttendanceSubmitPreviewPage> createState() =>
      _AttendanceSubmitPreviewPageState();
}

class _AttendanceSubmitPreviewPageState
    extends State<AttendanceSubmitPreviewPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  int _selectedNavIndex = 0;

  void _onNavTapped(int index) {
    if (index == 3) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } else {
      setState(() => _selectedNavIndex = index);
    }
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation =
        Tween<double>(begin: 0.95, end: 1.05).animate(_pulseController);
  }

  Future<void> _openMap() async {
    if (widget.latitude == null || widget.longitude == null) return;
    final lat = widget.latitude!;
    final lng = widget.longitude!;
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xaritani ochib bo\'lmadi')),
        );
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

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
              _buildDevBanner(),
              const SizedBox(height: 20),
              _buildFacePreview(),
              const SizedBox(height: 20),
              _buildPayloadCard(),
              const SizedBox(height: 20),
              _buildStatusCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          DashboardSharedWidgets.buildBottomNav(_selectedNavIndex, _onNavTapped),
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
              'Davomat Tasdiqlash',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
                height: 1.2,
              ),
            ),
            Text(
              'Developer Preview',
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Image.asset(
          'assets/images/logo.png',
          height: 36,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.diamond_outlined,
                color: AppColors.primaryBlue, size: 36);
          },
        ),
      ],
    );
  }

  Widget _buildDevBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300, width: 1),
      ),
      child: Row(
        children: [
          Icon(Icons.developer_mode, color: Colors.orange.shade700, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Backend hali ulangan emas. Bu sahifa API tayyor bo\'lganda quyidagi ma\'lumotlarni yuboradi.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.orange.shade800,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.face,
                    color: AppColors.primaryBlue, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Yuz rasmi (face_image)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ScaleTransition(
              scale: _pulseAnimation,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.4),
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: widget.faceImageBytes != null
                      ? Image.memory(
                          widget.faceImageBytes!,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade200,
                          child: Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                        ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          if (widget.faceImageBytes != null)
            Center(
              child: Text(
                '${(widget.faceImageBytes!.lengthInBytes / 1024).toStringAsFixed(1)} KB',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textGrey.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPayloadCard() {
    final lat = widget.latitude?.toStringAsFixed(6) ?? 'aniqlanmoqda...';
    final lng = widget.longitude?.toStringAsFixed(6) ?? 'aniqlanmoqda...';
    final accM = widget.accuracyMeters != null
        ? '${widget.accuracyMeters!.toStringAsFixed(1)} m'
        : 'noma\'lum';
    final time =
        '${widget.timestamp.hour.toString().padLeft(2, '0')}:${widget.timestamp.minute.toString().padLeft(2, '0')}';
    final date =
        '${widget.timestamp.day}.${widget.timestamp.month.toString().padLeft(2, '0')}.${widget.timestamp.year}';

    // Aniqlik darajasiga qarab rang tanlash
    Color accuracyColor;
    String accuracyLabel;
    if (widget.accuracyMeters == null) {
      accuracyColor = Colors.grey;
      accuracyLabel = 'Noma\'lum';
    } else if (widget.accuracyMeters! <= 10) {
      accuracyColor = Colors.green;
      accuracyLabel = 'A\'lo (GPS)';
    } else if (widget.accuracyMeters! <= 50) {
      accuracyColor = Colors.lightGreen;
      accuracyLabel = 'Yaxshi';
    } else if (widget.accuracyMeters! <= 100) {
      accuracyColor = Colors.orange;
      accuracyLabel = 'O\'rtacha';
    } else {
      accuracyColor = Colors.red;
      accuracyLabel = 'Yomon';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.code, color: Colors.purple, size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'API Payload (JSON)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'POST  /api/v1/attendance/check-in',
                  style: TextStyle(
                    color: Color(0xFF89B4FA),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                const Divider(color: Color(0xFF45475A), height: 24),
                _codeRow('face_image', '"<binary JPEG/PNG>"', Colors.yellow.shade300),
                const SizedBox(height: 8),
                _codeRow('latitude', lat, Colors.green.shade300),
                const SizedBox(height: 8),
                _codeRow('longitude', lng, Colors.green.shade300),
                const SizedBox(height: 8),
                _codeRow('accuracy_m', accM, accuracyColor),
                const SizedBox(height: 8),
                _codeRow('timestamp', '"$date $time"', Colors.orange.shade300),
                const SizedBox(height: 8),
                _codeRow('employee_id', '"<token_dan_olinadi>"', Colors.blue.shade300),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Aniqlik indikatori
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: accuracyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: accuracyColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.gps_fixed, color: accuracyColor, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GPS Aniqligi: $accM — $accuracyLabel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: accuracyColor,
                        ),
                      ),
                      if (widget.isMocked)
                        const Text(
                          '⚠️ MOCK GPS ANIQLANDI!',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.latitude != null && widget.longitude != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openMap,
                icon: const Icon(Icons.map_outlined),
                label: const Text('Xaritada ko\'rish'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryBlue,
                  side: const BorderSide(color: AppColors.primaryBlue),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _codeRow(String key, String value, Color valueColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '"$key": ',
          style: const TextStyle(
            color: Color(0xFFCDD6F4),
            fontSize: 13,
            fontFamily: 'monospace',
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 13,
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final hasGoodAccuracy = widget.accuracyMeters != null && widget.accuracyMeters! < 100;
    final locationStatus = widget.isMocked
        ? 'SOXTA!'
        : widget.latitude != null
            ? widget.accuracyMeters != null
                ? '±${widget.accuracyMeters!.toStringAsFixed(0)}m'
                : 'Aniqlandi'
            : 'Kutilmoqda';
    final locationColor = widget.isMocked
        ? Colors.redAccent
        : widget.latitude != null && hasGoodAccuracy
            ? Colors.greenAccent
            : Colors.yellowAccent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: widget.isMocked
              ? [Colors.red.shade700, Colors.red.shade900]
              : const [Color(0xFF5A9DFF), Color(0xFF3D7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (widget.isMocked ? Colors.red : AppColors.primaryBlue)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            widget.isMocked
                ? Icons.gps_off
                : Icons.check_circle_outline,
            color: Colors.white,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            widget.isMocked
                ? 'Soxta GPS aniqlandi!'
                : 'Yuz tekshiruvi muvaffaqiyatli!',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.isMocked
                ? 'Iltimos mock GPS ilovasini o\'chiring'
                : 'Backend ulangach davomat avtomatik belgilanadi',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatusRow(
                  icon: Icons.face_retouching_natural,
                  label: 'Liveness',
                  status: 'O\'tdi',
                  statusColor: Colors.greenAccent,
                ),
              ),
              Container(width: 1, height: 32, color: Colors.white24),
              Expanded(
                child: _buildStatusRow(
                  icon: widget.isMocked
                      ? Icons.gps_off
                      : Icons.gps_fixed,
                  label: 'GPS',
                  status: locationStatus,
                  statusColor: locationColor,
                ),
              ),
              Container(width: 1, height: 32, color: Colors.white24),
              Expanded(
                child: _buildStatusRow(
                  icon: Icons.cloud_upload_outlined,
                  label: 'Backend',
                  status: 'Kutilmoqda',
                  statusColor: Colors.yellowAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow({
    required IconData icon,
    required String label,
    required String status,
    required Color statusColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          status,
          style: TextStyle(
            color: statusColor,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
