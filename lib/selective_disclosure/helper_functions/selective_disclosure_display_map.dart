import 'dart:convert';

import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/extension/iterable_extension.dart';
import 'package:altme/app/shared/helper_functions/get_display.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/present/pick/selective_disclosure/cubit/selective_disclosure_pick_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

class SelectiveDisclosureDisplayMap {
  const SelectiveDisclosureDisplayMap({
    required this.credentialModel,
    required this.isPresentation,
    required this.languageCode,
    required this.limitDisclosure,
    required this.filters,
    required this.isDeveloperMode,
    required this.displayMode,
    this.claims,
    this.parentKeyId,
    required this.selectedClaimsKeyIds,
    this.onPressed,
  });

  final CredentialModel credentialModel;
  final bool isPresentation;
  final String languageCode;
  final String limitDisclosure;
  final bool isDeveloperMode;
  final Map<String, dynamic>? claims;
  final String? parentKeyId;
  final Map<String, dynamic> filters;
  final List<SelectedClaimsKeyIds> selectedClaimsKeyIds;
  final bool displayMode;
  final void Function(
    String?,
    String,
    String?,
    String?,
  )? onPressed;

  Map<String, dynamic> get buildMap {
    final builtMap = <String, dynamic>{};
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    final currentClaims = claims ?? selectiveDisclosure.claims;
    int index = 0;
    currentClaims.forEach((key, value) {
      index++;
      String? title;

      final mapKey = key;
      final mapValue = value;

      if (mapValue is! Map<String, dynamic>) return;

      final display = getDisplay(mapValue, languageCode);
      if (displayMode && display == null && !isPresentation) return;
      title =
          display?['name'].toString() ?? '${Parameters.doNotDisplayMe}$index';

      /// Getting value_type if defined in the claim
      final type = mapValue['value_type'] as String?;
      final bool hasNestedData =
          mapValue.values.any((element) => element is Map<String, dynamic>);

      if (hasNestedData) {
        final nestedMap = SelectiveDisclosureDisplayMap(
          credentialModel: credentialModel,
          claims: mapValue,
          isPresentation: isPresentation,
          languageCode: languageCode,
          limitDisclosure: limitDisclosure,
          filters: filters,
          parentKeyId: mapKey,
          isDeveloperMode: isDeveloperMode,
          selectedClaimsKeyIds: selectedClaimsKeyIds,
          onPressed: onPressed,
          displayMode: displayMode,
        ).buildMap;
        if (nestedMap.isNotEmpty) {
          final fundation = claimData(mapKey, title, type, parentKeyId);
          if (fundation.isEmpty) {
            builtMap.addAll(
              {title: nestedMap},
            );
          } else {
            final fundationValue = fundation.values.first;
            fundationValue['value'] = nestedMap;
            builtMap.addAll(
              {fundation.keys.first: fundationValue},
            );
          }
        } else {
          builtMap.addAll(
            claimData(mapKey, title, type, parentKeyId),
          );
        }
      } else {
        builtMap.addAll(claimData(mapKey, title, type, parentKeyId));
      }
    });
    final Map<String, dynamic> mapFromJwtEntries = fileterdMapFromJwt(
      selectiveDisclosure,
      currentClaims,
      parentKeyId,
    );
    builtMap.addAll(mapFromJwtEntries);
    return builtMap;
  }

  Map<String, dynamic> fileterdMapFromJwt(
    SelectiveDisclosure selectiveDisclosure,
    Map<String, dynamic> currentClaims,
    String? parentKeyId,
  ) {
    final builtMap = <String, dynamic>{};
    if (!isPresentation && !isDeveloperMode) return builtMap;
    for (final disclosure in selectiveDisclosure.disclosureFromJWT) {
      /// check if disclosure is in a nested value
      /// if so, return empty container
      final content = selectiveDisclosure.disclosureToContent(disclosure);

      final digest = sh256HashOfContent(
        content,
      );
      final disclosuresContent = Map<String, dynamic>.from(
        selectiveDisclosure.disclosureListToContent,
      );

      if (parentKeyId == null) {
        disclosuresContent.removeWhere((key, value) {
          if (value is String) {
            return !value.contains(digest);
          }
          return true;
        });
        if (disclosuresContent.isNotEmpty) continue;

        /// Check if the disclosure is nested in a element from payload
        /// If so, return empty container, else continue building of the widget
        if (isNestedInpayload(selectiveDisclosure.contents, digest)) {
          continue;
        }
      } else {
        /// keep going only if element is in the nested value of the parentKeyId
        /// either in the payload or the claims
        final nestedValue =
            selectiveDisclosure.extractedValuesFromJwtWithSd[parentKeyId] ??
                SelectiveDisclosure(credentialModel).payload[parentKeyId];
        if (nestedValue == null) continue;
        bool displayElement = false;
        if (nestedValue is String) {
          if (nestedValue.contains(digest)) displayElement = true;
        }
        if (nestedValue is Map) {
          final claimList = nestedValue['_sd'];
          if (claimList is List) {
            if (claimList.contains(digest)) displayElement = true;
          }
        }
        if (!displayElement) continue;
      }

      /// Check if the disclosure is already displayed in the claims
      /// from the display. If so, return empty container, else build the widget
      final value = selectiveDisclosure
          .contentOfSh256Hash(
            content,
          )
          .entries
          .first
          .value;

      final element = value.entries.first;
      if (!currentClaims.containsKey(element.key)) {
        if (element.value is Map) {
          builtMap.addAll(MapForNestedClaimWithoutDisplay(element, null));
          continue;
        }

        builtMap.addAll(
          claimData(
            element.key.toString(),
            element.key.toString(),
            null,
            parentKeyId,
          ),
        );
      }
    }
    return builtMap;
  }

  /// can be used in recursive way to get more nested levels
  Map<String, dynamic> MapForNestedClaimWithoutDisplay(
    dynamic element,
    String? title,
  ) {
    final value = element.value as Map<String, dynamic>;
    final valueWithoutSd = Map<String, dynamic>.from(value);
    valueWithoutSd.remove('_sd');
    final builtMap = <String, dynamic>{};
    if (valueWithoutSd.isEmpty) {
      final mapNestedSelectiveDisclosure = SelectiveDisclosureDisplayMap(
        credentialModel: credentialModel,
        claims: const {},
        isPresentation: isPresentation,
        languageCode: languageCode,
        limitDisclosure: limitDisclosure,
        filters: filters,
        parentKeyId: element.key.toString(),
        isDeveloperMode: isDeveloperMode,
        selectedClaimsKeyIds: selectedClaimsKeyIds,
        onPressed: onPressed,
        displayMode: displayMode,
      ).buildMap;
      if (mapNestedSelectiveDisclosure.isNotEmpty) {
        builtMap.addAll({
          element.key.toString(): mapNestedSelectiveDisclosure,
        });
      }
    } else {
      final isCompulsary = limitDisclosure == 'required';

      bool isDisabled = isCompulsary;
      final index = SelectiveDisclosure(credentialModel)
          .disclosureListToContent
          .entries
          .toList()
          .indexWhere(
            (entry) =>
                SelectiveDisclosure(credentialModel)
                    .getMapFromList(
                      jsonDecode(entry.value.toString()) as List,
                    )
                    .keys
                    .first ==
                element.key.toString(),
          );
      if (index == -1 && element.threeDotValue == null) isDisabled = true;
      if (value['_sd'] != null) {
        value.addAll(
          SelectiveDisclosureDisplayMap(
            credentialModel: credentialModel,
            isPresentation: isPresentation,
            languageCode: languageCode,
            limitDisclosure: limitDisclosure,
            filters: filters,
            isDeveloperMode: isDeveloperMode,
            claims: claims,
            parentKeyId: element.key.toString(),
            selectedClaimsKeyIds: selectedClaimsKeyIds,
            onPressed: onPressed,
            displayMode: displayMode,
          ).buildMap,
        );
      }
      // final threeDotValue =
      // (element?.threeDotValue != null) ? element.threeDotValue : null;
      builtMap[title ?? element.key.toString()] = {
        'mapKey': element.key.toString(),
        'claimKey': element.key.toString(),
        'threeDotValue': null,
        'value': value,
        'hasCheckbox': !isDisabled && isPresentation,
        'isCompulsary': isCompulsary,
        'sd': null,
      };
    }

    return builtMap;
  }

  Map<String, dynamic> claimData(
    String mapKey,
    String? title,
    String? type,
    String? parentKeyId,
  ) {
    final claimDataMap = <String, dynamic>{};
    final (claimsData, sd) = SelectiveDisclosure(credentialModel).getClaimsData(
      key: mapKey,
      parentKeyId: parentKeyId,
    );

    if (claimsData.isEmpty) return claimDataMap;
    int index = 0;
    for (final element in claimsData) {
      var claimKey = mapKey;
      final isFirstElement = index == 0;

      if (!isFirstElement) {
        claimKey = '$claimKey-$index';
      }

      final isCompulsary = limitDisclosure == 'required';

      bool isDisabled = isCompulsary;
      final selectedKeyId = selectedClaimsKeyIds
          .firstWhereOrNull((ele) => ele.keyId == '$claimKey#$sd');
      if (isPresentation) {
        if (filters.isNotEmpty) {
          isDisabled = isCompulsary;

          filters.forEach((key, value) {
            if (element.threeDotValue != null) {
              if (claimKey.contains(key) &&
                  element.data.replaceAll(' ', '') == value) {
                if (isCompulsary) isDisabled = false;
                if (selectedKeyId == null) {
                  onPressed?.call(
                    key,
                    claimKey,
                    element.threeDotValue,
                    sd,
                  );
                }
              }
            } else {
              if (claimKey == key && element.data == value) {
                if (isCompulsary) isDisabled = false;
                if (selectedKeyId == null) {
                  onPressed?.call(
                    key,
                    claimKey,
                    null,
                    sd,
                  );
                }
              }
            }
          });
        }
      }
      final indexInDisclosure = SelectiveDisclosure(credentialModel)
          .disclosureListToContent
          .entries
          .toList()
          .indexWhere(
            (entry) =>
                SelectiveDisclosure(credentialModel)
                    .getMapFromList(
                      jsonDecode(entry.value.toString()) as List,
                    )
                    .keys
                    .first ==
                claimKey,
          );
      if ((indexInDisclosure == -1 && element.threeDotValue == null) ||
          (sd == null && parentKeyId != null)) {
        isDisabled = true;
      } else if (isDisabled) {
        // Don't add in the map if limitDisclosure is required and the
        // considered element is:
        // - From the SD
        // - Not targeted by the filters
        continue;
      }
      // ignore: inference_failure_on_uninitialized_variable, prefer_typing_uninitialized_variables
      late final value;
      try {
        final json = jsonDecode(element.data);
        value = json;
      } catch (e) {
        value = element.data;
      }
      final listElement = {
        'mapKey': mapKey,
        'claimKey': claimKey,
        'threeDotValue': element.threeDotValue,
        'value': value,
        'hasCheckbox': !isDisabled && isPresentation,
        'isCompulsary': isCompulsary,
        'type': type,
        'sd': sd,
      };
      if (claimsData.length > 1) {
        if (index == 0) {
          claimDataMap[title ?? mapKey] = {
            'value': [listElement],
          };
        } else {
          claimDataMap[title ?? mapKey]['value'].add(listElement);
        }
      } else {
        claimDataMap[title ?? mapKey] = listElement;
      }
      index++;
    }
    return claimDataMap;
  }

  bool isNestedInpayload(List<String> contents, String digest) {
    final payloadSd = SelectiveDisclosure(credentialModel).payload;
    final JsonPath dataPathSd = JsonPath(
      r'$..["_sd"]',
    );
    final List<dynamic> listSd = [];
    payloadSd.remove('_sd');
    dataPathSd.read(payloadSd).forEach((element) {
      if (element.value is List) {
        listSd.addAll(element.value! as List);
      }
    });
    final payloadThreeDot = SelectiveDisclosure(credentialModel).payload;

    final JsonPath dataPathThreeDot = JsonPath(
      r'$..["..."]',
    );
    final List<dynamic> listThreeDot = [];
    payloadThreeDot.remove('_sd');
    dataPathThreeDot.read(payloadThreeDot).forEach((element) {
      if (element.value is String) {
        listThreeDot.add(element.value);
      }
    });

    return listSd.contains(digest) || listThreeDot.contains(digest);
  }
}
