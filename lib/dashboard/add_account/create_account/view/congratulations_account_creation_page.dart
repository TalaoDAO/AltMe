import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:key_generator/key_generator.dart';
//import 'package:confetti/confetti.dart';

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

class CongratulationsAccountCreationView extends StatelessWidget {
  const CongratulationsAccountCreationView({
    super.key,
    required this.accountType,
  });

  final AccountType accountType;
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    String message = '';
    switch (accountType) {
      case AccountType.ssi:
        throw Exception();
      case AccountType.tezos:
        message = l10n.tezosAccountCreationCongratulations;
        break;
      case AccountType.ethereum:
        message = l10n.ethereumAccountCreationCongratulations;
        break;
      case AccountType.fantom:
        message = l10n.fantomAccountCreationCongratulations;
        break;
      case AccountType.polygon:
        message = l10n.polygonAccountCreationCongratulations;
        break;
      case AccountType.binance:
        message = l10n.binanceAccountCreationCongratulations;
        break;
    }

    return BasePage(
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
              message,
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
    );
  }
}
