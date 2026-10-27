import 'dart:convert';
import 'dart:typed_data';

import 'package:altme/oidc4vc/helper_function/verify_encoded_data.dart';
import 'package:flutter_test/flutter_test.dart';

/// A self-signed P-256 certificate (CN=Test mdoc issuer), made with openssl.
const _certificate =
    'MIIBMTCB2QIUaRp0FLxaEGRFCtE928t6nQl6PmowCgYIKoZIzj0EAwIwGzEZMBcGA1UEAwwQ'
    'VGVzdCBtZG9jIGlzc3VlcjAgFw0yNjEwMTIxMjM3NTlaGA8yMTI2MDkxODEyMzc1OVowGzEZ'
    'MBcGA1UEAwwQVGVzdCBtZG9jIGlzc3VlcjBZMBMGByqGSM49AgEGCCqGSM49AwEHA0IABDr2'
    'JAN3O0EzPeQWFSVbxxybd77BtHCyvnsCx4tfpKbBoUd3WQspbkNkT8VO51CkbhuI+5gXwgMN'
    'DRqGG2antAswCgYIKoZIzj0EAwIDRwAwRAIgdXRYx0eZjYsQUxoiZOwmLsPum+nu5cjKcFdf'
    '0O1Q/hsCIANhiexopPgG8eXLBWfrs8/xB29jPyzjAscrnCp+OXjI';

String _b64(String hex) => base64Url
    .encode(
      Uint8List.fromList([
        for (var i = 0; i < hex.length; i += 2)
          int.parse(hex.substring(i, i + 2), radix: 16),
      ]),
    )
    .replaceAll('=', '');

void main() {
  test('leafCertificateJwk gives the P-256 key of the certificate', () {
    expect(leafCertificateJwk(_certificate), {
      'kty': 'EC',
      'crv': 'P-256',
      'x': _b64(
        '3af62403773b41333de41615255bc71c9b77bec1b470b2be7b02c78b5fa4a6c1',
      ),
      'y': _b64(
        'a14777590b296e43644fc54ee750a46e1b88fb9817c2030d0d1a861b66a7b40b',
      ),
    });
  });
}
