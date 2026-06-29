import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/attendance_model.dart';
import 'attendance_dashboard_page.dart';

/// Davomat yuborilgandan keyingi natija sahifasi.
/// Dizayn: Oynaning orqasi xiralashtirilgan (blur), o'rtada soat va natija, xarita yo'q.
class AttendanceResultPage extends StatefulWidget {
  final String firstName;
  final bool isLate;
  final DateTime checkInTime;
  final AttendanceResult result;

  const AttendanceResultPage({
    super.key,
    required this.firstName,
    required this.isLate,
    required this.checkInTime,
    required this.result,
  });

  @override
  State<AttendanceResultPage> createState() => _AttendanceResultPageState();
}

class _AttendanceResultPageState extends State<AttendanceResultPage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);
    _scaleAnim =
        CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.firstName.isNotEmpty ? widget.firstName : 'Hodim';
    final isLate = widget.isLate;

    return Scaffold(
      backgroundColor: Colors.transparent, // Muhim: fon ko'rinishi uchun
      body: Stack(
        children: [
          // Blur effekti orqa fonga
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.white.withValues(alpha: 0.5), // Yengil oqartirish
              ),
            ),
          ),
          
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Katta soat rasmi
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Image.asset(
                          'assets/images/clock.png',
                          height: 220,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.alarm,
                            size: 160,
                            color: AppColors.primaryBlue.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Natija matni
                      Text(
                        widget.result.message.isNotEmpty
                            ? widget.result.message
                            : '$name Ishga ${isLate ? "Kechikdi" : "vaqtida Keldingiz"}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        isLate
                            ? "Kechikib keldingiz, keyingi safar vaqtida bo'ling"
                            : (widget.result.type == 'check-out' ? "Kuningiz xayrli o'tsin!" : "ishga vaqtida keldingiz zo'r"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: isLate
                              ? Colors.orange.shade700
                              : AppColors.primaryBlue,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      
                      const SizedBox(height: 28),
                      
                      // Vaqt chipi
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          color: isLate
                              ? Colors.orange.withValues(alpha: 0.1)
                              : AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 20,
                                color: isLate
                                    ? Colors.orange.shade700
                                    : AppColors.primaryBlue),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(widget.result.timeLogged ?? widget.checkInTime),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isLate
                                    ? Colors.orange.shade700
                                    : AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Ish boshlash tugmasi
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (_) => const AttendanceDashboardPage()),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF63A4FF), // Och ko'k (Figma dagi kabi)
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'ish boshlash',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Davomat yuborilayotgan paytdagi loading sahifasi.
class AttendanceSubmittingPage extends StatefulWidget {
  const AttendanceSubmittingPage({super.key});

  @override
  State<AttendanceSubmittingPage> createState() =>
      _AttendanceSubmittingPageState();
}

class _AttendanceSubmittingPageState extends State<AttendanceSubmittingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulse;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.93, end: 1.06).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.addListener(() {
      if (mounted) {
        setState(() {
          _dotCount = ((_pulseController.value * 3).floor() % 3) + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotCount;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          Text('ortga',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Yuzni va manzil Tasdiqlash',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14),
                children: [
                  TextSpan(
                    text: 'Malumot va manzil anqlanmoqda ',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  TextSpan(
                    text: '55%$dots',
                    style: const TextStyle(
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            ScaleTransition(
              scale: _pulse,
              child: SizedBox(
                height: 220,
                child: Image.asset(
                  'assets/images/map.png',
                  fit: BoxFit.contain,
                  errorBuilder: (ctx, e, st) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on,
                          size: 80,
                          color: AppColors.primaryBlue.withValues(alpha: 0.7)),
                      const SizedBox(height: 12),
                      Text('Joylashuv aniqlanmoqda$dots',
                          style: TextStyle(color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
