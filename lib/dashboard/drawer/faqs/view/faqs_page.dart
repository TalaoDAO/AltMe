import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      body: BlocBuilder<FaqsCubit, FaqModel>(
        builder: (context, state) {
          return ListView.builder(
            itemCount: state.faq.length,
            itemBuilder: (context, index) {
              return ExpansionTileContainer(
                child: ExpansionTile(
                  initiallyExpanded: false,
                  childrenPadding: EdgeInsets.zero,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 8),
                  title: Text(
                    state.faq[index].que,
                    style: Theme.of(context).textTheme.faqQue,
                  ),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        state.faq[index].ans,
                        style: Theme.of(context).textTheme.faqAns,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
