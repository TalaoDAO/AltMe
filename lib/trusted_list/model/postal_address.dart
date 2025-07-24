import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'postal_address.g.dart';

@JsonSerializable()
class PostalAddress extends Equatable {
  const PostalAddress({
    this.streetAddress,
    this.locality,
    this.postalCode,
    this.countryName,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) =>
      _$PostalAddressFromJson(json);

  final String? streetAddress;
  final String? locality;
  final String? postalCode;
  final String? countryName;

  Map<String, dynamic> toJson() => _$PostalAddressToJson(this);

  @override
  List<Object?> get props => [
        streetAddress,
        locality,
        postalCode,
        countryName,
      ];
}
