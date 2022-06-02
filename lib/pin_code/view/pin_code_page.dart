import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({
    Key? key,
    required this.isValidCallback,
  }) : super(key: key);

  final VoidCallback isValidCallback;

  static MaterialPageRoute route({required VoidCallback isValidCallback}) {
    return MaterialPageRoute<void>(
      builder: (_) => PinCodePage(isValidCallback: isValidCallback),
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
          isValidCallback: widget.isValidCallback,
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
