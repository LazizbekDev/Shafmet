/// Backendga yuboriladigan va undan qaytadigan davomat (attendance) ma'lumotlari modeli.
class AttendanceModel {
  final String userId;
  final String deviceId;
  final double latitude;
  final double longitude;
  final String faceImageBase64;
  final DateTime timestamp;

  AttendanceModel({
    required this.userId,
    required this.deviceId,
    required this.latitude,
    required this.longitude,
    required this.faceImageBase64,
    required this.timestamp,
  });

  /// API'ga yuborish uchun JSON (Stylized Data Packet) ko'rinishiga o'tkazish.
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'device_id': deviceId,
      'location': {
        'lat': latitude,
        'lng': longitude,
      },
      'face_image': faceImageBase64,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Backend javobini (Result Packet) parslash uchun factory konstruktor.
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      userId: json['user_id'] ?? '',
      deviceId: json['device_id'] ?? '',
      latitude: (json['location']?['lat'] ?? 0).toDouble(),
      longitude: (json['location']?['lng'] ?? 0).toDouble(),
      faceImageBase64: json['face_image'] ?? '',
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }
}

/// Backend tasdiqlash natijasi (Attendance Success/Fail).
class AttendanceResult {
  final bool success;
  final String message;
  final double? matchConfidence; // DeepFace orqali yuz mosligi foizi

  AttendanceResult({
    required this.success,
    required this.message,
    this.matchConfidence,
  });

  factory AttendanceResult.fromJson(Map<String, dynamic> json) {
    return AttendanceResult(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      matchConfidence: json['match_confidence']?.toDouble(),
    );
  }
}
