import 'package:altme/dashboard/home/home.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ethereum_associated_address_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class EthereumAssociatedAddressCredential {
  EthereumAssociatedAddressCredential({
    required this.id,
    required this.issuer,
    required this.issuanceDate,
    required this.credentialSubjectModel,
    this.context = _context,
    this.type = _type,
  });

  factory EthereumAssociatedAddressCredential.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$EthereumAssociatedAddressCredentialFromJson(json);

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
      _$EthereumAssociatedAddressCredentialToJson(this);

  static const List<String> _type = [
    'VerifiableCredential',
    'EthereumAssociatedAddress'
  ];

  static const List<dynamic> _context = <dynamic>[
    'https://www.w3.org/2018/credentials/v1',
    {
      'EthereumAssociatedAddress': {
        '@id': 'https://github.com/TalaoDAO/context#ethereumassociatedaddress',
        '@context': {
          '@version': 1.1,
          '@protected': true,
          'id': '@id',
          'type': '@type',
          'schema': 'https://schema.org/',
          'accountName': 'schema:identifier',
          'associatedAddress':
              'https://github.com/TalaoDAO/context#associatedaddress',
          'cryptoWalletSignature': 'schema:identifier',
          'cryptoWalletPayload': 'schema:identifier',
          'issuedBy': {
            '@id': 'schema:issuedBy',
            '@context': {
              '@version': 1.1,
              '@protected': true,
              'schema': 'https://schema.org/',
              'name': 'schema:legalName',
              'logo': {'@id': 'schema:logo', '@type': '@id'}
            }
          }
        }
      }
    }
  ];
}
