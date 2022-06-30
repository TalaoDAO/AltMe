import 'package:altme/app/app.dart';
import 'package:altme/home/crypto_bottom_sheet/cubit/crypto_bottom_sheet_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptoBottomSheetView extends StatefulWidget {
  const CryptoBottomSheetView({Key? key}) : super(key: key);

  @override
  State<CryptoBottomSheetView> createState() => _CryptoBottomSheetViewState();
}

class _CryptoBottomSheetViewState extends State<CryptoBottomSheetView> {
  OverlayEntry? _overlay;

  Future<void> _edit(int index) async {
    final l10n = context.l10n;
    final List<CryptoAccountData> cryptoAccount =
        context.read<CryptoBottomSheetCubit>().state.cryptoAccount.data;

    final cryptoAccountData = cryptoAccount[index];

    final newCryptoAccountName = await showDialog<String>(
      context: context,
      builder: (_) => TextFieldDialog(
        label: l10n.cryptoEditLabel,
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
          _overlay = OverlayEntry(
            builder: (_) => const LoadingDialog(),
          );
          Overlay.of(context)!.insert(_overlay!);
        } else {
          if (_overlay != null) {
            _overlay!.remove();
            _overlay = null;
          }
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
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.cryptoAccounts,
                    style: Theme.of(context).textTheme.accountsText,
                  ),
                  Container(height: 10),
                  ListView.builder(
                    itemCount: state.cryptoAccount.data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      final cryptoAccountData = state.cryptoAccount.data[i];
                      final walletAddress = cryptoAccountData.walletAddress;

                      final walletAddressExtracted = walletAddress != ''
                          ? '''${walletAddress.substring(0, 5)} ... ${walletAddress.substring(walletAddress.length - 5)}'''
                          : '';

                      return InkWell(
                        onTap: () {
                          context
                              .read<CryptoBottomSheetCubit>()
                              .setCurrentWalletAccount(i);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: state.currentCryptoIndex == i
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .cryptoAccountNotSelected,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () => _edit(i),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: MyText(
                                    cryptoAccountData.name == ''
                                        ? '${l10n.cryptoAccount} ${i + 1}'
                                        : cryptoAccountData.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .accountsName,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: MyText(
                                      walletAddressExtracted,
                                      style: Theme.of(context)
                                          .textTheme
                                          .walletAddress,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Container(height: 20),
                  MyElevatedButton(
                    text: l10n.cryptoAddAccount,
                    verticalSpacing: 11,
                    fontSize: 17,
                    onPressed: () async {
                      await context
                          .read<CryptoBottomSheetCubit>()
                          .addCryptoAccount();
                    },
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
