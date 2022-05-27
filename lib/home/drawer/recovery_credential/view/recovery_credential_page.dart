import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/home/drawer/recovery_credential/cubit/recovery_credential_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecoveryCredentialPage extends StatefulWidget {
  const RecoveryCredentialPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => BlocProvider(
          create: (context) => RecoveryCredentialCubit(
            walletCubit: context.read<WalletCubit>(),
            cryptoKeys: const CryptocurrencyKeys(),
          ),
          child: const RecoveryCredentialPage(),
        ),
        settings: const RouteSettings(name: '/recoveryCredentialPage'),
      );

  @override
  _RecoveryCredentialPageState createState() => _RecoveryCredentialPageState();
}

class _RecoveryCredentialPageState extends State<RecoveryCredentialPage> {
  late TextEditingController mnemonicController;

  @override
  void initState() {
    super.initState();
    mnemonicController = TextEditingController();
    mnemonicController.addListener(() {
      context
          .read<RecoveryCredentialCubit>()
          .isMnemonicsValid(mnemonicController.text);
    });
  }

  OverlayEntry? _overlay;

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
        titleLeading: BackLeadingButton(
          onPressed: () {
            if (context.read<RecoveryCredentialCubit>().state.status !=
                AppStatus.loading) {
              Navigator.of(context).pop();
            }
          },
        ),
        body: BlocConsumer<RecoveryCredentialCubit, RecoveryCredentialState>(
          listener: (context, state) {
            if (state.status == AppStatus.loading) {
              _overlay = OverlayEntry(
                builder: (_) => const LoadingDialog(),
              );
              Overlay.of(context)!.insert(_overlay!);
            } else {
              if (_overlay != null) {
                _overlay!.remove();
                _overlay = null;
              }
            }

            if (state.status == AppStatus.success &&
                state.recoveredCredentialLength != null) {
              final credentialLength = state.recoveredCredentialLength;
              AlertMessage.showStringMessage(
                context: context,
                message: l10n.recoveryCredentialSuccessMessage(
                  '''$credentialLength ${credentialLength! > 1 ? '${l10n.credential}s' : l10n.credential}''',
                ),
                messageType: MessageType.success,
              );
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
                Column(
                  children: [
                    Text(
                      l10n.recoveryCredentialPhrase,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.recoveryCredentialPhraseExplanation,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                BaseTextField(
                  label: l10n.recoveryMnemonicHintText,
                  controller: mnemonicController,
                  error: state.isTextFieldEdited && !state.isMnemonicValid
                      ? l10n.recoveryMnemonicError
                      : null,
                ),
                const SizedBox(height: 24),
                BaseButton.primary(
                  context: context,
                  textColor: Theme.of(context).colorScheme.onPrimary,
                  gradient: state.isMnemonicValid
                      ? null
                      : LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.buttonDisabled,
                            Theme.of(context).colorScheme.buttonDisabled
                          ],
                        ),
                  onPressed: !state.isMnemonicValid
                      ? null
                      : () async {
                          if (Platform.isAndroid) {
                            final appDir = (await getTemporaryDirectory()).path;
                            await Directory(appDir).delete(recursive: true);
                          }
                          await _pickRecoveryFile();
                        },
                  child: Text(l10n.recoveryCredentialButtonTitle),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickRecoveryFile() async {
    final localization = context.l10n;
    final storagePermission = await Permission.storage.request();
    if (storagePermission.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localization.storagePermissionDeniedMessage)),
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
      if (pickedFile != null) {
        await context
            .read<RecoveryCredentialCubit>()
            .recoverWallet(mnemonicController.text, pickedFile);
      }
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
