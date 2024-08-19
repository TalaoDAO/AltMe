import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_path/json_path.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DisplaySelectiveDisclosure extends StatelessWidget {
  const DisplaySelectiveDisclosure({
    super.key,
    required this.credentialModel,
    required this.showVertically,
    this.claims,
    this.onPressed,
    this.selectiveDisclosureState,
    this.parentKeyId,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final Map<String, dynamic>? claims;
  final void Function(String?, String, String?)? onPressed;
  final SelectiveDisclosureState? selectiveDisclosureState;
  final String? parentKeyId;

  @override
  Widget build(BuildContext context) {
    final selectiveDisclosure = SelectiveDisclosure(credentialModel);
    final currentClaims = claims ?? selectiveDisclosure.claims;
    final languageCode = context.read<LangCubit>().state.locale.languageCode;

    final listOfClaims =
        currentClaims.entries.map((MapEntry<String, dynamic> map) {
      String? title;

      final mapKey = map.key;
      final mapValue = map.value;

      /// nested day contains more data
      if (mapValue is! Map<String, dynamic>) return Container();

      final display = getDisplay(mapKey, mapValue, languageCode);

      if (display == null) return Container();
      title = display['name'].toString();

      final bool hasNestedData =
          mapValue.values.any((element) => element is Map<String, dynamic>);

      if (hasNestedData && parentKeyId == null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: DisplaySelectiveDisclosure(
                credentialModel: credentialModel,
                claims: mapValue,
                showVertically: showVertically,
                selectiveDisclosureState: selectiveDisclosureState,
                parentKeyId: mapKey,
                onPressed: (nestedKey, _, threeDotValue) {
                  onPressed?.call(
                    nestedKey,
                    '$mapKey-$nestedKey',
                    threeDotValue,
                  );
                },
              ),
            ),
          ],
        );
      } else {
        return displayClaimData(mapKey, title, context);
      }
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listOfClaims +
          filteredListFromJwtEntries(
            selectiveDisclosure,
            currentClaims,
            context,
            parentKeyId,
          ).toList(),
    );
  }

  Iterable<Widget> filteredListFromJwtEntries(
    SelectiveDisclosure selectiveDisclosure,
    Map<String, dynamic> currentClaims,
    BuildContext context,
    String? parentKeyId,
  ) {
    if (selectiveDisclosureState == null &&
        !context.read<ProfileCubit>().state.model.isDeveloperMode) return [];
    return selectiveDisclosure.disclosureFromJWT.map((String disclosure) {
      /// check if disclosure is in a nested value
      /// if so, return empty container
      final oidc4vc = OIDC4VC();
      final content = selectiveDisclosure.disclosureToContent(disclosure);

      final digest = oidc4vc.sh256HashOfContent(
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
        if (disclosuresContent.isNotEmpty) return Container();

        /// Check if the disclosure is nested in a element from payload
        /// If so, return empty container, else continue building of the widget
        if (isNestedInpayload(selectiveDisclosure.contents, digest)) {
          return Container();
        }
      } else {
        /// keep going only if element is in the nested value of the parentKeyId
        /// either in the payload or the claims

        final nestedValue =
            selectiveDisclosure.extractedValuesFromJwt[parentKeyId] ??
                SelectiveDisclosure(credentialModel).payload[parentKeyId];
        if (nestedValue == null) return Container();
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
        if (!displayElement) return Container();
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
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  element.key.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DisplaySelectiveDisclosure(
                  credentialModel: credentialModel,
                  claims: const {},
                  showVertically: showVertically,
                  selectiveDisclosureState: selectiveDisclosureState,
                  parentKeyId: element.key.toString(),
                  onPressed: (nestedKey, _, threeDotValue) {
                    onPressed?.call(
                      nestedKey,
                      '${element.key}-$nestedKey',
                      threeDotValue,
                    );
                  },
                ),
              ),
            ],
          );
        }

        final toto = displayClaimData(
          element.key.toString(),
          element.key.toString(),
          context,
        );
        return toto;
      } else {
        return Container();
      }
    });
  }

  Widget displayClaimData(String mapKey, String? title, BuildContext context) {
    final List<ClaimsData> claimsData =
        SelectiveDisclosure(credentialModel).getClaimsData(
      key: mapKey,
    );

    if (claimsData.isEmpty) return Container();

    return Column(
      children: claimsData.map(
        (ClaimsData claims) {
          final index = claimsData.indexOf(claims);
          var keyToCheck = mapKey;
          var claimKey = mapKey;

          if (parentKeyId != null) {
            keyToCheck = '$parentKeyId-$mapKey';
          }

          final isFirstElement = index == 0;

          if (!isFirstElement) {
            keyToCheck = '$keyToCheck-$index';
            claimKey = '$claimKey-$index';
          }

          final limitDisclosure = selectiveDisclosureState?.limitDisclosure;

          final isCompulsary =
              limitDisclosure != null && limitDisclosure == 'required';

          bool isDisabled = isCompulsary;

          final selectedKeyId = selectiveDisclosureState?.selectedClaimsKeyIds
              .firstWhereOrNull((ele) => ele.keyId == keyToCheck);

          if (selectiveDisclosureState != null) {
            final filters = selectiveDisclosureState!.filters;
            if (filters != null) {
              isDisabled = isCompulsary;

              filters.forEach((key, value) {
                if (claims.threeDotValue != null) {
                  if (claimKey.contains(key) &&
                      claims.data.replaceAll(' ', '') == value) {
                    if (isCompulsary) isDisabled = false;

                    if (selectedKeyId == null) {
                      onPressed?.call(
                        key,
                        claimKey,
                        claims.threeDotValue,
                      );
                    }
                  }
                } else {
                  if (claimKey == key && claims.data == value) {
                    if (isCompulsary) isDisabled = false;

                    if (selectedKeyId == null) {
                      onPressed?.call(key, claimKey, null);
                    }
                  }
                }
              });
            }
          }

          return TransparentInkWell(
            onTap: () {
              if (isDisabled || isCompulsary) {
                return;
              }

              onPressed?.call(mapKey, claimKey, claims.threeDotValue);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: CredentialField(
                    padding: EdgeInsets.only(top: isFirstElement ? 10 : 0),
                    title: !isFirstElement ? null : title,
                    value: claims.data,
                    titleColor: Theme.of(context).colorScheme.onSurface,
                    valueColor: Theme.of(context).colorScheme.onSurface,
                    showVertically: showVertically,
                  ),
                ),
                if (!isDisabled &&
                    selectiveDisclosureState != null &&
                    claims.isfromDisclosureOfJWT) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 0, right: 10),
                    child: Icon(
                      (selectedKeyId != null && selectedKeyId.isSelected)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 25,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ).toList(),
    );
  }

  dynamic getDisplay(String key, dynamic value, String languageCode) {
    if (value is! Map<String, dynamic>) return null;

    if (value.isEmpty) return null;

    if (value.containsKey('display')) {
      final displays = value['display'];
      if (displays is! List<dynamic>) return null;
      if (displays.isEmpty) return null;

      final display = displays.firstWhere(
        (element) =>
            element is Map<String, dynamic> &&
            element.containsKey('locale') &&
            element['locale'].toString().contains(languageCode),
        orElse: () => displays.firstWhere(
          (element) =>
              element is Map<String, dynamic> &&
              element.containsKey('locale') &&
              element['locale'].toString().contains('en'),
          orElse: () => displays.firstWhere(
            (element) =>
                element is Map<String, dynamic> &&
                element.containsKey('locale'),
            orElse: () => null,
          ),
        ),
      );

      return display;
    } else {
      return null;
    }
  }

  bool isNestedInpayload(List<String> contents, String digest) {
    final payload = SelectiveDisclosure(credentialModel).payload;
    final JsonPath dataPath = JsonPath(
      r'$..["_sd"]',
    );
    final List<dynamic> list = [];
    payload.remove('_sd');
    dataPath.read(payload).forEach((element) {
      if (element.value is List) {
        list.addAll(element.value! as List);
      }
    });

    return list.contains(digest);
  }
}
