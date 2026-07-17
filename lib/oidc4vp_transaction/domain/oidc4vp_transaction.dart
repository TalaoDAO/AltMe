import 'dart:typed_data';

import 'package:altme/app/shared/m_web3_client/m_web3_client.dart';
import 'package:altme/app/shared/models/blockchain_network/blockchain_network_helpers.dart';
import 'package:altme/wallet/model/crypto_account_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

part 'payment_transaction/payment_transaction.dart';
part 'signature_transaction/signature_transaction.dart';

enum TransactionType { cryptoPayment, textSignature }

/// each type of transaction we get from transaction_data has an extension
/// of  Oidc4vpTransaction
sealed class Oidc4vpTransaction {
  Oidc4vpTransaction({required this.transactionJson});

  final Map<String,dynamic> transactionJson;
  TransactionType get transactionType;
  Future<void> accept();
  Future<void> refuse();
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
