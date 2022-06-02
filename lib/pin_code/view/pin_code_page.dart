import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/gen_phrase/view/onboarding_gen_phrase.dart';
import 'package:altme/onboarding/recovery/view/onboarding_recovery.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({
    Key? key,
    required this.routeType,
  }) : super(key: key);

  final WalletRouteType routeType;

  static MaterialPageRoute route(WalletRouteType routeType) {
    return MaterialPageRoute<void>(
      builder: (_) => PinCodePage(
        routeType: routeType,
      ),
      settings: const RouteSettings(name: '/pinCodePage'),
    );
  }

  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      scrollView: false,
      body: SafeArea(
        child: PinCodeView(
          title: l10n.enterYourPinCode,
          passwordEnteredCallback: _onPasscodeEntered,
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.button,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.button,
          ),
          cancelCallback: _onPasscodeCancelled,
          isValidCallback: () {
            Route? routeTo;
            if (widget.routeType == WalletRouteType.create) {
              routeTo = OnBoardingGenPhrasePage.route();
            } else if (widget.routeType == WalletRouteType.recover) {
              routeTo = OnBoardingRecoveryPage.route();
            } else if (widget.routeType == WalletRouteType.home) {
              routeTo = HomePage.route();
            }
            if (routeTo != null) {
              Navigator.of(context).pushReplacement<void, void>(routeTo);
            }
          },
          shouldTriggerVerification: _verificationNotifier.stream,
        ),
      ),
    );
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) async {
    final bool isValid =
        (await getSecureStorage.get(SecureStorageKeys.pinCode)) ==
            enteredPasscode;
    _verificationNotifier.add(isValid);
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
