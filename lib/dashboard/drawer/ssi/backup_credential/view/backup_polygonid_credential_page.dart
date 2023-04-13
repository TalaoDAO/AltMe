import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/drawer.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:secure_storage/secure_storage.dart';

class BackupPolygonIdCredentialPage extends StatelessWidget {
  const BackupPolygonIdCredentialPage({
    super.key,
  });

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/BackupPolygonIdCredentialPage'),
      builder: (_) => const BackupPolygonIdCredentialPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BackupCredentialCubit(
        secureStorageProvider: getSecureStorage,
        cryptoKeys: const CryptocurrencyKeys(),
        walletCubit: context.read<WalletCubit>(),
        fileSaver: FileSaver.instance,
      ),
      child: const BackupPolygonIdCredentialView(),
    );
  }
}

class BackupPolygonIdCredentialView extends StatelessWidget {
  const BackupPolygonIdCredentialView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.backupPolygonIdCredentials,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.only(
        top: 0,
        bottom: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
      ),
      titleLeading: BackLeadingButton(
        onPressed: () {
          if (context.read<BackupCredentialCubit>().state.status !=
              AppStatus.loading) {
            Navigator.of(context).pop();
          }
        },
      ),
      body: BlocConsumer<BackupCredentialCubit, BackupCredentialState>(
        listener: (context, state) async {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
            //set a delay to sure about showing message
            await Future<void>.delayed(const Duration(milliseconds: 800));
          }

          if (state.status == AppStatus.success) {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const MStepper(
                totalStep: 2,
                step: 2,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.saveBackupCredentialTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.messageTitle,
              ),
              const SizedBox(height: Sizes.spaceXLarge),
              Text(
                l10n.saveBackupPolygonCredentialSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.subtitle4,
              ),
              const SizedBox(height: Sizes.spaceXLarge),
              Image.asset(
                ImageStrings.receiveSqure,
                width: Sizes.icon6x,
                height: Sizes.icon6x,
              ),
            ],
          );
        },
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: MyGradientButton(
          onPressed: () async {
            await context.read<BackupCredentialCubit>().encryptAndDownloadFile(
                  isPolygonIdCredentials: true,
                );
          },
          text: l10n.backupCredentialButtonTitle,
        ),
      ),
    );
  }
}
