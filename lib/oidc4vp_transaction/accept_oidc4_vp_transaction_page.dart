import 'dart:typed_data';

import 'package:altme/app/shared/alert_message/alert_message.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/enum/message/response_string/response_string.dart';
import 'package:altme/app/shared/enum/status/app_status.dart';
import 'package:altme/app/shared/enum/type/blockchain_type.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:altme/app/shared/loading/loading_view.dart';
import 'package:altme/app/shared/message_handler/response_message.dart';
import 'package:altme/app/shared/models/blockchain_network/ethereum_network.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/crypto_account_switcher/crypto_bottom_sheet/widgets/crypto_accont_item.dart';
import 'package:altme/dashboard/drawer/blockchain_settings/blockchain_settings.dart';
import 'package:altme/dashboard/qr_code/qr_code_scan/cubit/qr_code_scan_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/oidc4vp_transaction/oidc4vp_transaction.dart';
import 'package:altme/scan/cubit/scan_cubit.dart';
import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/widget/trusted_entity_details.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AcceptOidc4VpTransactionPage extends StatelessWidget {
  const AcceptOidc4VpTransactionPage({
    super.key,
    required this.trustedListEnabled,
    required this.trustedEntity,
    required this.uri,
    required this.showPrompt,
    required this.client,
  });
  final bool trustedListEnabled;
  final TrustedEntity? trustedEntity;
  final Uri uri;
  final bool showPrompt;
  final DioClient client;

  static Route<dynamic> route({
    required bool trustedListEnabled,
    required TrustedEntity? trustedEntity,
    required Uri uri,
    required bool showPrompt,
    required DioClient client,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AcceptOidc4VpTransactionPage'),
      builder: (_) => AcceptOidc4VpTransactionPage(
        trustedListEnabled: trustedListEnabled,
        trustedEntity: trustedEntity,
        uri: uri,
        showPrompt: showPrompt,
        client: client,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.scanPromptHost,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      navigation: NavigationButtons(uri: uri),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                DisplayEntity(
                  trustedListEnabled: trustedListEnabled,
                  trustedEntity: trustedEntity,
                  notTrustedText: l10n.notTrustedEntity,
                  uri: uri,
                  client: client,
                ),

                // TransactionPresentation widget displays decoded transactions
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: TransactionPresentation(),
                ),

                Padding(
                  padding: const EdgeInsets.all(8),
                  child: BlocProvider(
                    create: (context) => ManageAccountsCubit(
                      credentialsCubit: context.read<CredentialsCubit>(),
                      manageNetworkCubit: context.read<ManageNetworkCubit>(),
                    ),
                    child: const SelectCryptoAccount(),
                  ),
                ),

                // Add space for the navigation buttons
                const SizedBox(height: 143),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({super.key, required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 143,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: AcceptButton(uri: uri),
          ),
          const Padding(padding: EdgeInsets.all(8), child: RefuseButton()),
        ],
      ),
    );
  }
}

class DisplayEntity extends StatelessWidget {
  const DisplayEntity({
    super.key,
    required this.trustedEntity,
    required this.notTrustedText,
    required this.trustedListEnabled,
    required this.uri,
    required this.client,
  });

  final TrustedEntity? trustedEntity;
  final String notTrustedText;
  final bool trustedListEnabled;
  final Uri uri;
  final DioClient client;

  @override
  Widget build(BuildContext context) {
    if (!trustedListEnabled) {
      final l10n = context.l10n;
      return FutureBuilder<String>(
        future: host,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Column(
              children: [Text(l10n.scanPromptHost), Text(snapshot.data!)],
            );
          }
          return const LinearProgressIndicator();
        },
      );
    }
    if (trustedEntity != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: TrustedEntityDetails(trustedEntity: trustedEntity!),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(notTrustedText),
      );
    }
  }

  Future<String> get host async {
    return getHost(uri: uri, client: client);
  }
}

class RefuseButton extends StatelessWidget {
  const RefuseButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyOutlinedButton(
      text: l10n.communicationHostDeny,
      onPressed: () {
        Navigator.of(context).pop();
        final qrCodeScanCubit = context.read<QRCodeScanCubit>();
        qrCodeScanCubit.emitError(
          error: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_SCAN_REFUSE_HOST,
          ),
        );
      },
    );
  }
}

class AcceptButton extends StatelessWidget {
  const AcceptButton({super.key, required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MyElevatedButton(
      text: l10n.communicationHostAllow,
      onPressed: () async {
        Navigator.of(context).pop();
        final qrCodeScanCubit = context.read<QRCodeScanCubit>();
        await qrCodeScanCubit.startSIOPV2OIDC4VPProcess(uri);
      },
    );
  }
}

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

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.cryptoAccount.data.length,
            itemBuilder: (BuildContext listViewContext, int index) {
              final cryptoAccount = state.cryptoAccount.data[index];
              if (cryptoAccount.blockchainType == BlockchainType.tezos) {
                return const SizedBox.shrink();
              }
              if (!chainIdList.contains(cryptoAccount.blockchainType.chainId)) {
                return const SizedBox.shrink();
              }
              return CryptoAccountItem(
                cryptoAccountData: cryptoAccount,
                isSelected: state.currentCryptoIndex == index,
                listIndex: index,
                onPressed: () async {
                  context.read<ManageAccountsCubit>().setCurrentWalletAccount(
                    index,
                  );
                  // todo(hawkbee): Check the balance of the selected account
                  // for each transaction

                  /// prepare the transactions with the selected account
                  final scanCubit = context.read<ScanCubit>();
                  final transactionData = scanCubit.state.transactionData;

                  final dotenv = DotEnv();
                  final rpcUrl = await fetchRpcUrl(
                    blockchainNetwork: EthereumNetwork.mainNet(),
                    dotEnv: dotenv,
                  );
                  final currentBlockchainAccount = context
                      .read<WalletCubit>()
                      .state
                      .currentAccount!;
                  final List<Uint8List> blockchainSignedTransaction =
                      await Oidc4vpTransaction(
                        transactionData: transactionData!,
                      ).getBlockchainSignedTransaction(
                        cryptoAccountData: currentBlockchainAccount,
                        rpcUrl: rpcUrl,
                      );

                  await scanCubit.addBlockchainSignedTransaction(
                    blockchainSignedTransaction,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class TransactionPresentation extends StatelessWidget {
  const TransactionPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> decodedTransactions = getDecodedTransactions(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: decodedTransactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final tx = decodedTransactions[index];
        final credentialIds = tx['credential_ids'] as List;
        final uiHints = tx['ui_hints'] ?? <String, dynamic>{};
        final title = uiHints['title'] as String? ?? '';
        final subtitle = uiHints['subtitle'] as String? ?? '';
        final purpose = uiHints['purpose'] as String? ?? '';
        final sanitizedCredentialIds = credentialIds
            .map((e) => e.toString())
            .toList();
        return ListTile(
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Credential IDs: ${sanitizedCredentialIds.join(", ")}'),
              Text(title),
              Text(subtitle),
              Text('Purpose: $purpose'),
            ],
          ),
        );
      },
    );
  }
}

List<dynamic> getDecodedTransactions(BuildContext context) {
  final transactionInfo = context.read<ScanCubit>().state.transactionData;
  final List<dynamic> decodedTransactions = Oidc4vpTransaction(
    transactionData: transactionInfo!,
  ).decodeTransactions();
  return decodedTransactions;
}
