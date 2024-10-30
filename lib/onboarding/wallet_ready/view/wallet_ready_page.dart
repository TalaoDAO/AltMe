import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/cubit/onboarding_cubit.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:confetti/confetti.dart';
//import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletReadyPage extends StatelessWidget {
  const WalletReadyPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/walletReadyPage'),
      builder: (_) => const WalletReadyPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletReadyCubit(),
      child: Builder(
        builder: (context) {
          return WalletReadyView(
            profileCubit: context.read<ProfileCubit>(),
            walletReadyCubit: context.read<WalletReadyCubit>(),
            confettiController: ConfettiController(),
          );
        },
      ),
    );
  }
}

class WalletReadyView extends StatefulWidget {
  const WalletReadyView({
    super.key,
    required this.walletReadyCubit,
    required this.profileCubit,
    required this.confettiController,
  });

  final WalletReadyCubit walletReadyCubit;
  final ProfileCubit profileCubit;
  final ConfettiController confettiController;

  @override
  State<WalletReadyView> createState() => _WalletReadyViewState();
}

class _WalletReadyViewState extends State<WalletReadyView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OnboardingCubit>().emitOnboardingDone();
      widget.confettiController.play();
    });

    super.initState();
  }

  @override
  void dispose() {
    widget.confettiController.stop();
    widget.confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletReadyCubit, WalletReadyState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.expand,
            children: [
              BasePage(
                scrollView: false,
                body: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WalletLogo(
                        height: 90,
                        width: MediaQuery.of(context).size.shortestSide * 0.5,
                        showPoweredBy: true,
                      ),
                      const SizedBox(
                        height: Sizes.spaceNormal,
                      ),
                      Text(
                        l10n.walletReadyTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      // const SizedBox(height: Sizes.spaceNormal),
                      // Text(
                      //   l10n.walletReadySubtitle,
                      //   textAlign: TextAlign.center,
                      //   style:
                      //    Theme.of(context).textTheme.headlineSmall?.copyWith(
                      //             fontWeight: FontWeight.normal,
                      //           ),
                      // ),
                      const SizedBox(height: Sizes.space3XLarge),
                    ],
                  ),
                ),
                navigation: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(
                          Sizes.spaceNormal,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                value: state.isAgreeWithTerms,
                                fillColor: WidgetStateProperty.all(
                                  Theme.of(context).colorScheme.primary,
                                ),
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6),
                                  ),
                                ),
                                onChanged: (newValue) =>
                                    widget.walletReadyCubit.toggleAgreement(),
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      widget.walletReadyCubit.toggleAgreement();
                                    },
                                    child: MyText(
                                      l10n.iAgreeToThe,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ),
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil<void>(
                                          context,
                                          OnBoardingTosPage.route(),
                                          (Route<dynamic> route) =>
                                              route.isFirst,
                                        );
                                      },
                                      child: MyText(
                                        l10n.termsAndConditions.toLowerCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceSmall,
                          vertical: Sizes.space2XSmall,
                        ),
                        child: MyElevatedButton(
                          text: l10n.start,
                          verticalSpacing: 18,
                          onPressed: state.isAgreeWithTerms
                              ? () {
                                  Navigator.pushAndRemoveUntil<void>(
                                    context,
                                    DashboardPage.route(),
                                    (Route<dynamic> route) => route.isFirst,
                                  );
                                  // Check with API if it is an  organization
                                  // wallet

                                  context
                                      .read<EnterpriseCubit>()
                                      .getWalletProviderAccount(
                                        context.read<QRCodeScanCubit>(),
                                      );
                                }
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ConfettiWidget(
                confettiController: widget.confettiController,
                canvas: Size.infinite,
                shouldLoop: true,
                blastDirectionality: BlastDirectionality.explosive,
              ),
            ],
          ),
        );
      },
    );
  }
}
