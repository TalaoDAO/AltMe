import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/wallet/model/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ManageAccountsPage extends StatefulWidget {
  const ManageAccountsPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      builder: (_) => BlocProvider(
        create: (context) => ManageAccountsCubit(
          credentialsCubit: context.read<CredentialsCubit>(),
          manageNetworkCubit: context.read<ManageNetworkCubit>(),
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
            builder: (context) => ConfirmDialog(
              title: message,
              yes: l10n.ok,
              showNoButton: false,
            ),
          );
        }
      },
      builder: (context, state) {
        return BasePage(
          title: l10n.blockchainAccounts,
          titleAlignment: Alignment.topCenter,
          scrollView: false,
          titleLeading: const BackLeadingButton(),
          padding: EdgeInsets.zero,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, profileStae) {
                    final profileSetting = profileStae.model.profileSetting;
                    return ListView.builder(
                      itemCount: state.cryptoAccount.data.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, i) {
                        final data = state.cryptoAccount.data[i];
                        if (!data.blockchainType.isSupported(profileSetting)) {
                          return Container();
                        }
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          child: Slidable(
                            key: ValueKey(i),
                            endActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dragDismissible: false,
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.transparent,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.onSurface,
                                  icon: Icons.delete,
                                  label: l10n.delete,
                                  onPressed: (_) async {
                                    // cannot delete current account
                                    final currentIndex =
                                        state.currentCryptoIndex;

                                    if (currentIndex == i) {
                                      await showDialog<bool>(
                                        context: context,
                                        builder: (context) => ConfirmDialog(
                                          title:
                                              l10n.cannotDeleteCurrentAccount,
                                          yes: l10n.ok,
                                          showNoButton: false,
                                        ),
                                      );
                                      return;
                                    }

                                    final value = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => ConfirmDialog(
                                        title: l10n
                                            .deleteAccountMessage(data.name),
                                        yes: l10n.ok,
                                        showNoButton: false,
                                      ),
                                    );

                                    if (value != null && value) {
                                      await context
                                          .read<ManageAccountsCubit>()
                                          .deleteCryptoAccount(
                                            index: i,
                                            blockchainType: data.blockchainType,
                                          );
                                    }
                                  },
                                ),
                              ],
                            ),
                            child: ManageAccountsItem(
                              cryptoAccountData: data,
                              listIndex: i,
                              onPressed: () {
                                context
                                    .read<ManageAccountsCubit>()
                                    .setCurrentWalletAccount(i);
                              },
                              onEditButtonPressed: () => _edit(i),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                AddAccountButton(
                  onPressed: onAddAccountPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
