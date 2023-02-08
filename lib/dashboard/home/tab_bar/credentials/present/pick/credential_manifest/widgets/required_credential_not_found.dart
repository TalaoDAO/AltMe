import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class RequiredCredentialNotFound extends StatelessWidget {
  const RequiredCredentialNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.credentialPickTitle,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.only(
        right: Sizes.spaceNormal,
        left: Sizes.spaceNormal,
        bottom: Sizes.spaceNormal,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            l10n.requiredCredentialNotFoundTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.infoSubtitle,
          ),
          const Spacer(
            flex: 3,
          ),
          Image.asset(
            ImageStrings.cardMissing,
            width: 127,
            fit: BoxFit.fitWidth,
          ),
          const Spacer(
            flex: 1,
          ),
          Text(
            l10n.requiredCredentialNotFoundSubTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
          const Spacer(
            flex: 1,
          ),
          Text(
            l10n.requiredCredentialNotFoundDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.infoSubtitle,
          ),
          Text(
            AltMeStrings.appSupportMail,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.title,
          ),
          const Spacer(
            flex: 3,
          ),
        ],
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceXSmall),
        child: MyGradientButton(
          text: l10n.backToHome,
          onPressed: () {
            Navigator.popUntil(
              context,
              (route) => route.settings.name == '/dashboardPage',
            );
          },
        ),
      ),
    );
  }
}
