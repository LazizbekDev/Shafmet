import 'package:equatable/equatable.dart';
import '../../data/models/attendance_model.dart';

/// AttendanceBloc tomonidan chiqariladigan barcha holatlar (states).
abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

/// Boshlang'ich holat - hali hech narsa boshlanmagan.
class AttendanceInitial extends AttendanceState {}

/// Kamera ochiq, liveness jarayoni davom etmoqda.
class AttendanceLivenessInProgress extends AttendanceState {
  final String instructionText; // Masalan: "Ko'zingizni yuming"
  final double progress; // 0.0 - 1.0 oralig'idagi progress

  const AttendanceLivenessInProgress({
    required this.instructionText,
    required this.progress,
  });

  @override
  List<Object?> get props => [instructionText, progress];
}

/// Liveness tekshiruvi muvaffaqiyatli o'tdi, rasm olindi.
class AttendanceLivenessPassed extends AttendanceState {}

/// Joylashuv va yuz ma'lumotlari backendga yuborilayotgan holat (loading).
class AttendanceSubmitting extends AttendanceState {}

/// Backend muvaffaqiyatli javob qaytardi - davomat belgilandi.
class AttendanceSuccess extends AttendanceState {
  final AttendanceResult result;
  final String firstName;
  final bool isLate;
  final DateTime checkInTime;

  AttendanceSuccess(
    this.result, {
    this.firstName = '',
    this.isLate = false,
    DateTime? checkInTime,
  }) : checkInTime = checkInTime ?? DateTime.now();

  @override
  List<Object?> get props => [result, firstName, isLate];
}

/// Xatolik (foydalanuvchi ofis hududida emas, yuz mos kelmadi va h.k.).
class AttendanceFailure extends AttendanceState {
  final String errorMessage;

  const AttendanceFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
