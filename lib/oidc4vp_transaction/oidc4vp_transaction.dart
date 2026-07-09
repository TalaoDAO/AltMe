import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/app/shared/models/blockchain_network/blockchain_network_helpers.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/detail/helper_functions/verify_credential.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jose_plus/jose.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

/// Represents a list of blockchain transactions encoded as base64 strings.
class Oidc4vpTransaction {
  Oidc4vpTransaction({required this.transactionData});

  /// List of base64-encoded transaction data strings.
  final List<dynamic> transactionData;

  Future<List<Uint8List>> getBlockchainSignedTransaction({
    required CryptoAccountData cryptoAccountData,
  }) async {
    // Decode all transactions
    final decodedTransactions = decodeTransactions();
    final List<Uint8List> signedTransactions = [];
    final dotenv = DotEnv();

    for (final tx in decodedTransactions) {
      // Map tx to TokenModel and extract required fields
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

  static bool isLocalSignatureRequest(Map<String, dynamic> transaction) {
    return transaction['type'] == 'urn:wallet:local:signature';
  }

  List<Map<String, dynamic>> decodeLocalSignatureRequests() {
    return decodeTransactions()
        .whereType<Map<String, dynamic>>()
        .where(isLocalSignatureRequest)
        .toList();
  }

  LocalSignRequest? getFirstLocalSignatureRequest() {
    final localRequests = decodeLocalSignatureRequests();
    if (localRequests.isEmpty) {
      return null;
    }
    return LocalSignRequest.fromJson(localRequests.first);
  }

  static String createDetachedDocumentSignature({
    required String documentDigest,
    required Map<String, dynamic> privateKey,
    String? keyId,
    String alg = 'ES256',
  }) {
    final key = JsonWebKey.fromJson(privateKey);
    final builder = JsonWebSignatureBuilder()
      ..stringContent = documentDigest
      ..setProtectedHeader('alg', alg);

    if (keyId != null && keyId.isNotEmpty) {
      builder.setProtectedHeader('kid', keyId);
    }

    builder.addRecipient(key, algorithm: alg);
    final jws = builder.build();
    final compact = jws.toCompactSerialization();
    final parts = compact.split('.');
    if (parts.length != 3) {
      throw StateError('Unable to create detached JWS signature.');
    }
    return '${parts[0]}..${parts[2]}';
  }
}

class LocalSignRequest {
  LocalSignRequest({
    required this.type,
    required this.credentialIds,
    required this.signatureRequests,
  });

  final String type;
  final List<String> credentialIds;
  final List<SignatureRequest> signatureRequests;

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

  final String label;
  final Map<String, dynamic> access;
  final String href;
  final String documentDigest;
  final String signatureFormat;
  final String signAlgo;
  final String? documentInfo;

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
}
