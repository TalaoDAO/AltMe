import 'dart:convert';

import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:jwt_decode/jwt_decode.dart';

Future<String> getProfileFromProvider({
  required String email,
  required String password,
  required String jwtVc,
  required String url,
  required DioClient client,
}) async {
  final encodedData = utf8.encode('$email:$password');
  final base64Encoded = base64UrlEncode(encodedData).replaceAll('=', '');

  final headers = <String, dynamic>{
    'Content-Type': 'application/x-www-form-urlencoded',
    'Authorization': 'Basic $base64Encoded',
  };

  final data = <String, dynamic>{
    'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    'assertion': jwtVc,
  };

  final response = await client.post(
    '$url/configuration',
    headers: headers,
    data: data,
  );
  final jwtDecode = JWTDecode();
  final profileSettingJson = jsonEncode(jwtDecode.parseJwt(response as String));
  return profileSettingJson;
}
