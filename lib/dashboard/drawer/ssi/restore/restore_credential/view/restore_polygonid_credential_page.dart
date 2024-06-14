import 'dart:io';

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
import 'package:permission_handler/permission_handler.dart';
import 'package:polygonid/polygonid.dart';
import 'package:secure_storage/secure_storage.dart';

class RestorePolygonIdCredentialPage extends StatelessWidget {
  const RestorePolygonIdCredentialPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (context) => const RestorePolygonIdCredentialPage(),
        settings: const RouteSettings(name: '/RestorePolygonIdCredentialPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RestoreCredentialCubit(
        secureStorageProvider: getSecureStorage,
        cryptoKeys: const CryptocurrencyKeys(),
        walletCubit: context.read<WalletCubit>(),
        credentialsCubit: context.read<CredentialsCubit>(),
        polygonId: PolygonId(),
      ),
      child: const RestorePolygonIdCredentialView(),
    );
  }
}

class RestorePolygonIdCredentialView extends StatefulWidget {
  const RestorePolygonIdCredentialView({super.key});

  @override
  _RestorePolygonIdCredentialViewState createState() =>
      _RestorePolygonIdCredentialViewState();
}

class _RestorePolygonIdCredentialViewState
    extends State<RestorePolygonIdCredentialView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.restorePolygonIdCredentials,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      titleLeading: BackLeadingButton(
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
                  if (Platform.isAndroid) {
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
        child: BlocBuilder<RestoreCredentialCubit, RestoreCredentialState>(
          builder: (context, state) {
            return MyGradientButton(
              onPressed: state.backupFilePath == null
                  ? null
                  : () => context.read<RestoreCredentialCubit>().recoverWallet(
                        isPolygonIdCredentials: true,
                      ),
              text: l10n.loadFile,
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickRestoreFile() async {
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
          .read<RestoreCredentialCubit>()
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
