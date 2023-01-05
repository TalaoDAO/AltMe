import 'package:altme/dashboard/home/home.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_info_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class DeviceInfoCredential {
  DeviceInfoCredential({
    required this.id,
    required this.issuer,
    required this.issuanceDate,
    required this.credentialSubjectModel,
    this.context = _context,
    this.type = _type,
  });

  factory DeviceInfoCredential.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$DeviceInfoCredentialFromJson(json);

  @JsonKey(name: '@context', defaultValue: _context)
  final List<dynamic> context;
  final String id;
  @JsonKey(defaultValue: _type)
  final List type;
  @JsonKey(name: 'credentialSubject')
  final CredentialSubjectModel credentialSubjectModel;
  final String issuer;
  final String issuanceDate;

  Map<String, dynamic> toJson() => _$DeviceInfoCredentialToJson(this);

  static const List<String> _type = ['VerifiableCredential', 'DeviceInfo'];

  static const List<dynamic> _context = <dynamic>[
    'https://www.w3.org/2018/credentials/v1',
    {
      'DeviceInfo': {
        '@id': 'https://github.com/TalaoDAO/context#deviceinfo',
        '@context': {
          '@version': 1.1,
          '@protected': true,
          'schema': 'https://schema.org/',
          'id': '@id',
          'type': '@type',
          'systemName': 'schema:productName',
          'device': 'schema:productName',
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
