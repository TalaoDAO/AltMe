import 'dart:convert';

/// {@template jwt_decode}
/// JWT decode package
/// {@endtemplate}
class JWTDecode {
  ///parseJwt
  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('INVALID_TOKEN');
    }

    final payload = _decodeBase64(parts[1]);

    final dynamic payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('INVALID_PAYLOAD');
    }
    return payloadMap;
  }

  ///parseJwt to get header
  Map<String, dynamic> parseJwtHeader(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('INVALID_TOKEN');
    }

    final header = _decodeBase64(parts[0]);

    final dynamic headerMap = json.decode(header);
    if (headerMap is! Map<String, dynamic>) {
      throw Exception('INVALID_PAYLOAD');
    }
    return headerMap;
  }

  ///parse polygonId Jwt to get header
  Map<String, dynamic> parsePolygonIdJwtHeader(String token) {
    final header = _decodeBase64(token);

    final dynamic headerMap = json.decode(header);
    if (headerMap is! Map<String, dynamic>) {
      throw Exception('INVALID_PAYLOAD');
    }
    return headerMap;
  }

  String _decodeBase64(String str) {
    var output = str.replaceAll('-', '+').replaceAll('_', '/');
    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';

      case 3:
        output += '=';
    }

    return utf8.decode(base64Url.decode(output));
  }
}
