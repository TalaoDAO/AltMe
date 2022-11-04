import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OtherItems extends StatelessWidget {
  const OtherItems({
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
        isFromOnboarding: false,
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
          'Others',
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              // const DrawerItemDivider(),
              // DrawerItem(
              //   icon: IconStrings.key,
              //   title: l10n.exportSecretKey,
              //   trailing: Icon(
              //     Icons.chevron_right,
              //     size: 24,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onTap: () async {
              //     final confirm = await showDialog<bool>(
              //           context: context,
              //           builder: (context) => ConfirmDialog(
              //             title: l10n.warningDialogTitle,
              //             subtitle: l10n.warningDialogSubtitle,
              //             yes: l10n.showDialogYes,
              //             no: l10n.showDialogNo,
              //           ),
              //         ) ??
              //         false;

              //     if (confirm) {
              //       final pinCode =
              //          await getSecureStorage.get(SecureStorageKeys.pinCode);
              //       if (pinCode?.isEmpty ?? true) {
              //         await Navigator.of(context).push<void>(
              //           SecretKeyPage.route(),
              //         );
              //       } else {
              //         await Navigator.of(context).push<void>(
              //           PinCodePage.route(
              //             isValidCallback: () =>
              //                 Navigator.of(context).push<void>(
              //               SecretKeyPage.route(),
              //             ),
              //             restrictToBack: false,
              //           ),
              //         );
              //       }
              //     }
              //   },
              // ),
              // const DrawerItemDivider(),
              // DrawerItem(
              //   icon: IconStrings.terms,
              //   title: l10n.termsOfUse,
              //   trailing: Icon(
              //     Icons.chevron_right,
              //     size: 24,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onTap: () =>
              //       Navigator.of(context).push<void>(TermsPage.route()),
              // ),
              // const DrawerItemDivider(),
              // DrawerItem(
              //   icon: IconStrings.wallet,
              //   title: l10n.changePinCode,
              //   trailing: Icon(
              //     Icons.chevron_right,
              //     size: 24,
              //     color: Theme.of(context).colorScheme.primary,
              //   ),
              //   onTap: () async {
              //     final pinCode =
              //         await getSecureStorage.get(SecureStorageKeys.pinCode);
              //     if (pinCode?.isEmpty ?? true) {
              //       await setNewPinCode(context, l10n);
              //     } else {
              //       await Navigator.of(context).push<void>(
              //         PinCodePage.route(
              //           isValidCallback: () =>
              //               setNewPinCode.call(context, l10n),
              //           restrictToBack: false,
              //         ),
              //       );
              //     }
              //   },
              // ),
              DrawerItem(
                icon: IconStrings.wallet,
                title: l10n.connectedApps,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onTap: () {
                  Navigator.of(context).push<void>(
                    BeaconConnectedDappsPage.route(
                      walletAddress: context
                          .read<WalletCubit>()
                          .state
                          .currentAccount
                          .walletAddress,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
