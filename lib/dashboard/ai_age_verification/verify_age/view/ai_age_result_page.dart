import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AiAgeResultPage extends StatelessWidget {
  const AiAgeResultPage({super.key, required this.blocContext});

  final BuildContext blocContext;

  static Route route(BuildContext context) {
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
  late final ConfettiController confettiController = ConfettiController();

  @override
  void initState() {
    confettiController.play();
    super.initState();
  }

  @override
  void dispose() {
    confettiController.stop();
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<CameraCubit, CameraState>(
      builder: (context, state) {
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            BasePage(
              scrollView: false,
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AltMeLogo(
                      size: Sizes.logo2XLarge,
                    ),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
                    Text(
                      'Your AI age estimation is ${state.acquiredCredentialsQuantity} years',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
                    Text(
                      'You got ${state.acquiredCredentialsQuantity} credentials',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onTertiary,
                          ),
                    ),
                    const SizedBox(
                      height: Sizes.space3XLarge,
                    ),
                  ],
                ),
              ),
              navigation: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceSmall,
                    vertical: Sizes.space2XSmall,
                  ),
                  child: MyGradientButton(
                    text: l10n.ok,
                    verticalSpacing: 18,
                    onPressed: state.acquiredCredentialsQuantity > 0
                        ? () {
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              DashboardPage.route(),
                              (Route<dynamic> route) => route.isFirst,
                            );
                          }
                        : null,
                  ),
                ),
              ),
            ),
            // if (state.acquiredCredentialsQuantity > 0)
            //   ConfettiWidget(
            //     confettiController: confettiController,
            //     shouldLoop: true,
            //     minBlastForce: 2,
            //     maxBlastForce: 8,
            //     emissionFrequency: 0.02,
            //     blastDirectionality: BlastDirectionality.explosive,
            //     numberOfParticles: 10,
            //   )
            // else
            //   const SizedBox.shrink(),
          ],
        );
      },
    );
  }
}
