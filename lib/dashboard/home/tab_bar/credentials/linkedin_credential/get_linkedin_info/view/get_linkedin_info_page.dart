import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetLinkedinInfoPage extends StatelessWidget {
  const GetLinkedinInfoPage({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  static Route<dynamic> route({required CredentialModel credentialModel}) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/GetLinkedinInfoPage'),
      builder: (_) => GetLinkedinInfoPage(credentialModel: credentialModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetLinkedinInfoCubit(),
      child: GetLinkedinInfoView(credentialModel: credentialModel),
    );
  }
}

class GetLinkedinInfoView extends StatefulWidget {
  const GetLinkedinInfoView({
    super.key,
    required this.credentialModel,
  });

  final CredentialModel credentialModel;

  @override
  State<GetLinkedinInfoView> createState() => _GetLinkedinInfoViewState();
}

class _GetLinkedinInfoViewState extends State<GetLinkedinInfoView> {
  late TextEditingController linkedInUrlController;

  @override
  void initState() {
    super.initState();
    linkedInUrlController = TextEditingController();
    linkedInUrlController.addListener(() {
      context
          .read<GetLinkedinInfoCubit>()
          .isUrlValid(linkedInUrlController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.addLinkedInInfo,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
        bottom: Sizes.spaceSmall,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: Sizes.spaceNormal),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceLarge,
            ),
            child: Text(
              l10n.whatsYourLinkedinProfileUrl,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    letterSpacing: 1.2,
                  ),
            ),
          ),
          const SizedBox(height: Sizes.spaceLarge),
          BlocBuilder<GetLinkedinInfoCubit, GetLinkedinInfoState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.bottomRight,
                fit: StackFit.loose,
                children: [
                  BaseTextField(
                    height: 100,
                    hint: 'e.g. https://www.linkedin.com/john.doe',
                    fillColor: Colors.transparent,
                    hintStyle: Theme.of(context).textTheme.hintTextFieldStyle,
                    maxLines: 3,
                    borderRadius: Sizes.normalRadius,
                    controller: linkedInUrlController,
                    error: state.isTextFieldEdited && !state.isLinkedUrlValid
                        ? l10n.invalidUrlError
                        : null,
                  ),
                  if (state.isLinkedUrlValid)
                    Container(
                      alignment: Alignment.center,
                      width: Sizes.icon2x,
                      height: Sizes.icon2x,
                      padding: const EdgeInsets.all(2),
                      margin: const EdgeInsets.all(Sizes.spaceNormal),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.checkMarkColor,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: Sizes.icon,
                        color: Colors.white,
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: Sizes.spaceSmall),
        ],
      ),
      navigation: Padding(
        padding: const EdgeInsets.all(Sizes.spaceSmall),
        child: BlocBuilder<GetLinkedinInfoCubit, GetLinkedinInfoState>(
          builder: (context, state) {
            return MyElevatedButton(
              text: l10n.exportToLinkedIn,
              onPressed: !state.isLinkedUrlValid
                  ? null
                  : () {
                      Navigator.of(context).push<void>(
                        GenerateLinkedinQrPage.route(
                          linkedinUrl: linkedInUrlController.text,
                          credentialModel: widget.credentialModel,
                        ),
                      );
                    },
            );
          },
        ),
      ),
    );
  }
}
