import 'package:altme/app/shared/alert_message/alert_message.dart';
import 'package:altme/app/shared/enum/status/app_status.dart';
import 'package:altme/app/shared/enum/type/blockchain_type.dart';
import 'package:altme/app/shared/loading/loading_view.dart';
import 'package:altme/dashboard/crypto_account_switcher/crypto_bottom_sheet/widgets/crypto_accont_item.dart';
import 'package:altme/dashboard/drawer/blockchain_settings/manage_accounts/cubit/manage_accounts_cubit.dart';
import 'package:altme/oidc4vp_transaction/helper/get_decoded_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectCryptoAccount extends StatelessWidget {
  const SelectCryptoAccount({super.key});

  @override
  Widget build(BuildContext context) {
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
        final List<dynamic> decodedTransactions = getDecodedTransactions(
          context,
        );

        // Create a list of chain_id from decodedTransactions
        final List<dynamic> chainIdList = decodedTransactions
            .map((tx) => tx['chain_id'])
            .toList();

        // TODO(hawkbee): should throw an error if no chainId found.
        // bool containsChainId = false;

        return ListView.builder(
          // prototypeItem: CryptoAccountItem(
          //   cryptoAccountData: state.cryptoAccount.data[0],
          //   isSelected: false,
          //   listIndex: 0,
          //   onPressed: () async {},
          // ),
          shrinkWrap: true,
          itemCount: state.cryptoAccount.data.length,
          itemBuilder: (BuildContext listViewContext, int index) {
            final cryptoAccount = state.cryptoAccount.data[index];
            if (cryptoAccount.blockchainType == BlockchainType.tezos) {
              return const SizedBox.shrink();
            }

            /// cryptoAccount.blockchainType.networks contains chainId for
            /// mainet and testnet
            final networks = cryptoAccount.blockchainType.networks;
            networks.removeWhere(
              (element) => !chainIdList.contains(element.chainId),
            );
            if (networks.isEmpty) {
              return const SizedBox.shrink();
            }
            final isSelected = state.currentCryptoIndex == index;
            return CryptoAccountItem(
              cryptoAccountData: cryptoAccount,
              isSelected: isSelected,
              listIndex: index,
              onPressed: () async {
                await context
                    .read<ManageAccountsCubit>()
                    .setCurrentWalletAccount(index);
              },
            );
          },
        );
      },
    );
  }
}
