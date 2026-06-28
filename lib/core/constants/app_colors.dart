import 'package:flutter/material.dart';

/// Ilovaning premium oq-ko'k rang palitrasi.
/// "Liquid Design" uslubiga mos yumshoq gradient va soyalar shu yerda belgilanadi.
class AppColors {
  AppColors._();

  static const Color primaryBlue = Color(0xFF3D7FFF);
  static const Color deepBlue = Color(0xFF1E4FCC);
  static const Color background = Color(0xFFF6F9FF);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF1A1F36);
  static const Color textGrey = Color(0xFF8A93A8);
  static const Color success = Color(0xFF2ECC71);
  static const Color danger = Color(0xFFFF5C5C);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, deepBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Ilova bo'ylab ishlatiladigan "liquid" (suyuq) burchak radiuslari.
class AppRadius {
  AppRadius._();
  static const double card = 28.0;
  static const double button = 24.0;
  static const double modal = 32.0;
}

/// Office geofence va liveness sozlamalari.
class AppConfig {
  AppConfig._();
  static const double officeLatitude = 41.311081;
  static const double officeLongitude = 69.279737;
  static const double allowedRadiusMeters = 150.0;
  static const Duration livenessTimeout = Duration(seconds: 20);
}
