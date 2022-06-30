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
        builder: (context) => BlocProvider<TOSCubit>(
          create: (_) => TOSCubit(),
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
      bool scrollIsOver = false;
      if (_scrollController.offset + 500 >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        scrollIsOver = true;
      } else {
        scrollIsOver = false;
      }
      if (context.read<TOSCubit>().state.scrollIsOver != scrollIsOver) {
        context.read<TOSCubit>().setScrolledIsOver(scrollIsOver: scrollIsOver);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<TOSCubit, TOSState>(
      builder: (context, state) {
        return BasePage(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: l10n.onBoardingTosTitle,
          titleLeading: const BackLeadingButton(),
          scrollView: false,
          padding: EdgeInsets.only(
            top: Sizes.spaceSmall,
            right: Sizes.spaceSmall,
            left: Sizes.spaceSmall,
            bottom: state.scrollIsOver ? 0 : Sizes.spaceSmall,
          ),
          useSafeArea: false,
          navigation: Visibility(
            visible: state.scrollIsOver,
            child: AcceptanceButtonsWidget(
              agreeTermsAndCondition: state.agreeTerms,
              readTermsOfUse: state.readTerms,
              onAcceptancePressed: () => onAcceptancePressed(context),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(Sizes.smallRadius),
                topRight: const Radius.circular(Sizes.smallRadius),
                bottomRight:
                    Radius.circular(state.scrollIsOver ? 0 : Sizes.smallRadius),
                bottomLeft:
                    Radius.circular(state.scrollIsOver ? 0 : Sizes.smallRadius),
              ),
            ),
            child: DisplayTerms(
              scrollController: _scrollController,
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
