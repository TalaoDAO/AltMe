import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/kyc_verification/kyc_verification.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAgeResultPage extends StatelessWidget {
  const AiAgeResultPage({super.key, required this.blocContext});

  final BuildContext blocContext;

  static Route<dynamic> route(BuildContext context) {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/AiAgeResultPage'),
      builder: (_) => AiAgeResultPage(blocContext: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CameraCubit>(
      create: (context) => BlocProvider.of<CameraCubit>(blocContext),
      child: const AiAgeResultView(),
    );
  }
}

class AiAgeResultView extends StatefulWidget {
  const AiAgeResultView({super.key});

  @override
  State<AiAgeResultView> createState() => _AiAgeResultViewState();
}

class _AiAgeResultViewState extends State<AiAgeResultView> {
  late final ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController();
    Future<void>.delayed(Duration.zero)
        .then((value) => confettiController.play());
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
                    ? SuccessWidget(state)
                    : FailureWidget(state),
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
  const SuccessWidget(
    this.state, {
    super.key,
  });
  final CameraState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        const AltMeLogo(
          size: Sizes.logo2XLarge,
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            l10n.yourAgeEstimationIs(state.ageEstimate),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            l10n.youGotAgeCredentials(state.acquiredCredentialsQuantity),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.normal,
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
          ),
        ),
        const Spacer(),
        MyGradientButton(
          text: l10n.ok,
          verticalSpacing: 18,
          onPressed: () {
            Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          },
        )
      ],
    );
  }
}

class FailureWidget extends StatelessWidget {
  const FailureWidget(
    this.state, {
    super.key,
  });
  final CameraState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        const AltMeLogo(
          size: Sizes.logo2XLarge,
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
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
            await Navigator.of(context).push<void>(
              PinCodePage.route(
                isValidCallback: () {
                  Navigator.pushReplacement(
                    context,
                    CameraPage.route(
                      credentialSubjectType: CredentialSubjectType.over13,
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
          text: l10n.kyc,
          verticalSpacing: 16,
          borderRadius: Sizes.largeRadius,
          onPressed: () async {
            await Navigator.of(context).push<void>(
              PinCodePage.route(
                isValidCallback: () => context
                    .read<KycVerificationCubit>()
                    .startKycVerifcation(vcType: KycVcType.verifiableId),
                restrictToBack: false,
              ),
            );
            await Navigator.pushAndRemoveUntil<void>(
              context,
              DashboardPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          },
        ),
        const SizedBox(
          height: Sizes.spaceNormal,
        ),
        MyElevatedButton(
          text: l10n.decline,
          verticalSpacing: 16,
          borderRadius: Sizes.largeRadius,
          backgroundColor: Theme.of(context).colorScheme.cardHighlighted,
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
