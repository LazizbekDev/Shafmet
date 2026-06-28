import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

/// Davomatni belgilash jarayonini (liveness -> lokatsiya -> backend) boshqaruvchi bloc.
///
/// Oqim: StartFaceScan -> FaceFrameDetected (ko'p marta) -> SubmitAttendance -> Success/Failure
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceBloc({required AttendanceRepository repository})
      : _repository = repository,
        super(AttendanceInitial()) {
    on<StartFaceScan>(_onStartFaceScan);
    on<FaceFrameDetected>(_onFaceFrameDetected);
    on<SubmitAttendance>(_onSubmitAttendance);
    on<ResetAttendance>(_onResetAttendance);
  }

  void _onStartFaceScan(StartFaceScan event, Emitter<AttendanceState> emit) {
    emit(const AttendanceLivenessInProgress(
      instructionText: 'Yuzingizni doiraga joylashtiring',
      progress: 0.0,
    ));
  }

  void _onFaceFrameDetected(
    FaceFrameDetected event,
    Emitter<AttendanceState> emit,
  ) {
    // Liveness progressini hisoblash: blink (50%) + headTurn (50%)
    double progress = 0.0;
    if (event.blinkDetected) progress += 0.5;
    if (event.headTurnDetected) progress += 0.5;

    if (progress >= 1.0) {
      emit(AttendanceLivenessPassed());
    } else {
      emit(AttendanceLivenessInProgress(
        instructionText: event.instructionText,
        progress: progress,
      ));
    }
  }

  Future<void> _onSubmitAttendance(
    SubmitAttendance event,
    Emitter<AttendanceState> emit,
  ) async {
    emit(AttendanceSubmitting());

    try {
      // 1. Avval foydalanuvchi ofis hududida ekanligini tekshiramiz (Office Geofence).
      final isInOffice = await _repository.isWithinOfficeArea();
      if (!isInOffice) {
        emit(const AttendanceFailure(
          'Siz ofis hududidan tashqaridasiz. Davomat belgilash uchun ofisda bo\'lishingiz kerak.',
        ));
        return;
      }

      // 2. Joriy joylashuvni olib, yuz rasmi bilan birga backendga yuboramiz.
      final result = await _repository.markAttendance(
        faceImageBytes: event.faceImageBytes,
        latitude: 0.0, // Repository implementatsiyasi haqiqiy lokatsiyani oladi
        longitude: 0.0,
      );

      if (result.success) {
        emit(AttendanceSuccess(result));
      } else {
        emit(AttendanceFailure(result.message));
      }
    } catch (e) {
      emit(AttendanceFailure('Xatolik yuz berdi: $e'));
    }
  }

  void _onResetAttendance(
    ResetAttendance event,
    Emitter<AttendanceState> emit,
  ) {
    emit(AttendanceInitial());
  }
}
