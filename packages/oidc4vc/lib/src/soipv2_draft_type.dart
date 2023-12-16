import 'package:json_annotation/json_annotation.dart';

enum SIOPV2DraftType {
  @JsonValue('12')
  draft12,
}

extension SIOPV2DraftTypeX on SIOPV2DraftType {
  String get formattedString {
    switch (this) {
      case SIOPV2DraftType.draft12:
        return 'Draft 12';
    }
  }
}
