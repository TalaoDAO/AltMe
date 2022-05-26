import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionText extends StatefulWidget {
  const VersionText({Key? key}) : super(key: key);

  @override
  State<VersionText> createState() => _VersionTextState();
}

class _VersionTextState extends State<VersionText> {
  String appVersion = '';

  @override
  void initState() {
    Future<void>.delayed(Duration.zero, () async {
      //TODO(bibash): remove setstate , update splashstate when removing onboarding
      final version = await _getAppVersion();
      setState(() {
        appVersion = version;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Text(
      '${l10n.version} $appVersion',
      maxLines: 1,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyText2,
    );
  }

  Future<String> _getAppVersion() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
