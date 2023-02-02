import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/recovery_credential/recovery_credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadRecoveryCredentialPage extends StatelessWidget {
  const UploadRecoveryCredentialPage({
    super.key,
    required this.recoveryCredentialCubit,
  });

  final RecoveryCredentialCubit recoveryCredentialCubit;

  static Route<dynamic> route({
    required RecoveryCredentialCubit recoveryCredentialCubit,
  }) =>
      MaterialPageRoute<void>(
        builder: (context) => UploadRecoveryCredentialPage(
          recoveryCredentialCubit: recoveryCredentialCubit,
        ),
        settings: const RouteSettings(name: '/uploadRecoveryCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: recoveryCredentialCubit,
      child: const UploadRecoveryCredentialView(),
    );
  }
}

class UploadRecoveryCredentialView extends StatefulWidget {
  const UploadRecoveryCredentialView({super.key});

  @override
  _UploadRecoveryCredentialViewState createState() =>
      _UploadRecoveryCredentialViewState();
}

class _UploadRecoveryCredentialViewState
    extends State<UploadRecoveryCredentialView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        if (context.read<RecoveryCredentialCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        title: l10n.restoreCredential,
        titleAlignment: Alignment.topCenter,
        padding: const EdgeInsets.only(
          top: 0,
          left: Sizes.spaceSmall,
          right: Sizes.spaceSmall,
          bottom: Sizes.spaceSmall,
        ),
        titleLeading: BackLeadingButton(
          onPressed: () {
            if (context.read<RecoveryCredentialCubit>().state.status !=
                AppStatus.loading) {
              Navigator.of(context).pop();
            }
          },
        ),
        body: BlocConsumer<RecoveryCredentialCubit, RecoveryCredentialState>(
          listener: (context, state) async {
            if (state.status == AppStatus.loading) {
              LoadingView().show(context: context);
            } else {
              LoadingView().hide();
            }

            if (state.status == AppStatus.success &&
                state.recoveredCredentialLength != null) {
              final credentialLength = state.recoveredCredentialLength;
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: StateMessage.success(
                  stringMessage: l10n.recoveryCredentialSuccessMessage(
                    '''$credentialLength ${credentialLength! > 1 ? '${l10n.credential}s' : l10n.credential}''',
                  ),
                ),
              );
              await Future<void>.delayed(const Duration(milliseconds: 800));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }

            if (state.message != null) {
              AlertMessage.showStateMessage(
                context: context,
                stateMessage: state.message!,
              );
            }
          },
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                const MStepper(
                  totalStep: 2,
                  step: 2,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                Text(
                  l10n.restoreCredentialStep2Title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subtitle3,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                UploadFile(
                  filePath: state.backupFilePath,
                  onTap: () async {
                    if (Platform.isAndroid) {
                      final appDir = (await getTemporaryDirectory()).path;
                      await Directory(appDir).delete(recursive: true);
                    }
                    await _pickRecoveryFile();
                  },
                ),
              ],
            );
          },
        ),
        navigation: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: BlocBuilder<RecoveryCredentialCubit, RecoveryCredentialState>(
            builder: (context, state) {
              return MyGradientButton(
                onPressed: !state.isMnemonicValid ||
                        state.backupFilePath == null
                    ? null
                    : () =>
                        context.read<RecoveryCredentialCubit>().recoverWallet(),
                text: l10n.loadFile,
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _pickRecoveryFile() async {
    final l10n = context.l10n;
    final storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied) {
      AlertMessage.showStateMessage(
        context: context,
        stateMessage: StateMessage.success(
          stringMessage: l10n.storagePermissionDeniedMessage,
        ),
      );
      return;
    }

    if (storagePermission.isPermanentlyDenied) {
      await _showPermissionPopup();
      return;
    }

    if (storagePermission.isGranted || storagePermission.isLimited) {
      final pickedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: ['txt'],
      );
      context
          .read<RecoveryCredentialCubit>()
          .setFilePath(filePath: pickedFile?.files.first.path);
    }
  }

  Future<void> _showPermissionPopup() async {
    final localizations = context.l10n;
    final confirm = await showDialog<bool>(
          context: context,
          builder: (context) => ConfirmDialog(
            title: localizations.storagePermissionRequired,
            subtitle: localizations.storagePermissionPermanentlyDeniedMessage,
            yes: localizations.ok,
            no: localizations.cancel,
          ),
        ) ??
        false;

    if (confirm) {
      await openAppSettings();
    }
  }
}
