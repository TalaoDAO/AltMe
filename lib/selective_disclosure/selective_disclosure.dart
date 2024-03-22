import 'dart:convert';

import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

class SelectiveDisclosure {
  SelectiveDisclosure(this.credentialModel);
  final CredentialModel credentialModel;

  Map<String, dynamic> get claims {
    final credentialSupported = credentialModel.credentialSupported;

    var claims = credentialSupported?['claims'];

    if (claims == null || claims is! Map<String, dynamic>) {
      return <String, dynamic>{};
    }

    final order = credentialSupported?['order'];

    if (order != null && order is List<dynamic>) {
      final orderList = order.map((e) => e.toString()).toList();

      final orderedClaims = <String, dynamic>{};
      final remainingClaims = <String, dynamic>{};

      // Order elements based on the order list
      for (final key in orderList) {
        if (claims.containsKey(key)) {
          orderedClaims[key] = claims[key];
        }
      }

      // Add remaining elements to the end of the ordered map
      claims.forEach((key, value) {
        if (!orderedClaims.containsKey(key)) {
          remainingClaims[key] = value;
        }
      });

      orderedClaims.addAll(remainingClaims);

      claims = orderedClaims;
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

  String? get getPicture {
    if (credentialModel.format.toString() != VCFormatType.vcSdJWT.value) {
      return null;
    }

    final credentialSupported = credentialModel.credentialSupported;
    if (credentialSupported == null) return null;

    final claims = credentialSupported['claims'];
    if (claims is! Map<String, dynamic>) return null;

    final picture = claims['picture'];
    if (picture == null) return null;
    if (picture is! Map<String, dynamic>) return null;

    if (picture.containsKey('mandatory')) {
      final mandatory = picture['mandatory'];
      if (mandatory is! bool) return null;
    }

    final valueType = picture['value_type'];
    if (valueType == null) return null;

    if (valueType == 'image/jpeg') {
      final (data, _) = getClaimsData(key: 'picture');
      return data;
    } else {
      return null;
    }
  }

  /// claimsdata, isfromDisclosureOfJWT
  (String?, bool) getClaimsData({
    required String key,
  }) {
    String? data;
    bool isfromDisclosureOfJWT = false;

    final JsonPath dataPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..' + key,
    );

    try {
      final uncryptedDataPath = dataPath.read(extractedValuesFromJwt).first;
      data = uncryptedDataPath.value.toString();
      isfromDisclosureOfJWT = true;
    } catch (e) {
      try {
        final credentialModelPath = dataPath.read(credentialModel.data).first;
        data = credentialModelPath.value.toString();
        isfromDisclosureOfJWT = false;
      } catch (e) {
        data = null;
      }
    }

    return (data, isfromDisclosureOfJWT);
  }
}
