import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class WalletItems extends StatelessWidget {
  const WalletItems({
    Key? key,
  }) : super(key: key);

  //method for set new pin code
  Future<void> setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push<void>(
      EnterNewPinCodePage.route(
        isValidCallback: () {
          Navigator.of(context).pop();
          AlertMessage.showStringMessage(
            context: context,
            message: l10n.yourPinCodeChangedSuccessfully,
            messageType: MessageType.success,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.wallet,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              ///Mange Accounts
              DrawerItem(
                icon: IconStrings.userRound,
                title: l10n.manageAccounts,
                trailing: Container(),
                onTap: () async {},
              ),
              const DrawerItemDivider(),

              /// Manage Recovery Phrase
              DrawerItem(
                icon: IconStrings.key,
                title: l10n.showRecoveryPhrase,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: l10n.warningDialogTitle,
                          subtitle: l10n.warningDialogSubtitle,
                          yes: l10n.showDialogYes,
                          no: l10n.showDialogNo,
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    final pinCode =
                        await getSecureStorage.get(SecureStorageKeys.pinCode);
                    if (pinCode?.isEmpty ?? true) {
                      await setNewPinCode(context, l10n);
                    } else {
                      await Navigator.of(context).push<void>(
                        PinCodePage.route(
                          isValidCallback: () => Navigator.of(context)
                              .push<void>(RecoveryKeyPage.route()),
                          restrictToBack: false,
                        ),
                      );
                    }
                  }
                },
              ),
              const DrawerItemDivider(),

              ///Manage Decentralize ID keys
              DrawerItem(
                icon: IconStrings.userRound,
                title: l10n.showDecentralizeIDkeys,
                trailing: Container(),
                onTap: () async {},
              ),
              const DrawerItemDivider(),

              ///Address Book
              DrawerItem(
                icon: IconStrings.addressBook,
                title: l10n.addressBook,
                trailing: Container(),
                onTap: () async {},
              ),
              const DrawerItemDivider(),

              /// Reset Wallet
              DrawerItem(
                icon: IconStrings.reset,
                title: l10n.resetWalletButton,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => ConfirmDialog(
                          title: l10n.resetWalletConfirmationText,
                          yes: l10n.delete,
                          no: l10n.showDialogNo,
                          dialogColor: Theme.of(context).colorScheme.error,
                          icon: IconStrings.trash,
                        ),
                      ) ??
                      false;
                  if (confirm) {
                    final pinCode =
                        await getSecureStorage.get(SecureStorageKeys.pinCode);
                    if (pinCode?.isEmpty ?? true) {
                      await context.read<WalletCubit>().resetWallet();
                    } else {
                      await Navigator.of(context).push<void>(
                        PinCodePage.route(
                          isValidCallback: () =>
                              context.read<WalletCubit>().resetWallet(),
                          restrictToBack: false,
                        ),
                      );
                    }
                  }
                },
              ),
              const DrawerItemDivider(),

              /// Backup Credentials
              DrawerItem(
                icon: IconStrings.reset,
                title: l10n.backupCredential,
                onTap: () async {
                  await Navigator.of(context).push<void>(
                    PinCodePage.route(
                      restrictToBack: false,
                      isValidCallback: () {
                        Navigator.of(context)
                            .push<void>(BackupCredentialPage.route());
                      },
                    ),
                  );
                },
              ),
              const DrawerItemDivider(),

              /// Restore Credentials
              DrawerItem(
                icon: IconStrings.restore,
                title: l10n.restoreCredential,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: l10n.warningDialogTitle,
                          subtitle:
                              l10n.recoveryCredentialWarningDialogSubtitle,
                          yes: l10n.showDialogYes,
                          no: l10n.showDialogNo,
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    await Navigator.of(context)
                        .push<void>(RecoveryCredentialPage.route());
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
