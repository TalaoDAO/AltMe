import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: StateMessage.error(
            stringMessage: l10n.sameAccountNameError,
          ),
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

  void onAddAccountPressed() {
    Navigator.of(context).push<void>(ChooseAddAccountMethodPage.route());
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
