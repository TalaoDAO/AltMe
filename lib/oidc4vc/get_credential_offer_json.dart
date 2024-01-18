import 'dart:convert';

import 'package:altme/app/app.dart';

Future<dynamic> getCredentialOfferJson({
  required String scannedResponse,
  required DioClient dioClient,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  dynamic credentialOfferJson;

  if (keys.contains('credential_offer')) {
    credentialOfferJson = jsonDecode(
      uriFromScannedResponse.queryParameters['credential_offer'].toString(),
    );
  } else if (keys.contains('credential_offer_uri')) {
    final url = uriFromScannedResponse.queryParameters['credential_offer_uri']
        .toString();
    final response = await dioClient.get(url);

    credentialOfferJson = response;
  }

  return credentialOfferJson;
}
