import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// Liveness challenge bosqichlari.
enum LivenessChallenge {
  none,
  blink, // "Ko'zingizni yuming"
  turnHead, // "Boshingizni burang"
  completed,
}

/// Real-time kamera streamidan kelayotgan frame'larni Google ML Kit yordamida
/// tahlil qilib, yuzni aniqlaydi va "tirik ekanligini" (liveness) tekshiradi.
///
/// Tekshiruv mezonlari:
/// 1. Ko'z qovog'ini yumish ehtimoli (eyeOpenProbability)
/// 2. Bosh burilish burchagi (headEulerAngleY) - "Ko'zingni yum" challenge'i
class FaceDetectionHelper {
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableClassification: true, // ko'z ochiq/yumiqligini aniqlash uchun
      enableTracking: true,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  LivenessChallenge currentChallenge = LivenessChallenge.blink;
  bool _blinkDetected = false;
  bool _headTurnDetected = false;
  bool _isBusy = false;

  /// CameraImage'ni ML Kit InputImage formatiga o'tkazib, yuzlarni qidiradi.
  Future<List<Face>> processCameraImage(
    CameraImage image,
    int sensorOrientation,
  ) async {
    if (_isBusy) return [];
    _isBusy = true;
    try {
      final inputImage = _convertCameraImage(image, sensorOrientation);
      if (inputImage == null) return [];
      final faces = await _faceDetector.processImage(inputImage);
      _evaluateLiveness(faces);
      return faces;
    } finally {
      _isBusy = false;
    }
  }

  /// Aniqlangan yuzlar asosida joriy liveness challenge holatini yangilaydi.
  void _evaluateLiveness(List<Face> faces) {
    if (faces.isEmpty) return;
    final face = faces.first;

    // 1-bosqich: Ko'z nuqtalarini tekshirish (blink detection)
    if (currentChallenge == LivenessChallenge.blink) {
      final leftEye = face.leftEyeOpenProbability ?? 1.0;
      final rightEye = face.rightEyeOpenProbability ?? 1.0;
      if (leftEye < 0.3 && rightEye < 0.3) {
        _blinkDetected = true;
        currentChallenge = LivenessChallenge.turnHead;
      }
    }
    // 2-bosqich: Burun nuqtasi X/Y orqali bosh harakatini tekshirish
    else if (currentChallenge == LivenessChallenge.turnHead) {
      final headAngleY = face.headEulerAngleY ?? 0;
      if (headAngleY.abs() > 15) {
        _headTurnDetected = true;
        currentChallenge = LivenessChallenge.completed;
      }
    }
  }

  bool get isLivenessPassed =>
      currentChallenge == LivenessChallenge.completed &&
      _blinkDetected &&
      _headTurnDetected;

  /// Foydalanuvchiga ko'rsatiladigan joriy ko'rsatma matni (o'zbek tilida).
  String get currentInstructionText {
    switch (currentChallenge) {
      case LivenessChallenge.blink:
        return 'Iltimos, ko\'zingizni yuming';
      case LivenessChallenge.turnHead:
        return 'Boshingizni biroz yon tomonga buring';
      case LivenessChallenge.completed:
        return 'Tasdiqlash muvaffaqiyatli o\'tdi!';
      default:
        return 'Yuzingizni doiraga joylashtiring';
    }
  }

  void reset() {
    currentChallenge = LivenessChallenge.blink;
    _blinkDetected = false;
    _headTurnDetected = false;
  }

  InputImage? _convertCameraImage(CameraImage image, int sensorOrientation) {
    final imageRotation =
        InputImageRotationValue.fromRawValue(sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            (defaultTargetPlatform == TargetPlatform.iOS
                ? InputImageFormat.bgra8888
                : InputImageFormat.nv21);

    // NV21 formatida Android'da plane'larni to'g'ri birlashtirish kerak.
    // Release mode'da WriteBuffer bilan birlashtirish ba'zan noto'g'ri
    // natija beradi, shuning uchun to'g'ridan-to'g'ri byte nusxalaymiz.
    final Uint8List bytes;
    if (image.planes.length == 1) {
      bytes = image.planes.first.bytes;
    } else {
      int totalSize = 0;
      for (final plane in image.planes) {
        totalSize += plane.bytes.length;
      }
      bytes = Uint8List(totalSize);
      int offset = 0;
      for (final plane in image.planes) {
        bytes.setRange(offset, offset + plane.bytes.length, plane.bytes);
        offset += plane.bytes.length;
      }
    }

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  void dispose() {
    _faceDetector.close();
  }
}
