import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camera_state.dart';

part 'camera_cubit.g.dart';

class CameraCubit extends Cubit<CameraState> {
  CameraCubit({
    required this.defaultConfig,
  }) : super(const CameraState());

  final CameraConfig defaultConfig;

  final logger = getLogger('CameraCubit');
  CameraController? cameraController;

  Future<void> getCameraController() async {
    emit(state.copyWith(status: CameraStatus.initializing));
    final List<CameraDescription> cameras = await availableCameras();

    if (cameras.isEmpty) {
      emit(state.copyWith(status: CameraStatus.initializeFailed));
      return;
    }

    CameraDescription? _selectedCamera = cameras[0];
    try {
      if (defaultConfig.frontCameraAsDefault) {
        _selectedCamera = cameras.firstWhere(
          (description) =>
              description.lensDirection == CameraLensDirection.front,
        );
      } else {
        _selectedCamera = cameras.firstWhere(
          (description) =>
              description.lensDirection == CameraLensDirection.back,
        );
      }
    } catch (e, s) {
      emit(state.copyWith(status: CameraStatus.initializeFailed));
      logger.e('error: $e, stack: $s', e, s);
    }
    cameraController = CameraController(
      _selectedCamera ?? cameras[0],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.yuv420,
      enableAudio: false,
    );
    await cameraController!.initialize();
    emit(state.copyWith(status: CameraStatus.intialized));
  }

  Future<void> takePhoto() async {
    try {
      final xFile = await cameraController!.takePicture();
      final imageBytes = (await xFile.readAsBytes()).toList();
      emit(
          state.copyWith(status: CameraStatus.imageCaptured, data: imageBytes));
    } catch (e, s) {
      emit(state.copyWith(status: CameraStatus.error));
      logger.e('error : $e, stack: $s');
    }
  }

  Future<void> deleteCapturedImage() async {
    emit(state.copyWith(status: CameraStatus.intialized));
  }
}
