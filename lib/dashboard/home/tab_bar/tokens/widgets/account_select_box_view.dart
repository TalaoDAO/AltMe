import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';

class AccountSelectBoxView extends StatelessWidget {
  const AccountSelectBoxView({
    Key? key,
    this.isEnabled = true,
    required this.accounts,
    required this.selectedAccountIndex,
    required this.onSelectAccount,
    required this.title,
  }) : super(key: key);

  final bool isEnabled;
  final List<CryptoAccountData> accounts;
  final int selectedAccountIndex;
  final Function(CryptoAccountData, int) onSelectAccount;
  final String title;

  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      color: Theme.of(context).colorScheme.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isEnabled)
            SelectedAccountItem(
              title: title,
              cryptoAccountData: accounts[selectedAccountIndex],
              isBoxOpen: true,
              onPressed: isEnabled ? null : null,
            ),
          if (isEnabled)
            Theme(
              data: Theme.of(context).copyWith(
                unselectedWidgetColor: Theme.of(context).colorScheme.onPrimary,
                dividerColor: Theme.of(context).colorScheme.cardBackground,
                splashColor: Theme.of(context).colorScheme.transparent,
                highlightColor: Theme.of(context).colorScheme.transparent,
                colorScheme: ColorScheme.dark(
                  primary: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: ExpansionTile(
                initiallyExpanded: false,
                childrenPadding: EdgeInsets.zero,
                tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                title: SelectedAccountItem(
                  title: title,
                  cryptoAccountData: accounts[selectedAccountIndex],
                  isBoxOpen: true,
                  onPressed: isEnabled ? null : null,
                ),
                children: <Widget>[
                  ListView.separated(
                    itemCount: accounts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return SelectBoxAccountItem(
                        cryptoAccountData: accounts[i],
                        isSelected: selectedAccountIndex == i,
                        listIndex: i,
                        onPressed: () {
                          onSelectAccount.call(accounts[i], i);
                        },
                      );
                    },
                    separatorBuilder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Sizes.spaceSmall,
                      ),
                      child: Divider(
                        height: 0.2,
                        color: Theme.of(context).colorScheme.borderColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
