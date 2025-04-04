import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class KeyVerifiedPage extends StatelessWidget {
  const KeyVerifiedPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/KeyVerifiedPage'),
      builder: (_) => const KeyVerifiedPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const KeyVerifiedView();
  }
}

class KeyVerifiedView extends StatelessWidget {
  const KeyVerifiedView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: false,
      child: BasePage(
        scrollView: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WalletLogo(
                height: 90,
                width: MediaQuery.of(context).size.shortestSide * 0.5,
                showPoweredBy: true,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.welDone,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: Sizes.spaceNormal),
              Text(
                l10n.mnemonicsVerifiedMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.normal,
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
              ),
              const SizedBox(height: Sizes.space3XLarge),
            ],
          ),
        ),
        navigation: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceSmall,
              vertical: Sizes.space2XSmall,
            ),
            child: MyElevatedButton(
              text: l10n.letsGo,
              verticalSpacing: 18,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
