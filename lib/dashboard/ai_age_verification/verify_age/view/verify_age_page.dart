import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/widget/widget.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class VerifyAgePage extends StatelessWidget {
  const VerifyAgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const VerifyAgeView();
  }
}

class VerifyAgeView extends StatefulWidget {
  const VerifyAgeView({super.key});

  @override
  State<VerifyAgeView> createState() => _VerifyAgeViewState();
}

class _VerifyAgeViewState extends State<VerifyAgeView> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.verifyYourAge,
      scrollView: false,
      body: Column(
        children: [
          Text(l10n.verifyYourAgeSubtitle),
          Image.asset(
            ImageStrings.verifyYourAge,
          ),
          Text(l10n.verifyYourAgeDescription),
          const Spacer(),
          MyGradientButton(text: l10n.accept),
          MyGradientButton(text: l10n.decline),
        ],
      ),
    );
  }
}
