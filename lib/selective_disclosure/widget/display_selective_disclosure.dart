import 'package:altme/app/shared/constants/parameters.dart';
import 'package:altme/app/shared/extension/iterable_extension.dart';
import 'package:altme/app/shared/widget/base/credential_field.dart';
import 'package:altme/app/shared/widget/transparent_ink_well.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/helper_functions/selective_disclosure_display_map.dart';

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
    final languageCode = context.read<LangCubit>().state.locale.languageCode;
    final limitDisclosure = selectiveDisclosureState?.limitDisclosure ?? '';
    final filters = selectiveDisclosureState?.filters ?? {};

    final mapToDisplay = SelectiveDisclosureDisplayMap(
      credentialModel: credentialModel,
      claims: claims,
      isPresentation: selectiveDisclosureState != null,
      languageCode: languageCode,
      limitDisclosure: limitDisclosure,
      filters: filters,
      isDeveloperMode: context.read<ProfileCubit>().state.model.isDeveloperMode,
      selectedClaimsKeyIds:
          selectiveDisclosureState?.selectedClaimsKeyIds ?? [],
      onPressed: onPressed,
    ).buildMap;

    final List<Widget> listOfClaims =
        mapToDisplay.entries.map((MapEntry<String, dynamic> map) {
      return DisplaySelectiveDisclosureValue(
        onPressed: onPressed,
        showVertically: showVertically,
        disclosure: {
          map.key: map.value,
        },
      );
    }).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listOfClaims,
    );
  }
}

class DisplaySelectiveDisclosureValue extends StatelessWidget {
  const DisplaySelectiveDisclosureValue({
    super.key,
    required this.disclosure,
    required this.showVertically,
    required this.onPressed,
  });
  final Map<String, dynamic> disclosure;
  final bool showVertically;
  final void Function(String?, String, String?)? onPressed;

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetList = [];
    for (final element in disclosure.entries) {
      if (element.value is Map<String, dynamic>) {
        if (element.value['value'] is Map<String, dynamic>) {
          widgetList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisclosureTitle(
                  element: element,
                  onPressed: onPressed,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DisplaySelectiveDisclosureValue(
                    onPressed: onPressed,
                    showVertically: showVertically,
                    disclosure: element.value['value'] as Map<String, dynamic>,
                  ),
                ),
              ],
            ),
          );
          continue;
        }
        if (element.value['value'] is String ||
            element.value['value'] is bool ||
            element.value['value'] is num) {
          widgetList.add(
            DisclosureLine(
              onPressed: onPressed,
              elementKey: element.key,
              elementValue: element.value,
              showVertically: showVertically,
            ),
          );
          continue;
        }
        if (element.value['value'] == null) {
          widgetList.add(
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  DisclosureTitle(
                    element: element,
                    onPressed: onPressed,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: DisplaySelectiveDisclosureValue(
                      onPressed: onPressed,
                      showVertically: showVertically,
                      disclosure: element.value as Map<String, dynamic>,
                    ),
                  ),
                ],
              ),
            ),
          );
          continue;
        }
        if (element.value['value'] is List) {
          final List<Widget> nestedList = [];
          for (final nestedListElement in element.value['value'] as List) {
            nestedList.add(
              DisclosureLine(
                onPressed: onPressed,
                elementKey: null,
                elementValue: nestedListElement,
                showVertically: showVertically,
              ),
            );
          }
          widgetList.add(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisclosureTitle(
                  element: element,
                  onPressed: onPressed,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: nestedList,
                  ),
                ),
              ],
            ),
          );
          continue;
        }
      }
      if (element.value is String ||
          element.value is num ||
          element.value is bool) {
        widgetList.add(
          CredentialField(
            padding: const EdgeInsets.only(top: 8),
            title: element.key,
            value: element.value.toString(),
            titleColor: Theme.of(context).colorScheme.onSurface,
            valueColor: Theme.of(context).colorScheme.onSurface,
            showVertically: showVertically,
          ),
        );
        continue;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgetList,
    );
  }
}

class DisclosureTitle extends StatelessWidget {
  const DisclosureTitle({
    super.key,
    required this.element,
    this.onPressed,
  });
  final void Function(String?, String, String?)? onPressed;
  final MapEntry<String, dynamic> element;

  @override
  Widget build(BuildContext context) {
    if (element.key.startsWith(Parameters.doNotDisplayMe) &&
        element.value['hasCheckbox'] != true) {
      return const SizedBox();
    }
    return TransparentInkWell(
      onTap: () {
        if (element.value['hasCheckbox'] != true ||
            element.value['isCompulsary'] == true) {
          return;
        }

        onPressed?.call(
          element.value['mapKey'].toString(),
          element.value['claimKey'].toString(),
          element.value['threeDotValue']?.toString(),
        );
      },
      child: Row(
        children: [
          Text(
            displayKeyValueFromMap(element.key),
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const Spacer(),
          if (element.value['hasCheckbox'] == true) ...[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BlocBuilder<SelectiveDisclosureCubit,
                  SelectiveDisclosureState>(
                builder: (context, state) {
                  final selectedKeyId =
                      state.selectedClaimsKeyIds.firstWhereOrNull(
                    (ele) => ele.keyId == element.value['claimKey'].toString(),
                  );

                  return Center(
                    child: Icon(
                      (selectedKeyId != null && selectedKeyId.isSelected)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 25,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String displayKeyValueFromMap(String key) =>
    key.startsWith(Parameters.doNotDisplayMe) ? '' : key;

class DisclosureLine extends StatelessWidget {
  const DisclosureLine({
    super.key,
    required this.onPressed,
    required this.showVertically,
    this.elementKey,
    required this.elementValue,
  });

  final void Function(String?, String, String?)? onPressed;
  final bool showVertically;
  final String? elementKey;
  final dynamic elementValue;

  @override
  Widget build(BuildContext context) {
    String? title = elementKey;
    if (title != null) {
      title = title.startsWith(Parameters.doNotDisplayMe) ? null : title;
    }
    return TransparentInkWell(
      onTap: () {
        if (elementValue['hasCheckbox'] != true ||
            elementValue['isCompulsary'] == true) {
          return;
        }

        onPressed?.call(
          elementValue['mapKey'].toString(),
          elementValue['claimKey'].toString(),
          elementValue['threeDotValue']?.toString(),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CredentialField(
              padding: const EdgeInsets.only(top: 8),
              title: title,
              value: elementValue['value'].toString(),
              titleColor: Theme.of(context).colorScheme.onSurface,
              valueColor: Theme.of(context).colorScheme.onSurface,
              showVertically: showVertically,
              type: elementValue['type'].toString(),
            ),
          ),
          if (elementValue['hasCheckbox'] == true) ...[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: BlocBuilder<SelectiveDisclosureCubit,
                  SelectiveDisclosureState>(
                builder: (context, state) {
                  final selectedKeyId =
                      state.selectedClaimsKeyIds.firstWhereOrNull(
                    (ele) => ele.keyId == elementValue['claimKey'].toString(),
                  );

                  return Center(
                    child: Icon(
                      (selectedKeyId != null && selectedKeyId.isSelected)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 25,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
