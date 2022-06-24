import 'package:altme/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'associated_wallet_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class AssociatedWalletCredential {
  AssociatedWalletCredential({
    required this.id,
    required this.issuer,
    required this.credentialSubjectModel,
    this.context = _context,
    this.type = _type,
  });

  factory AssociatedWalletCredential.fromJson(Map<String, dynamic> json) =>
      _$AssociatedWalletCredentialFromJson(json);

  @JsonKey(name: '@context', defaultValue: _context)
  final List<dynamic> context;
  final String id;
  @JsonKey(defaultValue: _type)
  final List type;
  @JsonKey(name: 'credentialSubject')
  final CredentialSubjectModel credentialSubjectModel;
  final String issuer;

  Map<String, dynamic> toJson() => _$AssociatedWalletCredentialToJson(this);

  static const List<String> _type = [
    'VerifiableCredential',
    'TezosAssociatedAddress'
  ];

  static const List<dynamic> _context = <dynamic>[
    'https://www.w3.org/2018/credentials/v1',
    {
      'accountName': 'https://schema.org/identifier',
      'associatedAddress': 'https://schema.org/account'
    }
  ];
}
