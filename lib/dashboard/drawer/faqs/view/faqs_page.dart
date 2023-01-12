import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FAQsPage extends StatelessWidget {
  const FAQsPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const FAQsPage(),
      settings: const RouteSettings(name: '/FAQsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FaqsCubit(),
      child: const FAQsView(),
    );
  }
}

class FAQsView extends StatelessWidget {
  const FAQsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.faqs,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: BlocBuilder<FaqsCubit, FaqModel>(
        builder: (context, state) {
          return Container();
        },
      ),
    );
  }
}
