import 'package:altme/app/app.dart';
import 'package:altme/home/crypto_bottom_sheet/cubit/crypto_bottom_sheet_cubit.dart';
import 'package:altme/home/crypto_bottom_sheet/widgets/widgets.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
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
        newCryptoAccountName != cryptoAccountData.name) {
      await context.read<CryptoBottomSheetCubit>().editCryptoAccount(
            newAccountName: newCryptoAccountName,
            index: index,
          );
    }
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
          final MessageHandler messageHandler = state.message!.messageHandler!;
          final String message =
              messageHandler.getMessage(context, messageHandler);
          showDialog<bool>(
            context: context,
            builder: (context) => InfoDialog(
              title: message,
              button: l10n.ok,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
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
                                    .accountBottomSheetBorder,
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
                              separatorBuilder: (_, __) => const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: Sizes.spaceXSmall,
                                ),
                                child: Divider(
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ),
                          Container(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: AddAccountButton(
                              onPressed: () async {
                                int index = 0;

                                final String? derivePathIndex =
                                    await getSecureStorage
                                        .get(SecureStorageKeys.derivePathIndex);

                                if (derivePathIndex != null &&
                                    derivePathIndex.isNotEmpty) {
                                  index = int.parse(derivePathIndex) + 1;
                                }

                                await showDialog<void>(
                                  context: context,
                                  builder: (_) => AddAccountPopUp(
                                    defaultAccountName:
                                        'My Account ${index + 1}',
                                    onCreateAccount: (String accountName) {
                                      Navigator.pop(context);
                                      context
                                          .read<CryptoBottomSheetCubit>()
                                          .addCryptoAccount(
                                            accountName: accountName,
                                          );
                                    },
                                    onImportAccount: (String accountName) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push<void>(
                                        OnBoardingRecoveryPage.route(
                                          accountName: accountName,
                                          isFromOnboard: false,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
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
        );
      },
    );
  }
}
