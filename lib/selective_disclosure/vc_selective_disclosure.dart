import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/helper_functions/value_type_if_null.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/selective_disclosure/model/claims_data.dart';
import 'package:json_path/json_path.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';

class VcSelectiveDisclosure {
  VcSelectiveDisclosure(this.credentialModel);
  final CredentialModel credentialModel;

  Map<String, dynamic> get payload {
    final encryptedValues = credentialModel.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();

    final encryptedPayload = encryptedValues!.first;
    return decodePayload(
      jwtDecode: JWTDecode(),
      token: encryptedPayload,
    );
  }

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
    final extractedValues = extractedValuesFromJwtWithSd;
    replaceSdValues(extractedValues);

    return extractedValues;
  }

  Map<String, dynamic> get extractedValuesFromJwtWithSd {
    final extractedValues = <String, dynamic>{};
    for (final element in disclosureListToContent.entries.toList()) {
      try {
        final lisString = jsonDecode(element.value.toString());
        if (lisString is List) {
          extractedValues.addAll(getMapFromList(lisString));
        }
      } catch (e) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_format',
            'error_description':
                'Something went wrong when extracting content from disclosure.',
          },
        );
      }
    }

    return extractedValues;
  }

  List<String> get disclosureFromJWT {
    final encryptedValues = credentialModel.jwt
        ?.split('~')
        .where((element) => element.isNotEmpty)
        .toList();

    if (encryptedValues != null) {
      encryptedValues.removeAt(0);

      return encryptedValues;
    }
    return [];
  }

  Map<String, dynamic> get disclosureListToContent {
    final data = <String, dynamic>{};
    for (final element in disclosureFromJWT) {
      data[element] = disclosureToContent(element);
    }

    return data;
  }

  Map<String, dynamic> get sh256HashToContent {
    final data = <String, dynamic>{};

    for (final element in contents) {
      data.addAll(contentOfSh256Hash(element));
    }
    return data;
  }

  Map<String, dynamic> contentOfSh256Hash(
    String element,
  ) {
    final data = <String, dynamic>{};
    try {
      final sh256Hash = sh256HashOfContent(element);
      final lisString = jsonDecode(element);
      if (lisString is List) {
        if (lisString.length == 3) {
          data[sh256Hash] = {
            lisString[1]: lisString[2],
          };
        } else if (lisString.length == 2) {
          data[sh256Hash] = {
            lisString[0]: lisString[1],
          };
        }
      }
      return data;
    } catch (e) {
      return data;
    }
  }

  List<String> get contents {
    final contents = <String>[];
    for (final element in disclosureListToContent.entries.toList()) {
      contents.add(element.value.toString());
    }
    return contents;
  }

  String? get getPicture {
    if (credentialModel.format.toString() != VCFormatType.vcSdJWT.vcValue ||
        credentialModel.format.toString() != VCFormatType.dcSdJWT.vcValue) {
      return null;
    }

    final credentialSupported = credentialModel.credentialSupported;
    if (credentialSupported == null) return null;

    final claims = credentialSupported['claims'];
    if (claims is! Map<String, dynamic>) return null;

    for (final key in Parameters.pictureOnCardKeyList) {
      final jsonPath = JsonPath(r'$..' + key);
      final matches = jsonPath.read(claims);
      final keyPresent = matches.isNotEmpty;
      if (keyPresent) {
        final value = matches.first.value;
        if (value is Map<String, dynamic>) {
          final (claimsData, _) = getClaimsData(
            key: key,
            parentKeyId: null,
          );
          if (claimsData.isEmpty) return null;
          final valueType =
              value['value_type'] ?? valueTypeIfNull(claimsData[0].data);
          if (Parameters.pictureOnCardValueTypeList.contains(valueType)) {
            return claimsData[0].data;
          }
        }
      }
    }
    return null;
  }

  (List<ClaimsData>, String?) getClaimsData({
    required String key,
    required String? parentKeyId,
  }) {
    dynamic data;
    final value = <ClaimsData>[];
    final JsonPath dataPath = parentKeyId == null
        ? JsonPath(
            r'$..["' + key + '"]',
          )
        : JsonPath(
            r'$..["' + parentKeyId + '"]["' + key + '"]',
          );
    final String? sd = sdForNested(searchedKey: key, parentKeyId: parentKeyId);
    try {
      final uncryptedDataPath = dataPath.read(extractedValuesFromJwt).first;
      data = uncryptedDataPath.value;
      value.add(
        ClaimsData(
          isfromDisclosureOfJWT: true,
          data: data is Map ? jsonEncode(data) : data.toString(),
        ),
      );
    } catch (e) {
      try {
        final credentialModelPath = dataPath.read(credentialModel.data).first;
        data = credentialModelPath.value;
        value.add(
          ClaimsData(
            isfromDisclosureOfJWT: false,
            data: data is Map ? jsonEncode(data) : data.toString(),
          ),
        );
      } catch (e) {
        if (parentKeyId != null) {
          final JsonPath fallbackDataPath = JsonPath(
            r'$..["' + key + '"]',
          );
          try {
            final uncryptedDataPath =
                fallbackDataPath.read(extractedValuesFromJwt).first;
            data = uncryptedDataPath.value;
            value.add(
              ClaimsData(
                isfromDisclosureOfJWT: true,
                data: data is Map ? jsonEncode(data) : data.toString(),
              ),
            );
          } catch (e) {
            try {
              final credentialModelPath =
                  fallbackDataPath.read(credentialModel.data).first;
              data = credentialModelPath.value;
              value.add(
                ClaimsData(
                  isfromDisclosureOfJWT: false,
                  data: data is Map ? jsonEncode(data) : data.toString(),
                ),
              );
            } catch (e) {
              data = null;
            }
          }
        }
      }
    }
    try {
      if (data != null && data is List<dynamic>) {
        value.clear();
        for (final ele in data) {
          if (ele is String) {
            value.add(
              ClaimsData(
                isfromDisclosureOfJWT: false,
                data: ele,
              ),
            );
          } else if (ele is Map) {
            final threeDotValue = ele['...'];
            if (threeDotValue != null) {
              for (final element in contents) {
                final sh256Hash = sh256HashOfContent(element);
                if (sh256Hash == threeDotValue) {
                  if (element.startsWith('[') && element.endsWith(']')) {
                    final trimmedElement =
                        element.substring(1, element.length - 1).split(',');
                    value.add(
                      ClaimsData(
                        isfromDisclosureOfJWT: true,
                        data: trimmedElement.last.replaceAll('"', ''),
                        threeDotValue: getDisclosure(element),
                      ),
                    );
                  }
                }
              }
            }
          }
        }
        return (value, sd);
      }
    } catch (e) {
      return (value, sd);
    }
    return (value, sd);
  }

  String disclosureToContent(String element) {
    String encryptedData = element;
    try {
      while (encryptedData.length % 4 != 0) {
        encryptedData += '=';
      }
      final decryptedData = utf8.decode(base64Decode(encryptedData));
      return decryptedData;
    } catch (e) {
      return '';
    }
  }

  Map<String, dynamic> replaceSdValues(Map<String, dynamic> extractedValues) {
    final newExtractedValue = Map<String, dynamic>.from(extractedValues);
    extractedValues.forEach((key, value) {
      if (value is Map) {
        if (value['_sd'] != null && value['_sd'] is List) {
          final sdList = value['_sd'] as List;
          for (final sdElement in sdList) {
            for (final element in disclosureListToContent.entries.toList()) {
              final digest = sh256HashOfContent(element.value.toString());
              if (digest == sdElement) {
                final toto = getMapFromList(
                  jsonDecode(element.value.toString()) as List,
                ).entries.first;
                if (toto.value is Map<String, dynamic> &&
                    toto.value['_sd'] != null) {
                  newExtractedValue[key] = replaceSdValues(
                    toto.value as Map<String, dynamic>,
                  );
                } else {
                  if (toto.value is List || toto.value is Map) {
                    newExtractedValue[key][toto.key] = replaceSdValues(
                      toto.value as Map<String, dynamic>,
                    );
                  } else {
                    newExtractedValue[key][toto.key] = toto.value;
                  }
                }
              }
            }
          }
        }
      }
    });
    return newExtractedValue;
  }

  Map<String, dynamic> getMapFromList(List<dynamic> lisString) {
    if (lisString.length == 3) {
      return {lisString[1].toString(): lisString[2]};
    } else if (lisString.length == 2) {
      return {lisString[0].toString(): lisString[1]};
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_format',
          'error_description':
              'The disclosure content should contain 2 or 3 elements.',
        },
      );
    }
  }

  String? sdForNested({required String searchedKey, String? parentKeyId}) {
    if (parentKeyId == null) {
      return null;
    }
    String? sd;
    extractedValuesFromJwtWithSd.forEach((String key, dynamic value) {
      final sdCandidate = gestSdFromDigestList(
        key,
        parentKeyId,
        value,
        searchedKey,
      );
      if (sdCandidate != null) {
        sd = sdCandidate;
      }
    });
    payload.forEach((String key, dynamic value) {
      final sdCandidate = gestSdFromDigestList(
        key,
        parentKeyId,
        value,
        searchedKey,
      );
      if (sdCandidate != null) {
        sd = sdCandidate;
      }
    });
    return sd;
  }

  String? gestSdFromDigestList(
    String key,
    String parentKeyId,
    dynamic value,
    String searchedKey,
  ) {
    String? sd;
    if (key == parentKeyId) {
      if (value is Map<String, dynamic>) {
        if (value[searchedKey] != null) {
          return null;
        }
        if (value['_sd'] != null) {
          final digestList = value['_sd'] as List;
          for (final digest in digestList) {
            for (final element in disclosureListToContent.entries.toList()) {
              final digestFromSd = sh256HashOfContent(element.value.toString());
              if (digestFromSd == digest) {
                final keyFromSd = getMapFromList(
                  jsonDecode(element.value.toString()) as List,
                ).keys.first;
                if (keyFromSd == searchedKey) {
                  sd = element.key;
                }
              }
            }
          }
        }
      }
      return sd;
    }
    return null;
  }
}
