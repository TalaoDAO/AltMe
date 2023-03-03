import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/enum/type/type.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class ChooseVerificationMethodPage extends StatelessWidget {
  const ChooseVerificationMethodPage({
    super.key,
    required this.credentialSubjectType,
    required this.onSelectPassbase,
    required this.onSelectKYC,
  });

  final CredentialSubjectType credentialSubjectType;
  final Function onSelectPassbase;
  final Function onSelectKYC;

  static Route<dynamic> route({
    required CredentialSubjectType credentialSubjectType,
    required Function onSelectPassbase,
    required Function onSelectKYC,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AiAgeResultPage'),
      builder: (_) => ChooseVerificationMethodPage(
        credentialSubjectType: credentialSubjectType,
        onSelectPassbase: onSelectPassbase,
        onSelectKYC: onSelectKYC,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String title = '';

    if (credentialSubjectType == CredentialSubjectType.over13) {
      title = l10n.chooseMethodPageOver13Title;
    } else if (credentialSubjectType == CredentialSubjectType.over18) {
      title = l10n.chooseMethodPageOver18Title;
    } else {
      title = l10n.chooseMethodPageAgeRangeTitle;
    }
    return BasePage(
      title: title,
      titleLeading: const BackLeadingButton(),
      body: Column(
        children: [
          Text(
            l10n.chooseMethodPageSubtitle,
            style: Theme.of(context).textTheme.customListTileSubTitleStyle,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),
          CustomListTileCard(
            title: l10n.kycTitle,
            subTitle: l10n.kycSubtitle,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () => onSelectKYC.call(),
          ),
          const SizedBox(height: 20),
          CustomListTileCard(
            title: l10n.passbaseTitle,
            subTitle: l10n.passbaseSubtitle,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () => onSelectPassbase.call(),
          ),
        ],
      ),
    );
  }
}
