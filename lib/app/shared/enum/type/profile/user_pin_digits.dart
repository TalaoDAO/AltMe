import 'package:json_annotation/json_annotation.dart';

enum UserPinDigits {
  @JsonValue('4')
  four,

  @JsonValue('6')
  six,
}
