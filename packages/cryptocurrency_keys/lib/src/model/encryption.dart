import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'encryption.g.dart';

///Encryption
@JsonSerializable()
class Encryption extends Equatable {
  ///Encryption
  const Encryption({
    this.cipherText,
    this.authenticationTag,
  });

  ///fromJson
  factory Encryption.fromJson(Map<String, dynamic> json) =>
      _$EncryptionFromJson(json);

  ///cipherText
  final String? cipherText;

  ///authenticationTag
  final String? authenticationTag;

  ///toJson
  Map<String, dynamic> toJson() => _$EncryptionToJson(this);

  @override
  List<Object?> get props => [cipherText, authenticationTag];
}
