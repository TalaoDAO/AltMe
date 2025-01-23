import 'dart:convert';

import 'package:altme/app/app.dart';

Future<Map<String, dynamic>> getCredentialOffer({
  required String scannedResponse,
  required DioClient dioClient,
}) async {
  final Uri uriFromScannedResponse = Uri.parse(scannedResponse);

  final keys = <String>[];
  uriFromScannedResponse.queryParameters.forEach((key, value) => keys.add(key));

  late Map<String, dynamic> credentialOffer;

  if (keys.contains('credential_offer')) {
    final credentialOfferJson = jsonDecode(
      uriFromScannedResponse.queryParameters['credential_offer'].toString(),
    );
    if (credentialOfferJson is Map<String, dynamic>) {
      credentialOffer = credentialOfferJson;
    } else {
      throw Exception('Credential Offer is not a Map<String, dynamic>');
    }
  } else if (keys.contains('credential_offer_uri')) {
    final url = uriFromScannedResponse.queryParameters['credential_offer_uri']
        .toString();
    final response = await dioClient.get(url);

    if (response is Map<String, dynamic>) {
      credentialOffer = response;
    } else {
      throw Exception(
        "Credential Offer uri doesn't return a Map<String, dynamic>",
      );
    }
  }

  return credentialOffer;
}
