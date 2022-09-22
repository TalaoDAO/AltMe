import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ExpansionTileTitle extends StatelessWidget {
  const ExpansionTileTitle({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.disabledBgColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          title,
          style: Theme.of(context).textTheme.credentialManifestTitle2,
        ),
      ),
    );
  }
}
