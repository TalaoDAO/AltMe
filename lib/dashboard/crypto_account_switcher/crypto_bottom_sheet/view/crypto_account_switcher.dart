import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CryptoAccountSwitcherProvider extends StatelessWidget {
  const CryptoAccountSwitcherProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ManageAccountsCubit(
        credentialsCubit: context.read<CredentialsCubit>(),
        manageNetworkCubit: context.read<ManageNetworkCubit>(),
      ),
      child: const CryptoAccountSwitcher(),
    );
  }
}

class CryptoAccountSwitcher extends StatefulWidget {
  const CryptoAccountSwitcher({super.key});

  @override
  State<CryptoAccountSwitcher> createState() => _CryptoAccountSwitcherState();
}

class _CryptoAccountSwitcherState extends State<CryptoAccountSwitcher> {
  Future<void> _edit(int index) async {
    final l10n = context.l10n;
    final List<CryptoAccountData> cryptoAccount = context
        .read<ManageAccountsCubit>()
        .state
        .cryptoAccount
        .data;
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
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: state.message!,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: Sizes.icon2x,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      l10n.selectAccount,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceNormal),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(Sizes.normalRadius),
                          ),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.12),
                                width: 0.2,
                              ),
                            ),
                            child: BlocBuilder<ProfileCubit, ProfileState>(
                              builder: (context, profileStae) {
                                final profileSetting =
                                    profileStae.model.profileSetting;

                                return ListView.separated(
                                  itemCount: state.cryptoAccount.data.length,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, i) {
                                    final data = state.cryptoAccount.data[i];

                                    if (!data.blockchainType.isSupported(
                                      profileSetting,
                                    )) {
                                      return Container();
                                    }

                                    return Slidable(
                                      key: ValueKey(i),
                                      endActionPane: endActionPane(
                                        context,
                                        l10n,
                                        state,
                                        i,
                                        data,
                                      ),
                                      child: CryptoAccountItem(
                                        cryptoAccountData: data,
                                        isSelected:
                                            state.currentCryptoIndex == i,
                                        listIndex: i,
                                        onPressed: () {
                                          context
                                              .read<ManageAccountsCubit>()
                                              .setCurrentWalletAccount(i);
                                        },
                                        onEditButtonPressed: () => _edit(i),
                                      ),
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
                                          .onSurface
                                          .withValues(alpha: 0.12),
                                    ),
                                  ),
                                );
                              },
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
        );
      },
    );
  }

  ActionPane endActionPane(
    BuildContext context,
    AppLocalizations l10n,
    ManageAccountsState state,
    int i,
    CryptoAccountData data,
  ) {
    return ActionPane(
      motion: const ScrollMotion(),
      dragDismissible: false,
      children: [
        SlidableAction(
          backgroundColor: Colors.transparent,
          foregroundColor: Theme.of(context).colorScheme.onSurface,
          icon: Icons.delete,
          label: l10n.delete,
          onPressed: (_) async {
            // cannot delete current
            // account
            final currentIndex = state.currentCryptoIndex;

            if (currentIndex == i) {
              await showDialog<bool>(
                context: context,
                builder: (context) => ConfirmDialog(
                  title: l10n
                      // ignore: lines_longer_than_80_chars
                      .cannotDeleteCurrentAccount,
                  yes: l10n.ok,
                  showNoButton: false,
                ),
              );
              return;
            }

            final value = await showDialog<bool>(
              context: context,
              builder: (context) => ConfirmDialog(
                title: l10n.deleteAccountMessage(data.name),
                yes: l10n.ok,
                showNoButton: false,
              ),
            );

            if (value != null && value) {
              await context
                  .read<
                    // ignore: lines_longer_than_80_chars
                    ManageAccountsCubit
                  >()
                  .deleteCryptoAccount(
                    index: i,
                    blockchainType: data.blockchainType,
                  );
            }
          },
        ),
      ],
    );
  }
}
