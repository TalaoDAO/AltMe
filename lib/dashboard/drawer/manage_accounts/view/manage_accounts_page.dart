import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/manage_accounts/manage_accounts.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ManageAccountsPage extends StatefulWidget {
  const ManageAccountsPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => ManageAccountsCubit(
          secureStorageProvider: getSecureStorage,
          walletCubit: context.read<WalletCubit>(),
        ),
        child: const ManageAccountsPage(),
      ),
      settings: const RouteSettings(name: '/ManageAccountsPage'),
    );
  }

  @override
  State<ManageAccountsPage> createState() => _ManageAccountsPageState();
}

class _ManageAccountsPageState extends State<ManageAccountsPage> {
  Future<void> _edit(int index) async {
    final l10n = context.l10n;
    final List<CryptoAccountData> cryptoAccount =
        context.read<ManageAccountsCubit>().state.cryptoAccount.data;
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
        AlertMessage.showStringMessage(
          context: context,
          message: l10n.sameAccountNameError,
          messageType: MessageType.error,
        );
        return;
      } else {
        await context.read<ManageAccountsCubit>().editCryptoAccount(
              newAccountName: newCryptoAccountName,
              index: index,
              blockchainType: cryptoAccountData.blockchainType,
            );
      }
    }
  }

  Future<void> onAddAccountPressed() async {
    final l10n = context.l10n;
    final List<CryptoAccountData> cryptoAccount =
        context.read<ManageAccountsCubit>().state.cryptoAccount.data;
    final accountNameList = cryptoAccount.map((e) => e.name).toList();

    await showDialog<void>(
      context: context,
      builder: (_) => AddAccountPopUp(
        defaultAccountName: generateDefaultAccountName(
          accountNameList.length,
          accountNameList,
        ),
        onCreateAccount: (String accountName) {
          if (accountName.trim().isEmpty ||
              accountNameList.contains(accountName)) {
            AlertMessage.showStringMessage(
              context: context,
              message: l10n.sameAccountNameError,
              messageType: MessageType.error,
            );
            return;
          } else {
            Navigator.pop(context);
            context.read<ManageAccountsCubit>().addCryptoAccount(
                  accountName: accountName,
                );
          }
        },
        onImportAccount: (String accountName) {
          if (accountName.trim().isEmpty ||
              accountNameList.contains(accountName)) {
            AlertMessage.showStringMessage(
              context: context,
              message: l10n.sameAccountNameError,
              messageType: MessageType.error,
            );
            return;
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).push<void>(
              ImportWalletPage.route(
                accountName: accountName,
                isFromOnboarding: false,
              ),
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ManageAccountsCubit, ManageAccountsState>(
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
        return BasePage(
          title: l10n.blockChainAccounts,
          titleAlignment: Alignment.topCenter,
          scrollView: false,
          titleLeading: const BackLeadingButton(),
          body: BackgroundCard(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ListView.builder(
                    itemCount: state.cryptoAccount.data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, i) {
                      return ManageAccountsItem(
                        cryptoAccountData: state.cryptoAccount.data[i],
                        listIndex: i,
                        onPressed: () {
                          context
                              .read<ManageAccountsCubit>()
                              .setCurrentWalletAccount(i);
                        },
                        onEditButtonPressed: () => _edit(i),
                      );
                    },
                  ),
                  AddAccountButton(
                    onPressed: onAddAccountPressed,
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
