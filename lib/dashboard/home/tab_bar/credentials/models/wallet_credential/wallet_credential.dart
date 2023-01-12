import 'package:altme/dashboard/home/home.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wallet_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class WalletCredential {
  WalletCredential({
    required this.id,
    required this.issuer,
    required this.issuanceDate,
    required this.credentialSubjectModel,
    this.context = _context,
    this.type = _type,
  });

  factory WalletCredential.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$WalletCredentialFromJson(json);

  @JsonKey(name: '@context', defaultValue: _context)
  final List<dynamic> context;
  final String id;
  @JsonKey(defaultValue: _type)
  final List type;
  @JsonKey(name: 'credentialSubject')
  final CredentialSubjectModel credentialSubjectModel;
  final String issuer;
  final String issuanceDate;

  Map<String, dynamic> toJson() => _$WalletCredentialToJson(this);

  static const List<String> _type = [
    'VerifiableCredential',
    'WalletCredential'
  ];

  static const List<dynamic> _context = <dynamic>[
    'https://www.w3.org/2018/credentials/v1',
    {
      'WalletCredential': {
        '@id': 'https://github.com/TalaoDAO/context#deviceinfo',
        '@context': {
          '@version': 1.1,
          '@protected': true,
          'schema': 'https://schema.org/',
          'id': '@id',
          'type': '@type',
          'systemName': 'schema:productName',
          'deviceName': 'schema:productName',
          'systemVersion': 'schema:productName',
          'walletBuild': 'schema:identifier',
          'issuedBy': {
            '@id': 'schema:issuedBy',
            '@context': {
              '@version': 1.1,
              '@protected': true,
              'name': 'https://schema.org/name'
            }
          }
        }
      }
    }
  ];
}
