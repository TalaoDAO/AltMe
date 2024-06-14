import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:secp256r1/secp256r1.dart';

/// Sign jwt with keys from TEE/Strongbox or Secure Element
class SecureJwtSigner {
  const SecureJwtSigner();

  Future<String> signJwt({
    required Map<String, dynamic> header,
    required Map<String, dynamic> payload,
    required String privateKey,
  }) async {
    // Base64 url safe encoding of header and payload without padding
    final headerB64 =
        base64Encode(utf8.encode(jsonEncode(header))).replaceAll('=', '');
    final payloadB64 =
        base64Encode(utf8.encode(jsonEncode(payload))).replaceAll('=', '');

    // Calculate the message digest with SHA-256
    final message = '$headerB64.$payloadB64';
    final bytes = utf8.encode(message);
    final digest = sha256.convert(bytes);

    // Sign the message digest with ECDSA key (P-256)
    final signature = await SecureP256.sign(
      privateKey,
      Uint8List.fromList(digest.bytes),
    );

    // Encode signature with base64 url safe and no padding
    final signatureB64 = base64Url.encode(signature).replaceAll('=', '');

    // Return JWT
    return '$headerB64.$payloadB64.$signatureB64';
  }
}
