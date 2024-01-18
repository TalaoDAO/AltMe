import 'package:json_annotation/json_annotation.dart';

enum UserPinDigits {
  @JsonValue('4')
  four,

  @JsonValue('6')
  six,
}

extension UserPinDigitsX on UserPinDigits {
  int get value {
    switch (this) {
      case UserPinDigits.four:
        return 4;
      case UserPinDigits.six:
        return 6;
    }
  }
}
