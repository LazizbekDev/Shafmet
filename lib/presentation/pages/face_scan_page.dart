import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import '../../data/repositories/attendance_repository_impl.dart';
import '../../utils/face_detection_helper.dart';
import '../../utils/secure_location_service.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../widgets/liveness_visuals.dart';
import 'attendance_submit_preview_page.dart';

/// "Yuzni va manzil Tasdiqlash" sahifasi.
/// Markazda doira shaklidagi kamera ko'rinishi, atrofida liveness progress halqasi,
/// pastda esa foydalanuvchiga ko'rsatma matnlari chiqadi.
class FaceScanPage extends StatelessWidget {
  const FaceScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc(repository: AttendanceRepositoryImpl())
        ..add(const StartFaceScan()),
      child: const _FaceScanView(),
    );
  }
}

class _FaceScanView extends StatefulWidget {
  const _FaceScanView();

  @override
  State<_FaceScanView> createState() => _FaceScanViewState();
}

class _FaceScanViewState extends State<_FaceScanView> {
  CameraController? _cameraController;
  final FaceDetectionHelper _faceHelper = FaceDetectionHelper();
  bool _isStreaming = false;
  bool _blinkDetected = false;
  Uint8List? _capturedImageBytes;
  double? _capturedLatitude;
  double? _capturedLongitude;
  double? _capturedAccuracyMeters;
  bool _capturedIsMocked = false;
  String locationStatusText = '';
  bool _isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  /// Old kamerani ishga tushirib, real-time frame streamini boshlaydi.
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (cam) => cam.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _cameraController!.initialize();
    if (!mounted) return;

    setState(() {});
    _startImageStream();
  }

  /// Kameradan kelayotgan har bir frame'ni ML Kit orqali tahlil qilib,
  /// natijani AttendanceBloc'ga FaceFrameDetected eventi sifatida yuboradi.
  void _startImageStream() {
    if (_isStreaming || _cameraController == null) return;
    _isStreaming = true;

    _cameraController!.startImageStream((CameraImage image) async {
      final faces = await _faceHelper.processCameraImage(
        image,
        _cameraController!.description.sensorOrientation,
      );

      if (faces.isNotEmpty) {
        _blinkDetected = _blinkDetected || _faceHelper.isLivenessPassed;
        // Joriy challenge holatini bloc'ga yuborish.
        if (!mounted) return;
        context.read<AttendanceBloc>().add(
              FaceFrameDetected(
                blinkDetected: _faceHelper.currentChallenge.index >
                    LivenessChallenge.blink.index,
                headTurnDetected: _faceHelper.isLivenessPassed,
                instructionText: _faceHelper.currentInstructionText,
              ),
            );

        // Liveness to'liq o'tganda - rasmni olib, tasdiqlashga yuboramiz.
        if (_faceHelper.isLivenessPassed && !_isCapturing) {
          await _captureAndSubmit();
        }
      }
    });
  }

  /// Liveness muvaffaqiyatli tugagach, statik rasm olib ko'rsatish uchun saqlaydi.
  /// Backend tayyor bo'lganda bu yerga API chaqiruvi qo'shiladi.
  Future<void> _captureAndSubmit() async {
    if (_cameraController == null || _isCapturing) return;
    _isCapturing = true;

    await _cameraController!.stopImageStream();

    final picture = await _cameraController!.takePicture();
    final bytes = await picture.readAsBytes();
    _capturedImageBytes = bytes;

    // --- Xavfsiz lokatsiyani olish ---
    // SecureLocationService mock GPS ni aniqlaydi va bir nechta o'lchov qiladi.
    try {
      final locationResult = await SecureLocationService.getSecureLocation(
        onProgress: (msg) {
          if (mounted) setState(() => locationStatusText = msg);
        },
      );

      _capturedLatitude = locationResult.latitude;
      _capturedLongitude = locationResult.longitude;
      _capturedAccuracyMeters = locationResult.accuracyMeters;
      _capturedIsMocked = locationResult.isMocked;

      // Mock aniqlansa foydalanuvchini ogohlantiramiz va jarayonni to'xtatamiz.
      if (locationResult.isMocked && mounted) {
        _showMockLocationWarning();
        _isCapturing = false;
        return;
      }

      // Aniqlik juda past bo'lsa ham ogohlantiramiz lekin yuborishga ruxsat beramiz.
      if (!locationResult.isTrusted && mounted) {
        setState(() {
          locationStatusText =
              'Aniqlik past (${locationResult.accuracyMeters.toStringAsFixed(0)}m), '
              'lekin GPS signali kuchayguncha kutilmoqda...';
        });
      }
    } on LocationServiceException catch (e) {
      if (mounted) {
        setState(() => locationStatusText = e.message);
      }
      _isCapturing = false;
      return;
    } catch (e) {
      // Kutilmagan xato — baribir davom etamiz (koordinatlar null qoladi)
      if (mounted) setState(() => locationStatusText = 'GPS xatolik: $e');
    }

    if (!mounted) return;
    context.read<AttendanceBloc>().add(SubmitAttendance(faceImageBytes: bytes));
  }

  void _showMockLocationWarning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Soxta joylashuv!', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: const Text(
          'Qurilmangizda soxta GPS ilovasi (Mock Location) faol. '
          'Davomat belgilash uchun uni o\'chiring va qaytadan urinib ko\'ring.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // FaceScanPage dan ham chiqamiz
            },
            child: const Text('Tushunarli', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceSuccess || state is AttendanceSubmitting) {
            // Backend tayyor bo'lguncha developer preview sahifasiga o'tamiz.
            // Backend tayyor bo'lganda bu yerga haqiqiy success logikasi qo'shiladi.
            if (state is AttendanceSubmitting) return;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AttendanceSubmitPreviewPage(
                  faceImageBytes: _capturedImageBytes,
                  latitude: _capturedLatitude,
                  longitude: _capturedLongitude,
                  accuracyMeters: _capturedAccuracyMeters,
                  isMocked: _capturedIsMocked,
                  timestamp: DateTime.now(),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Stack(
              children: [
                // Top Left Back Button
                Positioned(
                  top: 16,
                  left: 24,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 16),
                          SizedBox(width: 8),
                          Text(
                            'ortga',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main Content
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    // Camera with Liveness Ring
                    Center(
                      child: LivenessRingPainter(
                        progress: _progressFromState(state),
                        child: _cameraController != null &&
                                _cameraController!.value.isInitialized
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                  // For portrait mode, camera width/height are flipped
                                  width: _cameraController!.value.previewSize?.height ?? 100,
                                  height: _cameraController!.value.previewSize?.width ?? 100,
                                  child: CameraPreview(_cameraController!),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ),
                    ),

                    const Spacer(),

                    // Liveness Instruction Text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        _instructionFromState(state),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Bottom Blue Circle Indicator
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryBlue.withValues(alpha: 0.8),
                          width: 6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _progressFromState(AttendanceState state) {
    if (state is AttendanceLivenessInProgress) return state.progress;
    if (state is AttendanceLivenessPassed ||
        state is AttendanceSubmitting ||
        state is AttendanceSuccess) {
      return 1.0;
    }
    return 0.0;
  }

  String _instructionFromState(AttendanceState state) {
    if (state is AttendanceLivenessInProgress) return state.instructionText;
    if (state is AttendanceSubmitting) return 'Tasdiqlanmoqda, kuting...';
    if (state is AttendanceSuccess) return 'Davomat muvaffaqiyatli belgilandi!';
    if (state is AttendanceFailure) return state.errorMessage;
    return 'Yuzingizni doiraga joylashtiring';
  }
}
