import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:ebsi/ebsi.dart';
import 'package:secure_storage/secure_storage.dart';

Future<List<CredentialModel>> verifyCredentialsToBePresented({
  required List<CredentialModel> credentialsToBePresented,
  required Ebsi ebsi,
}) async {
  final String p256PrivateKey = await getRandomP256PrivateKey(getSecureStorage);

  for (int i = 0; i < credentialsToBePresented.length; i++) {
    if (credentialsToBePresented[i].jwt == null) {
      final TokenParameters tokenParameters = TokenParameters(
        jsonDecode(p256PrivateKey) as Map<String, dynamic>,
      );

      final Map<String, Object> credentialDatatMap = credentialsToBePresented[i]
          .data
          .map((key, value) => MapEntry(key, value as Object));

      final jwt = ebsi.generateToken(credentialDatatMap, tokenParameters);

      final newCredentialModel = CredentialModel(
        id: credentialsToBePresented[i].id,
        image: credentialsToBePresented[i].image,
        data: credentialsToBePresented[i].data,
        shareLink: credentialsToBePresented[i].shareLink,
        display: credentialsToBePresented[i].display,
        credentialPreview: credentialsToBePresented[i].credentialPreview,
        expirationDate: credentialsToBePresented[i].expirationDate,
        credentialManifest: credentialsToBePresented[i].credentialManifest,
        receivedId: credentialsToBePresented[i].receivedId,
        challenge: credentialsToBePresented[i].challenge,
        domain: credentialsToBePresented[i].domain,
        activities: credentialsToBePresented[i].activities,
        jwt: jwt,
      );

      credentialsToBePresented[i] = newCredentialModel;
    }
  }
  return credentialsToBePresented;
}
