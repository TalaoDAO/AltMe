import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'electronic_address.g.dart';

@JsonSerializable()
class ElectronicAddress extends Equatable {
  const ElectronicAddress({
    required this.uri,
    this.lang,
  });

  factory ElectronicAddress.fromJson(Map<String, dynamic> json) =>
      _$ElectronicAddressFromJson(json);

  final String uri;
  final String? lang;
  Map<String, dynamic> toJson() => _$ElectronicAddressToJson(this);

  @override
  List<Object?> get props => [
        uri,
        lang,
      ];
}
