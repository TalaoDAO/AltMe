import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/dashboard/ai_age_verification/verify_age/verify_age.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:flutter/material.dart';

class ChooseVerificationMethodPage extends StatelessWidget {
  const ChooseVerificationMethodPage({
    super.key,
    required this.isOver18,
  });

  final bool isOver18;

  static Route route({required bool isOver18}) {
    return MaterialPageRoute<void>(
      builder: (_) => ChooseVerificationMethodPage(isOver18: isOver18),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChooseVerificationMethodView(
      isOver18: isOver18,
    );
  }
}

class ChooseVerificationMethodView extends StatefulWidget {
  const ChooseVerificationMethodView({
    super.key,
    required this.isOver18,
  });

  final bool isOver18;

  @override
  State<ChooseVerificationMethodView> createState() =>
      _ChooseVerificationMethodViewState();
}

class _ChooseVerificationMethodViewState
    extends State<ChooseVerificationMethodView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      titleMargin: const EdgeInsets.symmetric(horizontal: Sizes.spaceNormal),
      titleLeading: const BackLeadingButton(),
      title: widget.isOver18
          ? l10n.chooseMethodPageOver18Title
          : l10n.chooseMethodPageOver13Title,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.chooseMethodPageSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle3,
          ),
          const SizedBox(
            height: Sizes.spaceLarge,
          ),
          CustomListTileCard(
            title: l10n.idDocumentCheck,
            subTitle: l10n.idDocumentCheckDescription,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () {
              // TODO(Taleb): Navigate to Passbase verification
            },
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          CustomListTileCard(
            title: l10n.realTimePhoto,
            subTitle: l10n.realTimePhotoDescription,
            imageAssetPath: ImageStrings.userCircleAdd,
            onTap: () {
              Navigator.of(context).pushReplacement<void, void>(
                VerifyAgePage.route(),
              );
            },
          ),
        ],
      ),
    );
  }
}
