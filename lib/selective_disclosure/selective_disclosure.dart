import 'dart:convert';

import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';

class SelectiveDisclosure {
  SelectiveDisclosure(this.credentialModel);
  final CredentialModel credentialModel;

  Map<String, dynamic> get claims {
    final credentialSupported = credentialModel.credentialSupported;

    final claims = credentialSupported!['claims'];

    if (claims is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    return claims;
  }

  Map<String, dynamic> get extractedValuesFromJwt {
    final encryptedValues = credentialModel.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();
    final extractedValues = <String, dynamic>{};
    if (encryptedValues != null) {
      encryptedValues.removeAt(0);

      for (var element in encryptedValues) {
        try {
          while (element.length % 4 != 0) {
            element += '=';
          }

          final decryptedData = utf8.decode(base64Decode(element));

          if (decryptedData.isNotEmpty) {
            final lisString = jsonDecode(decryptedData);
            if (lisString is List) {
              if (lisString.length == 3) {
                extractedValues[lisString[1].toString()] = lisString[2];
              }
            }
          }
        } catch (e) {
          //
        }
      }
    }
    return extractedValues;
  }
}
