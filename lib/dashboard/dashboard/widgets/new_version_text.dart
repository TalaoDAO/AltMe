import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class NewVersionText extends StatelessWidget {
  const NewVersionText({
    super.key,
    required this.versionNumber,
  });

  final String versionNumber;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Sizes.spaceLarge,
        bottom: Sizes.spaceXSmall,
      ),
      child: Text(
        versionNumber,
        style: Theme.of(context).textTheme.newVersionTitle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
