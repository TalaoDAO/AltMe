import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encryption.g.dart';

@JsonSerializable()
class Encryption extends Equatable {
  Encryption({
    this.cipherText,
    this.authenticationTag,
  });

  final String? cipherText;
  final String? authenticationTag;

  factory Encryption.fromJson(Map<String, dynamic> json) =>
      _$EncryptionFromJson(json);

  Map<String, dynamic> toJson() => _$EncryptionToJson(this);

  @override
  List<Object?> get props => [cipherText, authenticationTag];
}
