import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: currentClaims.entries.map((MapEntry<String, dynamic> map) {
        String? title;

        final key = map.key;
        final value = map.value;

        /// nested day contains more data
        if (value is! Map<String, dynamic>) return Container();

        final display = getDisplay(key, value, languageCode);

        if (display == null) return Container();
        title = display['name'].toString();

        final bool hasNestedData =
            value.values.any((element) => element is Map<String, dynamic>);

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
                      ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DisplaySelectiveDisclosure(
                  credentialModel: credentialModel,
                  claims: value,
                  showVertically: showVertically,
                  selectiveDisclosureState: selectiveDisclosureState,
                  parentKeyId: key,
                  onPressed: (nestedKey, _, threeDotValue) {
                    onPressed?.call(
                      nestedKey,
                      '$key-$nestedKey',
                      threeDotValue,
                    );
                  },
                ),
              ),
            ],
          );
        } else {
          final List<ClaimsData> claimsData =
              SelectiveDisclosure(credentialModel).getClaimsData(
            key: key,
          );

          if (claimsData.isEmpty) return Container();

          return Column(
            children: claimsData.map(
              (ClaimsData claims) {
                final index = claimsData.indexOf(claims);
                var keyToCheck = key;
                var claimKey = key;

                if (parentKeyId != null) {
                  keyToCheck = '$parentKeyId-$key';
                }

                final isFirstElement = index == 0;

                if (!isFirstElement) {
                  title = null;
                  keyToCheck = '$keyToCheck-$index';
                  claimKey = '$claimKey-$index';
                }

                bool? disable;

                final limitDisclosure =
                    selectiveDisclosureState?.limitDisclosure;

                final isCompulsarily =
                    limitDisclosure != null && limitDisclosure == 'required';

                final selectedKeyId = selectiveDisclosureState
                    ?.selectedClaimsKeyIds
                    .firstWhereOrNull((ele) => ele.keyId == keyToCheck);

                if (selectiveDisclosureState != null) {
                  final filters = selectiveDisclosureState!.filters;
                  if (filters != null) {
                    disable = true;

                    filters.forEach((key, value) {
                      if (claims.threeDotValue != null) {
                        if (claimKey.contains(key) &&
                            claims.data.replaceAll(' ', '') == value) {
                          disable = false;

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
                          disable = false;

                          if (selectedKeyId == null) {
                            onPressed?.call(key, claimKey, null);
                          }
                        }
                      }
                    });
                  }
                }

                final isDisabled = disable != null && disable!;

                return TransparentInkWell(
                  onTap: () {
                    if (isDisabled || isCompulsarily) {
                      return;
                    }

                    onPressed?.call(key, claimKey, claims.threeDotValue);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: CredentialField(
                          padding:
                              EdgeInsets.only(top: isFirstElement ? 10 : 0),
                          title: title,
                          value: claims.data,
                          titleColor: Theme.of(context).colorScheme.onSurface,
                          valueColor: Theme.of(context).colorScheme.onSurface,
                          showVertically: showVertically,
                        ),
                      ),
                      if (selectiveDisclosureState != null &&
                          claims.isfromDisclosureOfJWT) ...[
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, right: 10),
                          child: Icon(
                            (selectedKeyId != null && selectedKeyId.isSelected)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            size: 25,
                            color: isDisabled
                                ? Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.3)
                                : Theme.of(context).colorScheme.onSurface,
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
      }).toList(),
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
}
