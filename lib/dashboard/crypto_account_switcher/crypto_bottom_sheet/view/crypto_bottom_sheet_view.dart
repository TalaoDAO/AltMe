import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CryptoBottomSheetView extends StatelessWidget {
  const CryptoBottomSheetView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CryptoBottomSheetCubit(
        credentialsCubit: context.read<CredentialsCubit>(),
      ),
      child: const CryptoBottomSheetPage(),
    );
  }
}

class CryptoBottomSheetPage extends StatefulWidget {
  const CryptoBottomSheetPage({super.key});

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
          body: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceDim,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  blurRadius: 5,
                  spreadRadius: -3,
                ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withOpacity(0.12),
                                    width: 0.2,
                                  ),
                                ),
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, profileStae) {
                                    final profileSetting =
                                        profileStae.model.profileSetting;

                                    return ListView.separated(
                                      itemCount:
                                          state.cryptoAccount.data.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, i) {
                                        final data =
                                            state.cryptoAccount.data[i];

                                        if (!data.blockchainType
                                            .isSupported(profileSetting)) {
                                          return Container();
                                        }

                                        return Slidable(
                                          key: ValueKey(i),
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            dragDismissible: false,
                                            children: [
                                              SlidableAction(
                                                backgroundColor: Colors.red,
                                                foregroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                                icon: Icons.delete,
                                                onPressed: (_) async {
                                                  // cannot delete current account
                                                  final currentIndex =
                                                      state.currentCryptoIndex;

                                                  if (currentIndex == i) {
                                                    await showDialog<bool>(
                                                      context: context,
                                                      builder: (context) =>
                                                          ConfirmDialog(
                                                        title: l10n
                                                            .cannotDeleteCurrentAccount,
                                                        yes: l10n.ok,
                                                        showNoButton: false,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  final value =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        ConfirmDialog(
                                                      title: l10n
                                                          .deleteAccountMessage(
                                                              data.name),
                                                      yes: l10n.ok,
                                                      showNoButton: false,
                                                    ),
                                                  );

                                                  if (value != null && value) {
                                                    await context
                                                        .read<
                                                            CryptoBottomSheetCubit>()
                                                        .deleteCryptoAccount(
                                                          index: i,
                                                          blockchainType: data
                                                              .blockchainType,
                                                        );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                          child: CryptoAccountItem(
                                            cryptoAccountData: data,
                                            isSelected:
                                                state.currentCryptoIndex == i,
                                            listIndex: i,
                                            onPressed: () {
                                              context
                                                  .read<
                                                      CryptoBottomSheetCubit>()
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
                                              .withOpacity(0.12),
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
            ),
          ),
        );
      },
    );
  }
}
