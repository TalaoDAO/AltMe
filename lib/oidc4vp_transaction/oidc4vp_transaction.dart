import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/app/shared/models/blockchain_network/blockchain_network_helpers.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

/// Represents an OIDC4VP transaction payload and dispatches to the proper
/// processing path depending on whether the request is a blockchain
/// transaction or a local document signature request.
abstract class Oidc4vpTransaction {
  factory Oidc4vpTransaction({required List<dynamic> transactionData}) {
    final bool containsLocalSignatureRequest = _decodeTransactions(
      transactionData,
    ).whereType<Map<String, dynamic>>().any(_isLocalSignatureRequest);

    if (containsLocalSignatureRequest) {
      return LocalSignatureOidc4vpTransaction._internal(transactionData);
    }

    return BlockchainOidc4vpTransaction._internal(transactionData);
  }

  Oidc4vpTransaction._internal(this.transactionData);

  /// List of base64-encoded transaction data strings.
  final List<dynamic> transactionData;

  static bool _isLocalSignatureRequest(Map<String, dynamic> transaction) {
    return transaction['type'] == 'urn:wallet:local:signature';
  }

  static List<dynamic> _decodeTransactions(List<dynamic> transactionData) {
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

  List<dynamic> decodeTransactions() => _decodeTransactions(transactionData);

  bool get isLocalSignatureTransaction;

  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  });
}

class BlockchainOidc4vpTransaction extends Oidc4vpTransaction {
  BlockchainOidc4vpTransaction._internal(List<dynamic> transactionData)
    : super._internal(transactionData);

  @override
  bool get isLocalSignatureTransaction => false;

  @override
  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    final decodedTransactions = decodeTransactions();
    final List<Uint8List> signedTransactions = [];
    final dotenv = DotEnv();

    for (final tx in decodedTransactions) {
      final chainId = int.tryParse(tx['chain_id']?.toString() ?? '1') ?? 1;
      final rpcUrl = await fetchRpcUrl(
        blockchainNetwork: blockchainNetworkFromChainId(chainId)!,
        dotEnv: dotenv,
      );
      final params = tx['rpc']['params'] as List<dynamic>;

      for (var i = 0; i < params.length; i++) {
        final param = params[i];
        final amount = param['value']?.toString() ?? '';
        final data = param['data']?.toString() ?? '';
        final receiver = param['to']?.toString() ?? '';
        final transaction = Transaction(
          from: EthereumAddress.fromHex(cryptoAccountData.walletAddress),
          to: EthereumAddress.fromHex(receiver),
          value: EtherAmount.inWei(BigInt.parse(amount)),
          data: data.isNotEmpty ? hexToBytes(data) : null,
        );

        signedTransactions.add(
          await MWeb3Client.getEvmTransactionSignature(
            privateKey: cryptoAccountData.secretKey,
            web3RpcURL: rpcUrl,
            sender: transaction.from!,
            receiver: transaction.to!,
            amount: transaction.value!,
            chainId: chainId,
            data: data,
          ),
        );
      }
    }
    return signedTransactions;
  }
}

class LocalSignatureOidc4vpTransaction extends Oidc4vpTransaction {
  LocalSignatureOidc4vpTransaction._internal(List<dynamic> transactionData)
    : super._internal(transactionData);

  @override
  bool get isLocalSignatureTransaction => true;

  @override
  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    throw UnsupportedError(
      'Blockchain transaction signing is not supported for local '
      'signature requests.',
    );
  }

  List<Map<String, dynamic>> decodeLocalSignatureRequests() {
    return decodeTransactions()
        .whereType<Map<String, dynamic>>()
        .where(Oidc4vpTransaction._isLocalSignatureRequest)
        .toList();
  }

  LocalSignRequest? getFirstLocalSignatureRequest() {
    final localRequests = decodeLocalSignatureRequests();
    if (localRequests.isEmpty) {
      return null;
    }
    return LocalSignRequest.fromJson(localRequests.first);
  }
}

class LocalSignRequest {
  LocalSignRequest({
    required this.type,
    required this.credentialIds,
    required this.signatureRequests,
  });

  factory LocalSignRequest.fromJson(Map<String, dynamic> json) {
    final rawRequests = json['signatureRequests'] as List<dynamic>?;
    return LocalSignRequest(
      type: json['type']?.toString() ?? '',
      credentialIds:
          (json['credential_ids'] as List<dynamic>?)
              ?.map((item) => item.toString())
              .toList() ??
          [],
      signatureRequests:
          rawRequests
              ?.map(
                (item) =>
                    SignatureRequest.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  final String type;
  final List<String> credentialIds;
  final List<SignatureRequest> signatureRequests;
}

class SignatureRequest {
  SignatureRequest({
    required this.label,
    required this.access,
    required this.href,
    required this.documentDigest,
    required this.signatureFormat,
    required this.signAlgo,
    required this.documentInfo,
  });

  factory SignatureRequest.fromJson(Map<String, dynamic> json) {
    return SignatureRequest(
      label: json['label']?.toString() ?? '',
      access: Map<String, dynamic>.from(json['access'] as Map? ?? {}),
      href: json['href']?.toString() ?? '',
      documentDigest: json['documentDigest']?.toString() ?? '',
      signatureFormat: json['signature_format']?.toString() ?? '',
      signAlgo: json['signAlgo']?.toString() ?? '',
      documentInfo: json['documentInfo']?.toString(),
    );
  }

  final String label;
  final Map<String, dynamic> access;
  final String href;
  final String documentDigest;
  final String signatureFormat;
  final String signAlgo;
  final String? documentInfo;
}
