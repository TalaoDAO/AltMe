// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'binance_associated_address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BinanceAssociatedAddressModel _$BinanceAssociatedAddressModelFromJson(
        Map<String, dynamic> json) =>
    BinanceAssociatedAddressModel(
      associatedAddress: json['associatedAddress'] as String? ?? '',
      id: json['id'] as String,
      type: json['type'] as String,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$BinanceAssociatedAddressModelToJson(
    BinanceAssociatedAddressModel instance) {
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
