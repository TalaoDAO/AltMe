import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/ai_age_verification/verify_age/view/camera_page.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class VerifyAgePage extends StatelessWidget {
  const VerifyAgePage({
    super.key,
    required this.credentialSubjectType,
  });

  final CredentialSubjectType credentialSubjectType;

  static Route<dynamic> route({
    required CredentialSubjectType credentialSubjectType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => VerifyAgePage(
        credentialSubjectType: credentialSubjectType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return VerifyAgeView(
      credentialSubjectType: credentialSubjectType,
    );
  }
}

class VerifyAgeView extends StatefulWidget {
  const VerifyAgeView({
    super.key,
    required this.credentialSubjectType,
  });

  final CredentialSubjectType credentialSubjectType;

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
              style: Theme.of(context).textTheme.subtitle3,
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
            style: Theme.of(context).textTheme.subtitle3,
          ),
          const Spacer(),
          MyElevatedButton(
            text: l10n.accept,
            verticalSpacing: 16,
            borderRadius: Sizes.largeRadius,
            onPressed: () async {
              await Navigator.of(context).push<void>(
                PinCodePage.route(
                  isValidCallback: () {
                    Navigator.push(
                      context,
                      CameraPage.route(
                        credentialSubjectType: widget.credentialSubjectType,
                      ),
                    );
                  },
                  restrictToBack: false,
                ),
              );
            },
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          MyElevatedButton(
            text: l10n.decline,
            verticalSpacing: 16,
            backgroundColor: Theme.of(context).colorScheme.cardHighlighted,
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
