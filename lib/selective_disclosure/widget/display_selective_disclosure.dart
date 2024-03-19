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
    this.claims,
    this.onPressed,
    this.selectedIndex,
  });

  final CredentialModel credentialModel;

  final Map<String, dynamic>? claims;
  final void Function(int, int)? onPressed;
  final List<int>? selectedIndex;

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

        final claimIndex = currentClaims.entries
            .toList()
            .indexWhere((entry) => entry.key == key);

        final sdIndexInJWT = selectiveDisclosure.extractedValuesFromJwt.entries
            .toList()
            .indexWhere((entry) => entry.key == key);

        final bool hasChildren =
            !(value as Map<String, dynamic>).containsKey('display');
        if (hasChildren && value.isNotEmpty) {
          return TransparentInkWell(
            onTap: () => onPressed?.call(claimIndex, sdIndexInJWT),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: DisplaySelectiveDisclosure(
                    credentialModel: credentialModel,
                    claims: value,
                  ),
                ),
                if (selectedIndex != null) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 10),
                    child: Icon(
                      selectedIndex!.contains(claimIndex)
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
        } else {
          final display = getDisplay(key, value, languageCode);

          if (display == null) return Container();
          title = display['name'].toString();

          data = SelectiveDisclosure(credentialModel).getClaimsData(
            key: key,
            chooseFromDisclosureFromJWTOnly: true,
          );

          if (data == null) return Container();

          return TransparentInkWell(
            onTap: () => onPressed?.call(claimIndex, sdIndexInJWT),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: CredentialField(
                    padding: EdgeInsets.zero,
                    title: title,
                    value: data,
                    titleColor: Theme.of(context).colorScheme.titleColor,
                    valueColor: Theme.of(context).colorScheme.valueColor,
                  ),
                ),
                if (selectedIndex != null) ...[
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 10),
                    child: Icon(
                      selectedIndex!.contains(claimIndex)
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

    if (value.containsKey('mandatory')) {
      final mandatory = value['mandatory'];
      if (mandatory is! bool) return null;

      // if (!mandatory) return null;
    }

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
