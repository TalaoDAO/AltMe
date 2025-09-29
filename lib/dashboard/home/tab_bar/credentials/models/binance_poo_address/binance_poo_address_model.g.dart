// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binance_poo_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinancePooAddressModel _$BinancePooAddressModelFromJson(
  Map<String, dynamic> json,
) => BinancePooAddressModel(
  associatedAddress: json['associatedAddress'] as String? ?? '',
  id: json['id'] as String?,
  type: json['type'],
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
);

Map<String, dynamic> _$BinancePooAddressModelToJson(
  BinancePooAddressModel instance,
) {
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
  val['associatedAddress'] = instance.associatedAddress;
  return val;
}
