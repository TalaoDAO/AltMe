import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/onboarding/tos/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OnBoardingTosPage extends StatelessWidget {
  const OnBoardingTosPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (context) => const OnBoardingTosPage(),
        settings: const RouteSettings(name: '/onBoardingTermsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OnBoardingTosCubit>(
      create: (_) => OnBoardingTosCubit(),
      child: const OnBoardingTosView(),
    );
  }
}

class OnBoardingTosView extends StatefulWidget {
  const OnBoardingTosView({Key? key}) : super(key: key);

  @override
  State<OnBoardingTosView> createState() => _OnBoardingTosViewState();
}

class _OnBoardingTosViewState extends State<OnBoardingTosView> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(() async {
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double currentScroll = _scrollController.position.pixels;

      if (maxScroll - currentScroll <= 200) {
        context
            .read<OnBoardingTosCubit>()
            .setScrolledIsOver(scrollIsOver: true);
      } else {
        context
            .read<OnBoardingTosCubit>()
            .setScrolledIsOver(scrollIsOver: false);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<OnBoardingTosCubit, OnBoardingTosState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BasePage(
            backgroundColor: Theme.of(context).colorScheme.background,
            title: l10n.termsOfUse,
            scrollView: false,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            body: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  BackgroundCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        const DisplayTermsofUse(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(),
                        ),
                        CheckboxItem(
                          value: state.agreeTerms,
                          text: l10n.agreeTermsAndConditionCheckBox,
                          onChange: (value) {
                            context
                                .read<OnBoardingTosCubit>()
                                .setAgreeTerms(agreeTerms: value);
                          },
                        ),
                        CheckboxItem(
                          value: state.readTerms,
                          text: l10n.readTermsOfUseCheckBox,
                          onChange: (value) {
                            context
                                .read<OnBoardingTosCubit>()
                                .setReadTerms(readTerms: value);
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  MyGradientButton(
                    text: l10n.start,
                    onPressed: (state.agreeTerms && state.readTerms)
                        ? () async => onAcceptancePressed(context)
                        : null,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            floatingActionButton: state.scrollIsOver
                ? null
                : ScrollDownButton(
                    onPressed: onScrollDownButtonPressed,
                  ),
          ),
        );
      },
    );
  }

  void onScrollDownButtonPressed() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void onAcceptancePressed(BuildContext context) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      DashboardPage.route(),
      (Route<dynamic> route) => route.isFirst,
    );
  }
}
