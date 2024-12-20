import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/scan/scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequiredCredentialNotFound extends StatelessWidget {
  const RequiredCredentialNotFound({super.key, required this.uri});

  final Uri uri;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: false,
      child: BasePage(
        titleAlignment: Alignment.topCenter,
        scrollView: false,
        padding: const EdgeInsets.only(
          right: Sizes.spaceNormal,
          left: Sizes.spaceNormal,
          bottom: Sizes.spaceNormal,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageStrings.cardMissing,
              width: 127,
              fit: BoxFit.fitWidth,
            ),
            const SizedBox(height: 30),
            Text(
              l10n.requiredCredentialNotFoundSubTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
        navigation: Padding(
          padding: const EdgeInsets.all(Sizes.spaceXSmall),
          child: MyElevatedButton(
            text: l10n.back,
            onPressed: () {
              if (context
                  .read<CredentialManifestPickCubit>()
                  .state
                  .filteredCredentialList
                  .isEmpty) {
                unawaited(
                  context.read<ScanCubit>().sendErrorToServer(
                    uri: uri,
                    data: {'error': 'access_denied'},
                  ),
                );
              }
              Navigator.popUntil(
                context,
                (route) => route.settings.name == AltMeStrings.dashBoardPage,
              );
            },
          ),
        ),
      ),
    );
  }
}
