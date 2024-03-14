import 'package:altme/app/app.dart';
import 'package:altme/selective_disclosure/widget/display_selective_disclosure.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class SelectSelectiveDisclosure extends DisplaySelectiveDisclosure {
  const SelectSelectiveDisclosure({
    super.key,
    required super.credentialModel,
    super.claims,
  });

  @override
  Widget displayCredentialField(
    String title,
    String data,
    BuildContext context,
  ) {
    return TransparentInkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          children: [
            CredentialField(
              padding: EdgeInsets.zero,
              title: title,
              value: data,
              titleColor: Theme.of(context).colorScheme.titleColor,
              valueColor: Theme.of(context).colorScheme.valueColor,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(8),
              // child: Icon(
              //   state.contains(index)
              //       ? Icons.check_box
              //       : Icons.check_box_outline_blank,
              //   size: 25,
              //   color: Theme.of(context).colorScheme.onPrimary,
              // ),
              child: Icon(
                Icons.check_box,
                size: 25,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
