// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tezotopia_voucher_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TezotopiaVoucherModel _$TezotopiaVoucherModelFromJson(
        Map<String, dynamic> json) =>
    TezotopiaVoucherModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
      offers: json['offers'] == null
          ? null
          : Offers.fromJson(json['offers'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TezotopiaVoucherModelToJson(
    TezotopiaVoucherModel instance) {
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
  val['offers'] = instance.offers?.toJson();
  val['identifier'] = instance.identifier;
  return val;
}
