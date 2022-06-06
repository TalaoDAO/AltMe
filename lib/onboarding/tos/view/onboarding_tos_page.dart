import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/gen_phrase/view/onboarding_gen_phrase.dart';
import 'package:altme/onboarding/recovery/view/onboarding_recovery.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class OnBoardingTosPage extends StatelessWidget {
  const OnBoardingTosPage({Key? key, required this.routeType})
      : super(key: key);

  final WalletRouteType routeType;

  static Route route({required WalletRouteType routeType}) =>
      MaterialPageRoute<void>(
        builder: (context) => OnBoardingTosPage(routeType: routeType),
        settings: const RouteSettings(name: '/onBoardingTermsPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: l10n.onBoardingTosTitle,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      padding: EdgeInsets.zero,
      useSafeArea: false,
      navigation: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow,
              offset: const Offset(-1, -1),
              blurRadius: 4,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.onBoardingTosText,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                const SizedBox(height: 20),
                BaseButton.primary(
                  context: context,
                  onPressed: () async {
                    late Route routeTo;
                    if (routeType == WalletRouteType.create) {
                      routeTo = OnBoardingGenPhrasePage.route();
                    } else if (routeType == WalletRouteType.recover) {
                      routeTo = OnBoardingRecoveryPage.route();
                    }

                    final pinCode =
                        await getSecureStorage.get(SecureStorageKeys.pinCode);
                    if (pinCode?.isEmpty ?? true) {
                      await Navigator.of(context).push<void>(
                        EnterNewPinCodePage.route(
                          isValidCallback: () {
                            Navigator.of(context)
                                .pushReplacement<void, void>(routeTo);
                          },
                        ),
                      );
                    } else {
                      await Navigator.of(context).push<void>(
                        PinCodePage.route(
                          isValidCallback: () {
                            Navigator.of(context)
                                .pushReplacement<void, void>(routeTo);
                          },
                        ),
                      );
                    }
                  },
                  child: Text(l10n.onBoardingTosButton),
                )
              ],
            ),
          ),
        ),
      ),
      body: const DisplayTerms(),
    );
  }
}
