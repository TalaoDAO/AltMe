import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class ChooseVerificationMethodPage extends StatelessWidget {
  const ChooseVerificationMethodPage({
    super.key,
    required this.isOver18,
  });

  final bool isOver18;

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
      title: widget.isOver18
          ? l10n.chooseMethodPageOver18Title
          : l10n.chooseMethodPageOver13Title,
      body: Column(
        children: [
          Text(
            l10n.chooseMethodPageSubtitle,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          CustomListTileCard(
            title: l10n.idDocumentCheck,
            subTitle: l10n.idDocumentCheckDescription,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () {
              // TODO(Taleb): Navigate to Passbase verification
            },
          ),
          CustomListTileCard(
            title: l10n.realTimePhoto,
            subTitle: l10n.realTimePhotoDescription,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () {
              // TODO(Taleb): Navigate to AI age verification
            },
          ),
        ],
      ),
    );
  }
}
