import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class ConfirmPinCodePage extends StatefulWidget {
  const ConfirmPinCodePage({
    Key? key,
    required this.storedPassword,
    required this.isValidCallback,
  }) : super(key: key);

  final String storedPassword;
  final VoidCallback isValidCallback;

  static MaterialPageRoute route(
    String storedPassword,
    VoidCallback isValidCallback,
  ) {
    return MaterialPageRoute<void>(
      builder: (_) => ConfirmPinCodePage(
        storedPassword: storedPassword,
        isValidCallback: isValidCallback,
      ),
      settings: const RouteSettings(name: '/confirmPinCodePage'),
    );
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
    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.background,
      scrollView: false,
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
          isValidCallback: widget.isValidCallback,
          shouldTriggerVerification: _verificationNotifier.stream,
        ),
      ),
    );
  }

  Future<void> _onPasscodeEntered(String enteredPasscode) async {
    final bool isValid = widget.storedPassword == enteredPasscode;
    if (isValid) {
      await getSecureStorage.set(SecureStorageKeys.pinCode, enteredPasscode);
    }
    _verificationNotifier.add(isValid);
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
