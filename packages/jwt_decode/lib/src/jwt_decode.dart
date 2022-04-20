import 'dart:convert';

/// {@template jwt_decode}
/// JWT decode package
/// {@endtemplate}
class JWTDecode {
  ///parseJwt
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid Token');
    }

    final payload = _decodeBase64(parts[1]);

    final dynamic payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('Invalid Payload');
    }
    return payloadMap;
  }

  String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
    }

    return utf8.decode(base64Url.decode(output));
  }
}
