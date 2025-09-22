import 'dart:convert';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/dashboard/home/tab_bar/tokens/token_page/models/token_model.dart';

/// Represents a list of blockchain transactions encoded as base64 strings.
class Oidc4vpTransaction {
  Oidc4vpTransaction({required this.transactionData});

  /// List of base64-encoded transaction data strings.
  final List<dynamic> transactionData;

  Future<void> sendToken({
    required String CryptoAccountSecretKey,
    required String rpcUrl,
  }) async {
    // Decode all transactions
    final decodedTransactions = decodeTransactions();

    for (final tx in decodedTransactions) {
      // Map tx to TokenModel and extract required fields
      final token = TokenModel(
        contractAddress: tx['asset']['address']?.toString() ?? '',
        name: tx['asset']['symbol']?.toString() ?? '',
        symbol: tx['asset']['symbol']?.toString() ?? '',
        balance: '0',
        decimals: tx['asset']['decimals']?.toString() ?? '',
        standard: 'erc20',
      );
      final withdrawalAddress = tx['recipient']?.toString() ?? '';
      final amountInWei = double.tryParse(tx['amount']?.toString() ?? '0') ?? 0;
      final chainId = int.tryParse(tx['chain_id']?.toString() ?? '1') ?? 1;

      await MWeb3Client.sendToken(
        selectedAccountSecretKey: CryptoAccountSecretKey,
        rpcUrl: rpcUrl,
        token: token,
        withdrawalAddress: withdrawalAddress,
        amountInWei: amountInWei,
        chainId: chainId,
      );
    }
    return;
  }

  /// Decodes the base64 transaction data back to a list of Maps.
  List<dynamic> decodeTransactions() {
    final List<dynamic> decodedTransactions = [];
    for (final tx in transactionData) {
      if (tx is String) {
        final decodedString = utf8.decode(decodeEncodedList(tx));
        final decodedMap = json.decode(decodedString) as Map<String, dynamic>;
        decodedTransactions.add(decodedMap);
      }
    }
    return decodedTransactions;
  }
}
