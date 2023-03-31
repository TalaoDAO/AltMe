import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class CongratulationsAccountImportPage extends StatelessWidget {
  const CongratulationsAccountImportPage({
    super.key,
  });

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/congratulationsAccountImportPage'),
      builder: (_) => const CongratulationsAccountImportPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const CongratulationsAccountImportView();
  }
}

class CongratulationsAccountImportView extends StatefulWidget {
  const CongratulationsAccountImportView({
    super.key,
  });

  @override
  State<CongratulationsAccountImportView> createState() =>
      _CongratulationsAccountImportViewState();
}

class _CongratulationsAccountImportViewState
    extends State<CongratulationsAccountImportView> {
  late final ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController();
    Future<void>.delayed(Duration.zero)
        .then((value) => confettiController.play());
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
    return Stack(
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
                const AltMeLogo(
                  size: Sizes.logo2XLarge,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                Text(
                  l10n.congratulations,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                Text(
                  l10n.accountImportCongratulations,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
          navigation: Padding(
            padding: const EdgeInsets.all(
              Sizes.spaceSmall,
            ),
            child: MyElevatedButton(
              text: l10n.letsGo,
              onPressed: () {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  DashboardPage.route(),
                  (Route<dynamic> route) => route.isFirst,
                );
              },
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: confettiController,
          canvas: Size.infinite,
          shouldLoop: true,
          blastDirectionality: BlastDirectionality.explosive,
        ),
      ],
    );
  }
}
