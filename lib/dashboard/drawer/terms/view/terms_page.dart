import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const TermsPage(),
        settings: const RouteSettings(name: '/termsPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: l10n.termsOfUse,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      body: BackgroundCard(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
            children: const [
              DisplayTermsofUse(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
