import 'package:json_annotation/json_annotation.dart';

enum ProofType {
  @JsonValue('ldp_vp')
  ldpVp,
  jwt,
}

extension ProofTypeeX on ProofType {
  String get formattedString {
    switch (this) {
      case ProofType.ldpVp:
        return 'ldp_vc';
      case ProofType.jwt:
        return 'jwt';
    }
  }

  String get value {
    switch (this) {
      case ProofType.ldpVp:
        return 'ldp_vc';
      case ProofType.jwt:
        return 'jwt';
    }
  }
}
