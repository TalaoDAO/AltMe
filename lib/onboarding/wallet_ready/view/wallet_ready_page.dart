import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
//import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WalletReadyPage extends StatelessWidget {
  const WalletReadyPage({super.key});

  static Route<dynamic> route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/walletReadyPage'),
      builder: (_) => const WalletReadyPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletReadyCubit(),
      child: const WalletReadyView(),
    );
  }
}

class WalletReadyView extends StatelessWidget {
  const WalletReadyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletReadyCubit, WalletReadyState>(
      builder: (context, state) {
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
                  l10n.walletReadyTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: Sizes.spaceNormal,
                ),
                Text(
                  l10n.walletReadySubtitle,
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
          navigation: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(
                    Sizes.spaceNormal,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Transform.scale(
                        scale: 1.3,
                        child: Checkbox(
                          value: state.isAgreeWithTerms,
                          fillColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary,
                          ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          onChanged: (newValue) => context
                              .read<WalletReadyCubit>()
                              .toggleAgreement(),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () {
                                context
                                    .read<WalletReadyCubit>()
                                    .toggleAgreement();
                              },
                              child: MyText(
                                l10n.iAgreeToThe,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Flexible(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushAndRemoveUntil<void>(
                                    context,
                                    OnBoardingTosPage.route(),
                                    (Route<dynamic> route) => route.isFirst,
                                  );
                                },
                                child: MyText(
                                  l10n.termsAndConditions.toLowerCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.spaceSmall,
                    vertical: Sizes.space2XSmall,
                  ),
                  child: MyGradientButton(
                    text: l10n.start,
                    verticalSpacing: 18,
                    onPressed: state.isAgreeWithTerms
                        ? () {
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              DashboardPage.route(),
                              (Route<dynamic> route) => route.isFirst,
                            );
                          }
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
