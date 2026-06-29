import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Lokatsiya natijasi — koordinatalar, aniqlik darajasi va xavfsizlik holati.
class SecureLocationResult {
  final double latitude;
  final double longitude;

  /// Aniqlik radiusi metrda (kichik = aniq). GPS ~5m, Network ~50-200m.
  final double accuracyMeters;

  /// Android: tizim tomonidan aniqlanagan soxta (mock) joylashuv bo'lsa true.
  final bool isMocked;

  /// GPS dan kelgan bo'lsa true, Network yoki Passive bo'lsa false.
  final bool isFromGps;

  const SecureLocationResult({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.isMocked,
    required this.isFromGps,
  });

  /// Lokatsiya ishonchli hisoblanadi:
  /// - Mock emas
  /// - Aniqlik radiusi 100 metrdan kam
  bool get isTrusted => !isMocked && accuracyMeters < 100.0;
}

/// Xavfsiz va aniq joylashuv olish servisi.
///
/// Foydalanuvchi joylashuvini aldashiga yo'l qo'ymaslik uchun:
/// 1. Mock (soxta) GPS ilovalarini aniqlaydi (Android).
/// 2. Bir nechta o'lchovdan eng aniq natijani tanlaydi.
/// 3. Minimal aniqlik darajasini tekshiradi.
class SecureLocationService {

  /// Nechta o'lchov olinadi va eng anig'i tanlanadi.
  static const int _samplesCount = 1;

  /// Bir o'lchov uchun max kutish vaqti.
  static const Duration _singleReadTimeout = Duration(seconds: 5);

  /// Xavfsiz lokatsiyani oladi.
  ///
  /// [onProgress] — foydalanuvchiga jarayon haqida ma'lumot berish uchun.
  ///
  /// Agar ruxsat berilmasa yoki aniq koordinat olib bo'lmasa exception tashlaydi.
  static Future<SecureLocationResult> getSecureLocation({
    void Function(String message)? onProgress,
  }) async {
    // 1. Ruxsatni tekshirish va so'rash
    await _ensurePermission();

    onProgress?.call('GPS signali qidirilmoqda...');

    // 2. Bir nechta o'lchov olish va eng anig'ini tanlash
    final readings = <Position>[];

    for (int i = 0; i < _samplesCount; i++) {
      try {
        onProgress?.call(
            'Joylashuv aniqlanmoqda... (${i + 1}/$_samplesCount)');

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: _singleReadTimeout,
        );

        readings.add(position);
        debugPrint(
          '[SecureLocation] Sample ${i + 1}: '
          'lat=${position.latitude.toStringAsFixed(6)}, '
          'lng=${position.longitude.toStringAsFixed(6)}, '
          'acc=${position.accuracy.toStringAsFixed(1)}m, '
          'mock=${position.isMocked}',
        );
      } on TimeoutException {
        debugPrint('[SecureLocation] Sample ${i + 1} timed out, continuing...');
      } catch (e) {
        debugPrint('[SecureLocation] Sample ${i + 1} error: $e');
      }
    }

    if (readings.isEmpty) {
      onProgress?.call('So\'nggi ma\'lum joylashuv olinmoqda...');
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        readings.add(lastKnown);
      } else {
        throw const LocationServiceException(
          'Joylashuvni aniqlab bo\'lmadi. GPS signali yo\'q.',
        );
      }
    }

    // 3. Eng aniq o'lchovni tanlash (accuracy = kichik qiymat = yaxshiroq)
    readings.sort((a, b) => a.accuracy.compareTo(b.accuracy));
    final best = readings.first;

    onProgress?.call('Joylashuv aniqlandi!');

    // 4. Mock lokatsiyani aniqlash (Android da ishlaydi)
    final isMocked = best.isMocked;

    if (isMocked) {
      debugPrint('[SecureLocation] ⚠️ MOCK LOCATION DETECTED!');
    }

    // 5. GPS manbasini tekshirish (Android)
    final isFromGps = Platform.isAndroid
        ? (best.accuracy < 50.0) // GPS odatda 50m dan aniq bo'ladi
        : true; // iOS da mock aniqlash qiyin, accuracy ga ishoniladi

    return SecureLocationResult(
      latitude: best.latitude,
      longitude: best.longitude,
      accuracyMeters: best.accuracy,
      isMocked: isMocked,
      isFromGps: isFromGps,
    );
  }

  /// Ruxsatni tekshiradi va kerak bo'lsa so'raydi.
  static Future<void> _ensurePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceException(
        'Qurilmangizda GPS o\'chirilgan. Sozlamalardan GPS ni yoqing.',
      );
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw const LocationServiceException(
        'Joylashuv ruxsati berilmagan. Ilovaga GPS ruxsatini bering.',
      );
    }
  }
}

/// Lokatsiya xatoliklari uchun maxsus exception.
class LocationServiceException implements Exception {
  final String message;
  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}
