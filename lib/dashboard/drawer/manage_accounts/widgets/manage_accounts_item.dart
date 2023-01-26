import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/drawer/manage_accounts/view/account_private_key_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';

class ManageAccountsItem extends StatelessWidget {
  const ManageAccountsItem({
    super.key,
    required this.cryptoAccountData,
    required this.listIndex,
    required this.onPressed,
    required this.onEditButtonPressed,
  });

  final CryptoAccountData cryptoAccountData;
  final int listIndex;
  final VoidCallback onPressed;
  final VoidCallback onEditButtonPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final walletAddressLength = cryptoAccountData.walletAddress.length;
    final walletAddressExtracted = walletAddressLength > 0
        ? '''${cryptoAccountData.walletAddress.substring(0, walletAddressLength - 16)} ... ${cryptoAccountData.walletAddress.substring(cryptoAccountData.walletAddress.length - 5)}'''
        : '';

    final accountName = cryptoAccountData.name.trim().isEmpty
        ? '${l10n.cryptoAccount} ${listIndex + 1}'
        : cryptoAccountData.name;

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceSmall),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.cardHighlighted,
        borderRadius: const BorderRadius.all(
          Radius.circular(Sizes.normalRadius),
        ),
        border: Border.all(
          color: Theme.of(context).colorScheme.borderColor,
          width: 0.25,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            onTap: onPressed,
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: 0,
            title: Row(
              children: [
                Image.asset(
                  cryptoAccountData.blockchainType.icon,
                  width: Sizes.icon,
                ),
                const SizedBox(width: Sizes.spaceXSmall),
                Flexible(
                  child: MyText(
                    accountName,
                    maxLines: 1,
                    minFontSize: 12,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                const SizedBox(width: Sizes.spaceXSmall),
                InkWell(
                  onTap: onEditButtonPressed,
                  child: Icon(
                    Icons.edit,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                const SizedBox(width: Sizes.spaceXSmall),
                if (cryptoAccountData.isImported) const ImportedTag(),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.spaceXSmall),
              child: MyText(
                walletAddressExtracted,
                style: Theme.of(context).textTheme.walletAddress,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SeeAddressButton(
                onTap: () {
                  Navigator.of(context).push<void>(
                    AccountPublicAddressPage.route(
                      accountName: accountName,
                      accountAddress: cryptoAccountData.walletAddress,
                    ),
                  );
                },
              ),
              const SizedBox(
                width: Sizes.spaceSmall,
              ),
              RevealPrivateKeyButton(
                onTap: () async {
                  final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: l10n.warningDialogTitle,
                          subtitle: l10n.accountPrivateKeyAlert,
                          yes: l10n.showDialogYes,
                          no: l10n.showDialogNo,
                        ),
                      ) ??
                      false;

                  if (confirm) {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        restrictToBack: false,
                        isValidCallback: () {
                          Navigator.of(context).push<void>(
                            AccountPrivateKeyPage.route(
                              privateKey: cryptoAccountData.secretKey,
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          const SizedBox(
            height: Sizes.spaceSmall,
          ),
        ],
      ),
    );
  }
}
