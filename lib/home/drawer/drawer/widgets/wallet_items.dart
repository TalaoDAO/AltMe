import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
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
          l10n.wallets,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              DrawerItem(
                icon: IconStrings.userRound,
                title: l10n.manageIssuerIdentity,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () async {},
              ),
              const DrawerItemDivider(),
              DrawerItem(
                icon: IconStrings.wallet,
                title: l10n.changePinCode,
                trailing: Icon(
                  Icons.chevron_right,
                  size: 24,
                  color: Theme.of(context).colorScheme.primary,
                ),
                onTap: () async {
                  final pinCode =
                      await getSecureStorage.get(SecureStorageKeys.pinCode);
                  if (pinCode?.isEmpty ?? true) {
                    await setNewPinCode(context, l10n);
                  } else {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        isValidCallback: () =>
                            setNewPinCode.call(context, l10n),
                        restrictToBack: false,
                      ),
                    );
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
