import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/onboarding/tos/widgets/widgets.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingTosPage extends StatefulWidget {
  const OnBoardingTosPage({Key? key, required this.routeType})
      : super(key: key);

  final WalletRouteType routeType;

  static Route route({required WalletRouteType routeType}) =>
      MaterialPageRoute<void>(
        builder: (context) => BlocProvider<OnBoardingTosCubit>(
          create: (_) => OnBoardingTosCubit(),
          child: OnBoardingTosPage(routeType: routeType),
        ),
        settings: const RouteSettings(name: '/onBoardingTermsPage'),
      );

  @override
  State<OnBoardingTosPage> createState() => _OnBoardingTosPageState();
}

class _OnBoardingTosPageState extends State<OnBoardingTosPage> {
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
        return BasePage(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: l10n.termsOfUse,
          titleLeading: const BackLeadingButton(),
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
                  text: l10n.onBoardingTosButton,
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

  Future<void> onAcceptancePressed(BuildContext context) async {
    late Route routeTo;
    if (widget.routeType == WalletRouteType.create) {
      routeTo = OnBoardingGenPhrasePage.route();
    } else if (widget.routeType == WalletRouteType.recover) {
      routeTo = OnBoardingRecoveryPage.route();
    }

    final pinCode = await getSecureStorage.get(SecureStorageKeys.pinCode);
    if (pinCode?.isEmpty ?? true) {
      await Navigator.of(context).push<void>(
        EnterNewPinCodePage.route(
          isValidCallback: () {
            Navigator.of(context).pushReplacement<void, void>(routeTo);
          },
        ),
      );
    } else {
      await Navigator.of(context).push<void>(
        PinCodePage.route(
          isValidCallback: () {
            Navigator.of(context).pushReplacement<void, void>(routeTo);
          },
        ),
      );
    }
  }
}
