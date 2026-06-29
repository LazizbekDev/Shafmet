import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/constants/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../models/attendance_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final Dio _dio = ApiClient().dio;

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
    required double accuracy,
    required bool isMockLocation,
    required String type,
  }) async {
    try {
      final formData = FormData.fromMap({
        'image': MultipartFile.fromBytes(faceImageBytes, filename: 'face_scan.jpg'),
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'is_mock_location': isMockLocation,
        'device_id': 'test_device_001',
        'type': type,
      });

      final response = await _dio.post(
        'attendance/submit',
        data: formData,
      );

      final isSuccess = response.statusCode == 200 || response.statusCode == 201;
      if (isSuccess && response.data != null) {
        return AttendanceResult.fromJson(response.data as Map<String, dynamic>);
      }
      return AttendanceResult(
        success: isSuccess,
        message: 'Muvaffaqiyatli jo`natildi',
      );
    } on DioException catch (e) {
      return AttendanceResult(
        success: false,
        message: e.response?.data?['message'] ?? 'Server bilan aloqa xatosi yuz berdi',
      );
    } catch (e) {
      return AttendanceResult(success: false, message: 'Kutilmagan xatolik: $e');
    }
  }
}
