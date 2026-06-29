import 'dart:typed_data';
import 'package:equatable/equatable.dart';

/// AttendanceBloc'ga yuboriladigan barcha hodisalar (events).
abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();

  @override
  List<Object?> get props => [];
}

/// Face Scan sahifasi ochilganda kamera va liveness jarayonini boshlash uchun.
class StartFaceScan extends AttendanceEvent {
  const StartFaceScan();
}

/// Kameradan kelgan har bir frame liveness tekshiruvi uchun bloc'ga yuboriladi.
class FaceFrameDetected extends AttendanceEvent {
  final bool blinkDetected;
  final bool headTurnDetected;
  final String instructionText;

  const FaceFrameDetected({
    required this.blinkDetected,
    required this.headTurnDetected,
    required this.instructionText,
  });

  // Equatable props-ni qasddan bo'sh qoldiramiz — har bir frame event
  // unikal bo'lishi kerak, aks holda release mode'da bloc duplikat eventlarni
  // o'tkazib yuboradi va liveness progress harakatlanmaydi.
  @override
  List<Object?> get props => [];
}

/// Liveness jarayoni muvaffaqiyatli tugagach, olingan yuz rasmi bilan
/// joylashuvni tekshirib, backendga yuborish uchun.
class SubmitAttendance extends AttendanceEvent {
  final Uint8List faceImageBytes;
  final double latitude;
  final double longitude;
  final double accuracy;
  final bool isMockLocation;
  final String type;

  const SubmitAttendance({
    required this.faceImageBytes,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.isMockLocation,
    this.type = 'check-in',
  });

  @override
  List<Object?> get props => [faceImageBytes, latitude, longitude, accuracy, isMockLocation, type];
}

/// Jarayonni qaytadan boshlash (masalan, xatolikdan keyin "Qayta urinish").
class ResetAttendance extends AttendanceEvent {
  const ResetAttendance();
}
