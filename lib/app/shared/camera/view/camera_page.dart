import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
    required this.defaultconfig,
  });

  final CameraConfig defaultconfig;

  static Route<List<int>?> route({
    CameraConfig defaultconfig = const CameraConfig(),
  }) {
    return MaterialPageRoute<List<int>?>(
      settings: const RouteSettings(name: '/cameraPage'),
      builder: (_) => CameraPage(defaultconfig: defaultconfig),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (_) => CameraCubit(defaultConfig: defaultconfig),
      child: const CameraView(),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late final CameraCubit cameraCubit;

  @override
  void initState() {
    cameraCubit = context.read<CameraCubit>();
    Future.microtask(cameraCubit.getCameraController);
    super.initState();
  }

  @override
  void dispose() {
    cameraCubit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      body: BlocConsumer<CameraCubit, CameraState>(
        builder: (_, state) {
          if (state.status == CameraStatus.initializing) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == CameraStatus.initializeFailed) {
            return Center(
              child: Text(
                l10n.failedToInitCamera,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          } else if (state.status == CameraStatus.imageCaptured) {
            final scale = 1 /
                (cameraCubit.cameraController!.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio);
            return Stack(
              children: [
                Center(
                  child: Transform.scale(
                    scale: scale,
                    child: Image.memory(Uint8List.fromList(state.data!)),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  padding: const EdgeInsets.all(Sizes.spaceSmall),
                  child: Row(
                    children: [
                      Flexible(
                        child: MyOutlinedButton(
                          text: l10n.delete,
                          borderRadius: Sizes.smallRadius,
                          verticalSpacing: 16,
                          onPressed: cameraCubit.deleteCapturedImage,
                        ),
                      ),
                      const SizedBox(
                        width: Sizes.spaceSmall,
                      ),
                      Flexible(
                        child: MyGradientButton(
                          borderRadius: Sizes.smallRadius,
                          verticalSpacing: 16,
                          text: l10n.send,
                          onPressed: () {
                            Navigator.pop(context, state.data);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            final scale = 1 /
                (cameraCubit.cameraController!.value.aspectRatio *
                    MediaQuery.of(context).size.aspectRatio);
            return Stack(
              fit: StackFit.expand,
              children: [
                Center(
                  child: Transform.scale(
                    scale: scale,
                    child: CameraPreview(
                      cameraCubit.cameraController!,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.spaceNormal),
                    child: FloatingActionButton(
                      onPressed: cameraCubit.takePhoto,
                      child: const Icon(
                        Icons.camera_outlined,
                        size: Sizes.icon3x,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
        listener: (_, state) {},
      ),
    );
  }
}
