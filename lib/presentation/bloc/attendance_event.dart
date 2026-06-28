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

  @override
  List<Object?> get props => [blinkDetected, headTurnDetected, instructionText];
}

/// Liveness jarayoni muvaffaqiyatli tugagach, olingan yuz rasmi bilan
/// joylashuvni tekshirib, backendga yuborish uchun.
class SubmitAttendance extends AttendanceEvent {
  final Uint8List faceImageBytes;

  const SubmitAttendance({required this.faceImageBytes});

  @override
  List<Object?> get props => [faceImageBytes];
}

/// Jarayonni qaytadan boshlash (masalan, xatolikdan keyin "Qayta urinish").
class ResetAttendance extends AttendanceEvent {
  const ResetAttendance();
}
