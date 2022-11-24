import 'package:altme/app/app.dart';
import 'package:altme/dashboard/ai_age_verification/verify_age/verify_age.dart';
import 'package:altme/dashboard/home/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseVerificationMethodPage extends StatelessWidget {
  const ChooseVerificationMethodPage({
    super.key,
    required this.credentialSubjectType,
  });

  final CredentialSubjectType credentialSubjectType;

  static Route route({required CredentialSubjectType credentialSubjectType}) {
    return MaterialPageRoute<void>(
      builder: (_) => ChooseVerificationMethodPage(
        credentialSubjectType: credentialSubjectType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChooseVerificationMethodView(
      credentialSubjectType: credentialSubjectType,
    );
  }
}

class ChooseVerificationMethodView extends StatefulWidget {
  const ChooseVerificationMethodView({
    super.key,
    required this.credentialSubjectType,
  });

  final CredentialSubjectType credentialSubjectType;

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
      title: widget.credentialSubjectType == CredentialSubjectType.over18
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
            title: l10n.realTimePhoto,
            subTitle: l10n.realTimePhotoDescription,
            imageAssetPath: ImageStrings.userCircleAdded,
            onTap: () {
              Navigator.of(context).pushReplacement<void, void>(
                VerifyAgePage.route(
                  credentialSubjectType: widget.credentialSubjectType,
                ),
              );
            },
            recommended: true,
          ),
          const SizedBox(
            height: Sizes.spaceNormal,
          ),
          CustomListTileCard(
            title: l10n.idDocumentCheck,
            subTitle: l10n.idDocumentCheckDescription,
            imageAssetPath: ImageStrings.userCircleAdd,
            onTap: () {
              Navigator.pop(context);
              context.read<HomeCubit>().startPassbaseVerification(
                    context.read<WalletCubit>(),
                  );
            },
          ),
        ],
      ),
    );
  }
}
