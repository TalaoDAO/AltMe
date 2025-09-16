import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({
    super.key,
    required this.defaultconfig,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final CameraConfig defaultconfig;
  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

  static Route<List<int>?> route({
    CameraConfig defaultconfig = const CameraConfig(),
    required CredentialSubjectType credentialSubjectType,
    required VCFormatType vcFormatType,
  }) {
    return MaterialPageRoute<List<int>?>(
      settings: const RouteSettings(name: '/cameraPage'),
      builder: (_) => CameraPage(
        defaultconfig: defaultconfig,
        credentialSubjectType: credentialSubjectType,
        vcFormatType: vcFormatType,
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
        vcFormatType: vcFormatType,
      ),
    );
  }
}

class CameraView extends StatefulWidget {
  const CameraView({
    super.key,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

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
      title: l10n.yotiCameraAppbarTitle,
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
            return Center(
              child: state.status == CameraStatus.imageCaptured
                  ? CameraImageBlured(imageBytes: state.data!)
                  : CameraBlured(
                      cameraController: cameraCubit.cameraController!,
                    ),
            );
          }
        },
        listener: (_, state) async {
          if (state.status == CameraStatus.imageCaptured) {
            LoadingView().show(context: context);
            final customOidc4vcProfile = context
                .read<ProfileCubit>()
                .state
                .model
                .profileSetting
                .selfSovereignIdentityOptions
                .customOidc4vcProfile;
            await context.read<HomeCubit>().aiSelfiValidation(
                  credentialType: widget.credentialSubjectType,
                  imageBytes: state.data!,
                  credentialsCubit: context.read<CredentialsCubit>(),
                  cameraCubit: context.read<CameraCubit>(),
                  oidc4vciDraftType: customOidc4vcProfile.oidc4vciDraft,
                  vcFormatType: widget.vcFormatType,
                  qrCodeScanCubit: context.read<QRCodeScanCubit>(),
                );
            LoadingView().hide();
            await Navigator.pushReplacement<void, void>(
              context,
              AiAgeResultPage.route(
                context: context,
                credentialSubjectType: widget.credentialSubjectType,
                vcFormatType: widget.vcFormatType,
              ),
            );
          }
        },
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceNormal),
        child: BlocBuilder<CameraCubit, CameraState>(
          builder: (context, state) {
            return MyElevatedButton(
              borderRadius: Sizes.smallRadius,
              verticalSpacing: 16,
              text: l10n.takePicture,
              onPressed: state.status != CameraStatus.loading
                  ? cameraCubit.takePhoto
                  : null,
            );
          },
        ),
      ),
    );
  }
}
