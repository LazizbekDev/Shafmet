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
      final result = await _repository.markAttendance(
        faceImageBytes: event.faceImageBytes,
        latitude: event.latitude,
        longitude: event.longitude,
        accuracy: event.accuracy,
        isMockLocation: event.isMockLocation,
        type: event.type,
      );
      if (result.success) {
        emit(AttendanceSuccess(
          result,
          firstName: result.firstName,
          isLate: result.isLate,
          checkInTime: DateTime.now(),
        ));
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
