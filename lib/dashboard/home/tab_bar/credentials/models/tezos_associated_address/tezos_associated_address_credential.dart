import 'package:altme/dashboard/home/home.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tezos_associated_address_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class TezosAssociatedAddressCredential {
  TezosAssociatedAddressCredential({
    required this.id,
    required this.issuer,
    required this.issuanceDate,
    required this.credentialSubjectModel,
    this.context = _context,
    this.type = _type,
  });

  factory TezosAssociatedAddressCredential.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$TezosAssociatedAddressCredentialFromJson(json);

  @JsonKey(name: '@context', defaultValue: _context)
  final List<dynamic> context;
  final String id;
  @JsonKey(defaultValue: _type)
  final List<String> type;
  @JsonKey(name: 'credentialSubject')
  final CredentialSubjectModel credentialSubjectModel;
  final String issuer;
  final String issuanceDate;

  Map<String, dynamic> toJson() =>
      _$TezosAssociatedAddressCredentialToJson(this);

  static const List<String> _type = [
    'VerifiableCredential',
    'TezosAssociatedAddress',
  ];

  static const List<dynamic> _context = <dynamic>[
    'https://www.w3.org/2018/credentials/v1',
    {
      '@vocab': 'https://schema.org',
      'associatedAddress': 'https://w3id.org/security#blockchainAccountId',
      'TezosAssociatedAddress':
          'https://doc.wallet-provider.io/vc_type/#TezosAssociatedAdress',
    }
  ];
}
