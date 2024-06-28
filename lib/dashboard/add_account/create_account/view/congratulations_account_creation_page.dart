import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:key_generator/key_generator.dart';

class CongratulationsAccountCreationPage extends StatelessWidget {
  const CongratulationsAccountCreationPage({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;

  static Route<dynamic> route({required AccountType accountType}) {
    return MaterialPageRoute<void>(
      settings:
          const RouteSettings(name: '/congratulationsAccountCreationPage'),
      builder: (_) => CongratulationsAccountCreationPage(
        accountType: accountType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CongratulationsAccountCreationView(
      accountType: accountType,
    );
  }
}

class CongratulationsAccountCreationView extends StatefulWidget {
  const CongratulationsAccountCreationView({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;

  @override
  State<CongratulationsAccountCreationView> createState() =>
      _CongratulationsAccountCreationViewState();
}

class _CongratulationsAccountCreationViewState
    extends State<CongratulationsAccountCreationView> {
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

    String message = '';
    switch (widget.accountType) {
      case AccountType.ssi:
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'Invalid request.',
          },
        );
      case AccountType.tezos:
        message = l10n.tezosAccountCreationCongratulations;

      case AccountType.ethereum:
        message = l10n.ethereumAccountCreationCongratulations;

      case AccountType.fantom:
        message = l10n.fantomAccountCreationCongratulations;

      case AccountType.polygon:
        message = l10n.polygonAccountCreationCongratulations;

      case AccountType.binance:
        message = l10n.binanceAccountCreationCongratulations;
    }

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
                WalletLogo(
                  height: Sizes.logo2XLarge,
                  width: MediaQuery.of(context).size.shortestSide * 0.5,
                  showPoweredBy: true,
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
                Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,),
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
