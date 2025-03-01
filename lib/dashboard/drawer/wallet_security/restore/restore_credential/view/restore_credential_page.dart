import 'dart:io';

import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:secure_storage/secure_storage.dart';

class RestoreCredentialPage extends StatelessWidget {
  const RestoreCredentialPage({
    super.key,
    required this.fromOnBoarding,
  });

  final bool fromOnBoarding;

  static Route<dynamic> route({required bool fromOnBoarding}) =>
      MaterialPageRoute<void>(
        builder: (context) => RestoreCredentialPage(
          fromOnBoarding: fromOnBoarding,
        ),
        settings: const RouteSettings(name: '/RestoreCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestoreCredentialCubit(
        secureStorageProvider: getSecureStorage,
        cryptoKeys: const CryptocurrencyKeys(),
        walletCubit: context.read<WalletCubit>(),
        credentialsCubit: context.read<CredentialsCubit>(),
        activityLogManager: ActivityLogManager(getSecureStorage),
        profileCubit: context.read<ProfileCubit>(),
      ),
      child: RestoreCredentialView(fromOnBoarding: fromOnBoarding),
    );
  }
}

class RestoreCredentialView extends StatefulWidget {
  const RestoreCredentialView({
    super.key,
    required this.fromOnBoarding,
  });

  final bool fromOnBoarding;

  @override
  _RestoreCredentialViewState createState() => _RestoreCredentialViewState();
}

class _RestoreCredentialViewState extends State<RestoreCredentialView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: false,
      child: BasePage(
        title: l10n.restoreCredential,
        titleAlignment: Alignment.topCenter,
        padding: const EdgeInsets.only(
          top: 0,
          left: Sizes.spaceSmall,
          right: Sizes.spaceSmall,
          bottom: Sizes.spaceSmall,
        ),
        titleLeading: widget.fromOnBoarding
            ? null
            : BackLeadingButton(
                onPressed: () {
                  if (context.read<RestoreCredentialCubit>().state.status !=
                      AppStatus.loading) {
                    Navigator.of(context).pop();
                  }
                },
              ),
        body: BlocConsumer<RestoreCredentialCubit, RestoreCredentialState>(
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

            if (state.status == AppStatus.restoreWallet) {
              await Navigator.pushAndRemoveUntil<void>(
                context,
                WalletReadyPage.route(),
                (Route<dynamic> route) => route.isFirst,
              );
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
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                UploadFile(
                  filePath: state.backupFilePath,
                  onTap: () async {
                    if (isAndroid) {
                      final appDir = (await getTemporaryDirectory()).path;
                      await Directory(appDir).delete(recursive: true);
                    }
                    await _pickRestoreFile();
                  },
                ),
              ],
            );
          },
        ),
        navigation: Padding(
          padding: const EdgeInsets.all(Sizes.spaceSmall),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BlocBuilder<RestoreCredentialCubit, RestoreCredentialState>(
                builder: (context, state) {
                  return MyElevatedButton(
                    onPressed: state.backupFilePath == null
                        ? null
                        : () => context
                            .read<RestoreCredentialCubit>()
                            .recoverWallet(),
                    text: l10n.loadFile,
                  );
                },
              ),
              const SizedBox(height: 5),
              MyOutlinedButton(
                text: l10n.skip,
                onPressed: () {
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    WalletReadyPage.route(),
                    (Route<dynamic> route) => route.isFirst,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickRestoreFile() async {
    final pickedFile = await FilePicker.platform.pickFiles();
    context
        .read<RestoreCredentialCubit>()
        .setFilePath(filePath: pickedFile?.files.first.path);
  }
}
