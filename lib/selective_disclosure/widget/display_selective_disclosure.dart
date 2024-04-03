import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplaySelectiveDisclosure extends StatelessWidget {
  const DisplaySelectiveDisclosure({
    super.key,
    required this.credentialModel,
    required this.showVertically,
    this.claims,
    this.onPressed,
    this.selectedClaimsKeyIds,
    this.parentKeyId,
  });

  final CredentialModel credentialModel;
  final bool showVertically;
  final Map<String, dynamic>? claims;
  final void Function(String, String)? onPressed;
  final List<String>? selectedClaimsKeyIds;
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
        String? data;

        final key = map.key;
        final value = map.value;

        // "value_type": "string",
        // "display": [
        //     {"name": "Address", "locale": "en-US"},
        //     {"name": "Adresse", "locale": "fr-FR"}
        // ],
        // "street_address": {
        // "value_type": "string",
        // "display": [
        //     {"name": "Street address", "locale": "en-US"},
        //     {"name": "Rue", "locale": "fr-FR"}],
        // },
        // "locality": {
        // "value_type": "string",
        // "display": [
        //     {"name": "Locality", "locale": "en-US"},
        //     {"name": "Ville", "locale": "fr-FR"}],
        // },

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
                  style:
                      Theme.of(context).textTheme.credentialFieldTitle.copyWith(
                            color: Theme.of(context).colorScheme.titleColor,
                          ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: DisplaySelectiveDisclosure(
                  credentialModel: credentialModel,
                  claims: value,
                  showVertically: showVertically,
                  selectedClaimsKeyIds: selectedClaimsKeyIds,
                  parentKeyId: key,
                  onPressed: (nestedKey, _) {
                    onPressed?.call(nestedKey, '$key-$nestedKey');
                  },
                ),
              ),
            ],
          );
        } else {
          final (claimsData, isfromDisclosureOfJWT) =
              SelectiveDisclosure(credentialModel).getClaimsData(
            key: key,
          );

          data = claimsData;

          if (data == null) return Container();

          var keyToCheck = key;

          if (parentKeyId != null) {
            keyToCheck = '$parentKeyId-$key';
          }

          return TransparentInkWell(
            onTap: () => onPressed?.call(key, key),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CredentialField(
                    padding: EdgeInsets.zero,
                    title: title,
                    value: data,
                    titleColor: Theme.of(context).colorScheme.titleColor,
                    valueColor: Theme.of(context).colorScheme.valueColor,
                    showVertically: showVertically,
                  ),
                ),
                if (selectedClaimsKeyIds != null && isfromDisclosureOfJWT) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 10),
                    child: Icon(
                      selectedClaimsKeyIds!.contains(keyToCheck)
                          ? Icons.check_box
                          : Icons.check_box_outline_blank,
                      size: 25,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ],
            ),
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
