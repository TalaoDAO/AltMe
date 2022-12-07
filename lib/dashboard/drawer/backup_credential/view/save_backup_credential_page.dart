import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/backup_credential/cubit/backup_credential_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SaveBackupCredentialPage extends StatelessWidget {
  const SaveBackupCredentialPage({
    super.key,
    required this.backupCredentialCubit,
  });

  final BackupCredentialCubit backupCredentialCubit;

  static Route route({required BackupCredentialCubit backupCredentialCubit}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/saveBackupCredentialPage'),
      builder: (_) => SaveBackupCredentialPage(
        backupCredentialCubit: backupCredentialCubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: backupCredentialCubit,
      child: const SaveBackupCredentialView(),
    );
  }
}

class SaveBackupCredentialView extends StatelessWidget {
  const SaveBackupCredentialView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return WillPopScope(
      onWillPop: () async {
        if (context.read<BackupCredentialCubit>().state.status ==
            AppStatus.loading) {
          return false;
        }
        return true;
      },
      child: BasePage(
        title: l10n.backupCredential,
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
                  l10n.saveBackupCredentialSubtitle,
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
              await context
                  .read<BackupCredentialCubit>()
                  .encryptAndDownloadFile();
            },
            text: l10n.backupCredentialButtonTitle,
          ),
        ),
      ),
    );
  }
}
