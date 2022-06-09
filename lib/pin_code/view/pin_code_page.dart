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
    this.restrictToBack = true,
    required this.localAuthApi,
  }) : super(key: key);

  final VoidCallback isValidCallback;
  final bool restrictToBack;
  final LocalAuthApi localAuthApi;

  static MaterialPageRoute route({
    required VoidCallback isValidCallback,
    bool restrictToBack = true,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => PinCodePage(
        isValidCallback: isValidCallback,
        restrictToBack: restrictToBack,
        localAuthApi: LocalAuthApi(),
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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final fingerprintEnabled =
          await getSecureStorage.get(SecureStorageKeys.fingerprintEnabled);
      if (fingerprintEnabled == true.toString()) {
        final l10n = context.l10n;
        final authenticated = await widget.localAuthApi
            .authenticate(localizedReason: l10n.scanFingerprintToAuthenticate);
        if (authenticated) {
          widget.isValidCallback.call();
        }
      }
    });
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
    return WillPopScope(
      onWillPop: () async => !widget.restrictToBack,
      child: BasePage(
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
    Navigator.of(context).maybePop();
  }
}
