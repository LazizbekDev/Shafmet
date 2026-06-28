import 'package:attendance_app/data/models/attendance_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/attendance_repository.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

/// Davomatni belgilash jarayonini (liveness -> lokatsiya -> backend) boshqaruvchi bloc.
///
/// Oqim: StartFaceScan -> FaceFrameDetected (ko'p marta) -> SubmitAttendance -> Success/Failure
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {

  AttendanceBloc({required AttendanceRepository repository})
      : super(AttendanceInitial()) {
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

    // -----------------------------------------------------------------------
    // TODO(backend): Backend tayyor bo'lganda quyidagi comment'ni ochib,
    // dummy emit'ni o'chirib tashlang.
    // -----------------------------------------------------------------------
    //
    // try {
    //   final isInOffice = await _repository.isWithinOfficeArea();
    //   if (!isInOffice) {
    //     emit(const AttendanceFailure(
    //       'Siz ofis hududidan tashqaridasiz. Davomat belgilash uchun ofisda bo\'lishingiz kerak.',
    //     ));
    //     return;
    //   }
    //   final result = await _repository.markAttendance(
    //     faceImageBytes: event.faceImageBytes,
    //     latitude: 0.0,
    //     longitude: 0.0,
    //   );
    //   if (result.success) {
    //     emit(AttendanceSuccess(result));
    //   } else {
    //     emit(AttendanceFailure(result.message));
    //   }
    // } catch (e) {
    //   emit(AttendanceFailure('Xatolik yuz berdi: $e'));
    // }

    // Hozircha developer preview uchun dummy success emit qilinadi.
    await Future.delayed(const Duration(milliseconds: 500));
    emit(AttendanceSuccess(AttendanceResult(
      success: true,
      message: 'Developer Preview — backend ulanganda haqiqiy javob keladi',
    )));
  }

  void _onResetAttendance(
    ResetAttendance event,
    Emitter<AttendanceState> emit,
  ) {
    emit(AttendanceInitial());
  }
}
