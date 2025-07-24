import 'package:altme/trusted_list/model/electronic_address.dart';
import 'package:altme/trusted_list/model/postal_address.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_entity.g.dart';

enum TrustedEntityType {
  @JsonValue('issuer')
  issuer,
  @JsonValue('verifier')
  verifier,
  @JsonValue('wallet-provider')
  walletProvider,
}

@JsonSerializable(explicitToJson: true)
class TrustedEntity extends Equatable {
  TrustedEntity({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.endpoint,
    this.postalAddress,
    this.electronicAddress,
    this.rootCertificates,
    this.vcTypes,
  }) {
    // rootCertificates: REQUIRED if id is not a DID
    final isDid = id.startsWith('did:');
    if (!isDid && (rootCertificates == null || rootCertificates!.isEmpty)) {
      throw ArgumentError('rootCertificates is required if id is not a DID');
    }
    // vcTypes: REQUIRED for issuers and verifiers
    if ((type == TrustedEntityType.issuer ||
            type == TrustedEntityType.verifier) &&
        (vcTypes == null || vcTypes!.isEmpty)) {
      throw ArgumentError('vcTypes is required for issuers and verifiers');
    }
  }

  factory TrustedEntity.fromJson(Map<String, dynamic> json) =>
      _$TrustedEntityFromJson(json);

  final String id;
  final TrustedEntityType type;
  final String? name;
  final String? description;
  final String? endpoint;
  final PostalAddress? postalAddress;
  final ElectronicAddress? electronicAddress;
  final List<String>? rootCertificates;
  final List<String>? vcTypes;

  Map<String, dynamic> toJson() => _$TrustedEntityToJson(this);

  @override
  List<Object?> get props => [
        id,
        type,
        name,
        description,
        endpoint,
        postalAddress,
        electronicAddress,
        rootCertificates,
        vcTypes,
      ];
}
