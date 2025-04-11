import 'package:altme/app/shared/dio_client/dio_client.dart';

/// Gets a nonce from the wallet provider
///
/// This method makes a GET request to the `/nonce` endpoint of the provided URL
/// and returns the nonce as a string.
Future<String> getNonce({
  required String url,
  required DioClient client,
}) async {
  final dynamic getResponse = await client.get('$url/nonce');
  final nonce = getResponse['nonce'].toString();
  return nonce;
}
