import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
    required this.defaultconfig,
    required this.credentialSubjectType,
  });

  final CameraConfig defaultconfig;
  final CredentialSubjectType credentialSubjectType;

  static Route<List<int>?> route({
    CameraConfig defaultconfig = const CameraConfig(),
    required CredentialSubjectType credentialSubjectType,
  }) {
    return MaterialPageRoute<List<int>?>(
      settings: const RouteSettings(name: '/cameraPage'),
      builder: (_) => CameraPage(
        defaultconfig: defaultconfig,
        credentialSubjectType: credentialSubjectType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (_) => CameraCubit(
        defaultConfig: defaultconfig,
      ),
      child: CameraView(
        credentialSubjectType: credentialSubjectType,
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.credentialSubjectType,
  });

  final CredentialSubjectType credentialSubjectType;

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
      titleLeading: const BackLeadingButton(),
      title: l10n.placeYourFaceInTheOval,
      titleAlignment: Alignment.topCenter,
      titleMargin: EdgeInsets.zero,
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
          } else {
            return LayoutBuilder(
              builder: (context, BoxConstraints constraints) {
                final camera = cameraCubit.cameraController?.value;
                // fetch screen size
                final size = constraints.biggest;

                // calculate scale depending on screen and camera ratios
                // this is actually size.aspectRatio / (1 / camera.aspectRatio)
                // because camera preview size is received as landscape
                // but we're calculating for portrait orientation
                var scale = size.aspectRatio * camera!.aspectRatio;

                // to prevent scaling down, invert the value
                if (scale < 1) scale = 1 / scale;
                return Column(
                  children: [
                    Text(
                      l10n.cameraSubtitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle3,
                    ),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (state.status == CameraStatus.imageCaptured)
                            Transform.scale(
                              scale: scale,
                              child: Image.memory(
                                Uint8List.fromList(state.data!),
                              ),
                            )
                          else
                            Transform.scale(
                              scale: scale,
                              child: CameraPreview(
                                cameraCubit.cameraController!,
                              ),
                            ),
                          Transform.scale(
                            scale: scale,
                            child: Image.asset(
                              ImageStrings.cameraFaceDetection,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(Sizes.spaceNormal),
                      child: MyGradientButton(
                        borderRadius: Sizes.smallRadius,
                        verticalSpacing: 16,
                        text: l10n.start,
                        onPressed: state.status != CameraStatus.loading
                            ? cameraCubit.takePhoto
                            : null,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        listener: (_, state) async {
          if (state.status == CameraStatus.imageCaptured) {
            LoadingView().show(context: context);
            await context.read<HomeCubit>().aiSelfiValidation(
                  credentialType: widget.credentialSubjectType,
                  imageBytes: state.data!,
                );
            LoadingView().hide();
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }
}
