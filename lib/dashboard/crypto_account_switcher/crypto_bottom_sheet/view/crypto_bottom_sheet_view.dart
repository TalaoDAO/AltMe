import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class CryptoBottomSheetView extends StatelessWidget {
  const CryptoBottomSheetView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBottomSheetCubit(
        secureStorageProvider: getSecureStorage,
        walletCubit: context.read<WalletCubit>(),
      ),
      child: const CryptoBottomSheetPage(),
    );
  }
}

class CryptoBottomSheetPage extends StatefulWidget {
  const CryptoBottomSheetPage({Key? key}) : super(key: key);

  @override
  State<CryptoBottomSheetPage> createState() => _CryptoBottomSheetPageState();
}

class _CryptoBottomSheetPageState extends State<CryptoBottomSheetPage> {
  Future<void> _edit(int index) async {
    final l10n = context.l10n;
    final List<CryptoAccountData> cryptoAccount =
        context.read<CryptoBottomSheetCubit>().state.cryptoAccount.data;
    final accountNameList = cryptoAccount.map((e) => e.name).toList();

    final cryptoAccountData = cryptoAccount[index];

    final newCryptoAccountName = await showDialog<String>(
      context: context,
      builder: (_) => TextFieldDialog(
        label: '',
        title: l10n.cryptoEditConfirmationDialog,
        initialValue: cryptoAccountData.name,
        yes: l10n.cryptoEditConfirmationDialogYes,
        no: l10n.cryptoEditConfirmationDialogNo,
      ),
    );

    if (newCryptoAccountName != null &&
        newCryptoAccountName != cryptoAccountData.name &&
        newCryptoAccountName.isNotEmpty) {
      if (accountNameList.contains(newCryptoAccountName)) {
        return AlertMessage.showStateMessage(
          context: context,
          stateMessage: StateMessage.error(
            stringMessage: l10n.sameAccountNameError,
          ),
        );
      } else {
        await context.read<CryptoBottomSheetCubit>().editCryptoAccount(
              newAccountName: newCryptoAccountName,
              index: index,
              blockchainType: cryptoAccountData.blockchainType,
            );
      }
    }
  }

  void onAddAccountPressed() {
    Navigator.of(context).push<void>(ChooseAddAccountMethodPage.route());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<CryptoBottomSheetCubit, CryptoBottomSheetState>(
      listener: (context, state) {
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
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  blurRadius: 5,
                  spreadRadius: -3,
                )
              ],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(Sizes.largeRadius),
                topLeft: Radius.circular(Sizes.largeRadius),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance_wallet_rounded,
                          size: Sizes.icon2x,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        const SizedBox(width: Sizes.spaceXSmall),
                        Text(
                          l10n.selectAccount,
                          style: Theme.of(context).textTheme.accountsText,
                        ),
                      ],
                    ),
                    const SizedBox(height: Sizes.spaceNormal),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .accountBottomSheetBorderColor,
                                  width: 0.2,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Sizes.normalRadius),
                                ),
                              ),
                              child: ListView.separated(
                                itemCount: state.cryptoAccount.data.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, i) {
                                  return CryptoAccountItem(
                                    cryptoAccountData:
                                        state.cryptoAccount.data[i],
                                    isSelected: state.currentCryptoIndex == i,
                                    listIndex: i,
                                    onPressed: () {
                                      context
                                          .read<CryptoBottomSheetCubit>()
                                          .setCurrentWalletAccount(i);
                                    },
                                    onEditButtonPressed: () => _edit(i),
                                  );
                                },
                                separatorBuilder: (_, __) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Sizes.spaceSmall,
                                  ),
                                  child: Divider(
                                    height: 0.2,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .borderColor,
                                  ),
                                ),
                              ),
                            ),
                            Container(height: 20),
                            Align(
                              alignment: Alignment.center,
                              child: AddAccountButton(
                                onPressed: onAddAccountPressed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
