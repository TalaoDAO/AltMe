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
    final extractedValues = <String, dynamic>{};
    for (final element in decryptedDatas) {
      try {
        final lisString = jsonDecode(element);
        if (lisString is List) {
          if (lisString.length == 3) {
            extractedValues[lisString[1].toString()] = lisString[2];
          }
        }
      } catch (e) {
        //
      }
    }
    return extractedValues;
  }

  List<String> get decryptedDatas {
    final encryptedValues = credentialModel.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();

    final decryptedDatas = <String>[];
    if (encryptedValues != null) {
      encryptedValues.removeAt(0);

      for (var element in encryptedValues) {
        try {
          while (element.length % 4 != 0) {
            element += '=';
          }

          final decryptedData = utf8.decode(base64Decode(element));

          if (decryptedData.isNotEmpty) {
            decryptedDatas.add(decryptedData);
          }
        } catch (e) {
          //
        }
      }
    }
    return decryptedDatas;
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
    dynamic data;
    bool isfromDisclosureOfJWT = false;

    final JsonPath dataPath = JsonPath(
      // ignore: prefer_interpolation_to_compose_strings
      r'$..' + key,
    );

    try {
      final uncryptedDataPath = dataPath.read(extractedValuesFromJwt).first;
      data = uncryptedDataPath.value;
      isfromDisclosureOfJWT = true;
    } catch (e) {
      try {
        final credentialModelPath = dataPath.read(credentialModel.data).first;
        data = credentialModelPath.value;
        isfromDisclosureOfJWT = false;
      } catch (e) {
        data = null;
      }
    }

    try {
      if (data != null && data is List<dynamic>) {
        final value = <dynamic>[];
        for (final ele in data) {
          if (ele is String) {
            value.add(ele);
          } else if (ele is Map) {
            final threeDotValue = ele['...'];

            if (threeDotValue != null) {
              for (final element in decryptedDatas) {
                final oidc4vc = OIDC4VC();
                final sh256Hash = oidc4vc.sh256HashOfContent(element);

                if (sh256Hash == threeDotValue) {
                  if (element.startsWith('[') && element.endsWith(']')) {
                    final trimmedElement =
                        element.substring(1, element.length - 1).split(',');
                    value.add(trimmedElement.last.replaceAll('"', ''));
                  }
                }
              }
            }
          }
        }

        data = value;
      }
      // ignore: empty_catches
    } catch (e) {}

    return (data?.toString(), isfromDisclosureOfJWT);
  }
}
