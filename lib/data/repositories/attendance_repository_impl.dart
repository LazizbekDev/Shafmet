import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

/// AttendanceRepository'ning konkret (data layer) implementatsiyasi.
/// Tashqi dunyo (Dio HTTP client, Geolocator) bilan ishlash shu yerda amalga oshadi.
class AttendanceRepositoryImpl implements AttendanceRepository {
  final Dio _dio;
  final String _baseUrl;

  AttendanceRepositoryImpl({Dio? dio, String baseUrl = 'https://api.example.uz'})
      : _dio = dio ?? Dio(),
        _baseUrl = baseUrl;

  @override
  Future<bool> isWithinOfficeArea() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      AppConfig.officeLatitude,
      AppConfig.officeLongitude,
    );

    return distance <= AppConfig.allowedRadiusMeters;
  }

  @override
  Future<AttendanceResult> markAttendance({
    required Uint8List faceImageBytes,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final model = AttendanceModel(
        userId: 'current_user_id', // Auth servisidan olinadi
        deviceId: 'device_unique_id', // device_info_plus orqali olinadi
        latitude: latitude,
        longitude: longitude,
        faceImageBase64: base64Encode(faceImageBytes),
        timestamp: DateTime.now(),
      );

      // API Data Packet (Stylized) -> Backendga (Django) yuborish.
      final response = await _dio.post(
        '$_baseUrl/api/attendance/mark/',
        data: model.toJson(),
      );

      return AttendanceResult.fromJson(response.data);
    } on DioException catch (e) {
      return AttendanceResult(
        success: false,
        message: e.response?.data['message'] ?? 'Server bilan aloqa xatosi yuz berdi',
      );
    } catch (e) {
      return AttendanceResult(success: false, message: 'Kutilmagan xatolik: $e');
    }
  }
}
