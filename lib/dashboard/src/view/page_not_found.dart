import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ContactUsView();
  }
}

class ContactUsView extends StatefulWidget {
  const ContactUsView({
    super.key,
  });

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pop();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.contactUs,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: const Text('Page not found'),
    );
  }
}
