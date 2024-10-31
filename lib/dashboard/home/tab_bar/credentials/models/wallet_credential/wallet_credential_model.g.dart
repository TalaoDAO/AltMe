// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletCredentialModel _$WalletCredentialModelFromJson(
        Map<String, dynamic> json) =>
    WalletCredentialModel(
      publicKey: json['publicKey'] as String? ?? '',
      walletInstanceKey: json['walletInstanceKey'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$WalletCredentialModelToJson(
    WalletCredentialModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['publicKey'] = instance.publicKey;
  val['walletInstanceKey'] = instance.walletInstanceKey;
  return val;
}