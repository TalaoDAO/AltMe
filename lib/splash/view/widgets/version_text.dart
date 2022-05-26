import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class VersionText extends StatelessWidget {
  const VersionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      // TODO(all): replace real version number
      '${l10n.version} 1.0',
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }
}
