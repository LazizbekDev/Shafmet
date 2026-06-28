import 'dart:typed_data';
import '../../data/models/attendance_model.dart';

/// Domain qatlamidagi abstrakt repository - Clean Architecture qoidasiga ko'ra
/// presentation qatlami faqat shu interfeysga bog'liq bo'ladi, data qatlamiga emas.
abstract class AttendanceRepository {
  /// Joriy joylashuvni olib, ofis hududida ekanligini tekshiradi.
  Future<bool> isWithinOfficeArea();

  /// Yuz rasmi va joylashuv ma'lumotlarini backendga yuborib,
  /// davomatni tasdiqlaydi (Yuzni Tanish + Lokatsiya Tekshirish).
  Future<AttendanceResult> markAttendance({
    required Uint8List faceImageBytes,
    required double latitude,
    required double longitude,
  });
}
