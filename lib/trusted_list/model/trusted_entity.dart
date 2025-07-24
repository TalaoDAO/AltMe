import 'package:altme/trusted_list/model/electronic_address.dart';
import 'package:altme/trusted_list/model/postal_address.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'trusted_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class TrustedEntity extends Equatable {

  const TrustedEntity({
    required this.id,
    required this.type,
    this.name,
    this.description,
    this.endpoint,
    this.postalAddress,
    this.electronicAddress,
    this.rootCertificates,
    this.vcTypes,
  });

  factory TrustedEntity.fromJson(Map<String, dynamic> json) => _$TrustedEntityFromJson(json);

  final String id;
  final String type;
  final String? name;
  final String? description;
  final String? endpoint;
  final PostalAddress? postalAddress;
  final ElectronicAddress? electronicAddress;
  final List<String>? rootCertificates;
  final List<String>? vcTypes;
 
  Map<String, dynamic> toJson() => _$TrustedEntityToJson(this);

  @override
  List<Object?> get props => [id, type, name, description, endpoint, postalAddress, electronicAddress, rootCertificates, vcTypes];
}
