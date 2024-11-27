import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

class VerifyAgePage extends StatelessWidget {
  const VerifyAgePage({
    super.key,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

  static Route<dynamic> route({
    required CredentialSubjectType credentialSubjectType,
    required VCFormatType vcFormatType,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/VerifyAgePage'),
      builder: (_) => VerifyAgePage(
        credentialSubjectType: credentialSubjectType,
        vcFormatType: vcFormatType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VerifyAgeView(
      credentialSubjectType: credentialSubjectType,
      vcFormatType: vcFormatType,
    );
  }
}

class VerifyAgeView extends StatefulWidget {
  const VerifyAgeView({
    super.key,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

  @override
  State<VerifyAgeView> createState() => _VerifyAgeViewState();
}

class _VerifyAgeViewState extends State<VerifyAgeView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.verifyYourAge,
      scrollView: false,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceSmall,
            ),
            child: Text(
              l10n.verifyYourAgeSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const Spacer(),
          Image.asset(
            ImageStrings.verifyYourAge,
            height: MediaQuery.of(context).size.height * 0.23,
          ),
          const Spacer(),
          Text(
            l10n.verifyYourAgeDescription,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const Spacer(),
          MyElevatedButton(
            text: l10n.accept,
            verticalSpacing: 16,
            borderRadius: Sizes.largeRadius,
            onPressed: () async {
              await securityCheck(
                context: context,
                title: l10n.typeYourPINCodeToAuthenticate,
                localAuthApi: LocalAuthApi(),
                onSuccess: () {
                  Navigator.push(
                    context,
                    CameraPage.route(
                      credentialSubjectType: widget.credentialSubjectType,
                      vcFormatType: widget.vcFormatType,
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          MyElevatedButton(
            text: l10n.decline,
            verticalSpacing: 16,
            backgroundColor: Theme.of(context).colorScheme.surface,
            borderRadius: Sizes.largeRadius,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: Sizes.spaceSmall,
          ),
        ],
      ),
    );
  }
}
