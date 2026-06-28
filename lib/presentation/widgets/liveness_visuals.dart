import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Face Scan sahifasidagi yumaloq kamera ko'rinishi atrofidagi
/// yumshoq animatsiyali liveness ramkasi.
///
/// `progress` 0.0 dan 1.0 gacha bo'lib, liveness jarayoni qanchalik
/// yakunlanganini doira aylanasi orqali ko'rsatadi.
class LivenessRingPainter extends StatefulWidget {
  final double progress;
  final Widget child;
  final double size;

  const LivenessRingPainter({
    super.key,
    required this.progress,
    required this.child,
    this.size = 260,
  });

  @override
  State<LivenessRingPainter> createState() => _LivenessRingPainterState();
}

class _LivenessRingPainterState extends State<LivenessRingPainter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    // "Suyuq" pulslanish effekti uchun cheksiz takrorlanuvchi animatsiya.
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, _) {
        final pulseValue = 1.0 + (_pulseController.value * 0.03);
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Tashqi yumshoq "nafas olayotgan" halqa
              Transform.scale(
                scale: pulseValue,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryBlue.withValues(alpha: 0.25),
                      width: 3,
                    ),
                  ),
                ),
              ),
              // Progressni ko'rsatuvchi animatsiyali halqa
              SizedBox(
                width: widget.size - 14,
                height: widget.size - 14,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  tween: Tween(begin: 0, end: widget.progress),
                  builder: (context, value, _) {
                    return CircularProgressIndicator(
                      value: value,
                      strokeWidth: 5,
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(
                        value >= 1.0 ? AppColors.success : AppColors.primaryBlue,
                      ),
                    );
                  },
                ),
              ),
              // Markazdagi kamera ko'rinishi (doira shaklida kesilgan)
              ClipOval(
                child: SizedBox(
                  width: widget.size - 40,
                  height: widget.size - 40,
                  child: widget.child,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
