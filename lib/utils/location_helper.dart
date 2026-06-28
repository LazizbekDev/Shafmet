import 'package:geolocator/geolocator.dart';
import '../core/constants/app_colors.dart';

/// Geolokatsiya bilan bog'liq yordamchi funksiyalar.
/// Foydalanuvchi ofis hududida ekanligini (geofence) tekshiradi.
class LocationHelper {
  /// Lokatsiya ruxsatlarini so'raydi va tekshiradi.
  static Future<bool> ensurePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  /// Joriy joylashuvni qaytaradi.
  static Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Foydalanuvchi ofis hududi (geofence) ichida ekanligini tekshiradi.
  static Future<bool> isWithinOffice() async {
    final hasPermission = await ensurePermission();
    if (!hasPermission) return false;

    final position = await getCurrentPosition();
    final distanceInMeters = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      AppConfig.officeLatitude,
      AppConfig.officeLongitude,
    );

    return distanceInMeters <= AppConfig.allowedRadiusMeters;
  }
}
