import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionDrawer extends StatelessWidget {
  const AppVersionDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<PackageInfo>(
        future: PackageInfo.fromPlatform(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final version = snapshot.data?.version ?? '0.1.0';
              final buildNumber = snapshot.data?.buildNumber ?? '1';

              return Text(
                'Version $version ($buildNumber)',
                style: Theme.of(context).textTheme.bodySmall2,
              );
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
