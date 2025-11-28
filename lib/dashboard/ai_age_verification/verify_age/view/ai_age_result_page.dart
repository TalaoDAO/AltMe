import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class AiAgeResultPage extends StatelessWidget {
  const AiAgeResultPage({
    super.key,
    required this.blocContext,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final BuildContext blocContext;
  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

  static Route<dynamic> route({
    required BuildContext context,
    required CredentialSubjectType credentialSubjectType,
    required VCFormatType vcFormatType,
  }) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AiAgeResultPage'),
      builder: (_) => AiAgeResultPage(
        blocContext: context,
        credentialSubjectType: credentialSubjectType,
        vcFormatType: vcFormatType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (context) => BlocProvider.of<CameraCubit>(blocContext),
      child: AiAgeResultView(
        credentialSubjectType: credentialSubjectType,
        vcFormatType: vcFormatType,
      ),
    );
  }
}

class AiAgeResultView extends StatefulWidget {
  const AiAgeResultView({
    super.key,
    required this.credentialSubjectType,
    required this.vcFormatType,
  });

  final CredentialSubjectType credentialSubjectType;
  final VCFormatType vcFormatType;

  @override
  State<AiAgeResultView> createState() => _AiAgeResultViewState();
}

class _AiAgeResultViewState extends State<AiAgeResultView> {
  late final ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController();
    Future<void>.delayed(
      Duration.zero,
    ).then((value) => confettiController.play());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            BasePage(
              scrollView: false,
              body: Center(
                child: state.acquiredCredentialsQuantity > 0
                    ? SuccessWidget(
                        ageEstimate: state.ageEstimate,
                        credentialSubjectType: widget.credentialSubjectType,
                        vcFormatType: widget.vcFormatType,
                      )
                    : FailureWidget(vcFormatType: widget.vcFormatType),
              ),
            ),
            if (state.acquiredCredentialsQuantity > 0)
              ConfettiWidget(
                confettiController: confettiController,
                canvas: Size.infinite,
                shouldLoop: true,
                blastDirectionality: BlastDirectionality.explosive,
              )
            else
              const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}

class SuccessWidget extends StatelessWidget {
  const SuccessWidget({
    super.key,
    required this.credentialSubjectType,
    required this.ageEstimate,
    required this.vcFormatType,
  });

  final CredentialSubjectType credentialSubjectType;
  final String ageEstimate;
  final VCFormatType vcFormatType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        WalletLogo(
          height: Sizes.logo2XLarge,
          width: MediaQuery.of(context).size.shortestSide * 0.5,
          showPoweredBy: true,
        ),
        const SizedBox(height: Sizes.spaceNormal),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            l10n.yourAgeEstimationIs(ageEstimate),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: Sizes.spaceNormal),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            l10n.youGotAgeCredentials(credentialSubjectType.title),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
        const Spacer(),
        MyElevatedButton(
          text: l10n.ok,
          verticalSpacing: 18,
          onPressed: () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          },
        ),
      ],
    );
  }
}

class FailureWidget extends StatelessWidget {
  const FailureWidget({super.key, required this.vcFormatType});

  final VCFormatType vcFormatType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        WalletLogo(
          height: Sizes.logo2XLarge,
          width: MediaQuery.of(context).size.shortestSide * 0.5,
          showPoweredBy: true,
        ),
        const SizedBox(height: Sizes.spaceNormal),
        Text(
          l10n.aiSystemWasNotAbleToEstimateYourAge,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        // const SizedBox(height: Sizes.spaceNormal),
        // Text(
        //   'Would you like to get your credentials through KYC system?',
        //   textAlign: TextAlign.center,
        //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        //         fontWeight: FontWeight.normal,
        //         color: Theme.of(context).colorScheme.onTertiary,
        //       ),
        // ),
        const Spacer(),
        MyElevatedButton(
          text: l10n.tryAgain,
          verticalSpacing: 16,
          borderRadius: Sizes.largeRadius,
          onPressed: () async {
            await securityCheck(
              context: context,
              title: l10n.typeYourPINCodeToAuthenticate,
              localAuthApi: LocalAuthApi(),
              onSuccess: () {
                Navigator.pushReplacement(
                  context,
                  CameraPage.route(
                    credentialSubjectType: CredentialSubjectType.over13,
                    vcFormatType: vcFormatType,
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: Sizes.spaceNormal),
        // MyElevatedButton(
        //   text: l10n.kyc,
        //   verticalSpacing: 16,
        //   borderRadius: Sizes.largeRadius,
        //   onPressed: () async {
        //     await securityCheck(
        //       context: context,
        //       title: l10n.typeYourPINCodeToAuthenticate,
        //       localAuthApi: LocalAuthApi(),
        //       onSuccess: () {
        //         context
        //             .read<KycVerificationCubit>()
        //             .startKycVerifcation(vcType: KycVcType.verifiableId);
        //       },
        //     );
        //     await Navigator.pushAndRemoveUntil<void>(
        //       context,
        //       DashboardPage.route(),
        //       (Route<dynamic> route) => route.isFirst,
        //     );
        //   },
        // ),
        // const SizedBox(height: Sizes.spaceNormal),
        MyElevatedButton(
          text: l10n.decline,
          verticalSpacing: 16,
          borderRadius: Sizes.largeRadius,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          },
        ),
      ],
    );
  }
}
