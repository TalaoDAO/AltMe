import 'dart:async';

import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ConfirmPinCodePage extends StatefulWidget {
  const ConfirmPinCodePage({
    Key? key,
  }) : super(key: key);

  static String storedPassword = '1234';

  static MaterialPageRoute Route() {
    return MaterialPageRoute<void>(builder: (_) => const ConfirmPinCodePage());
  }

  @override
  State<StatefulWidget> createState() => _ConfirmPinCodePageState();
}

class _ConfirmPinCodePageState extends State<ConfirmPinCodePage> {
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: PinCodeView(
          title: l10n.confirmYourPinCode,
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
          shouldTriggerVerification: _verificationNotifier.stream,
        ),
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    // TODO(Taleb): remove static variable storedPassword;
    final bool isValid = ConfirmPinCodePage.storedPassword == enteredPasscode;
    _verificationNotifier.add(isValid);
    if (isValid) {
      // TODO(Taleb): Navigate to HomePage
    }
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
