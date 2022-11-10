import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class ConfirmPinCodePage extends StatelessWidget {
  const ConfirmPinCodePage({
    Key? key,
    required this.storedPassword,
    required this.isValidCallback,
    required this.isFromOnboarding,
  }) : super(key: key);

  final String storedPassword;
  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  static Route route({
    required String storedPassword,
    required VoidCallback isValidCallback,
    required bool isFromOnboarding,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ConfirmPinCodePage(
        storedPassword: storedPassword,
        isValidCallback: isValidCallback,
        isFromOnboarding: isFromOnboarding,
      ),
      settings: const RouteSettings(name: '/confirmPinCodePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(),
      child: ConfirmPinCodeView(
        storedPassword: storedPassword,
        isValidCallback: isValidCallback,
        isFromOnboarding: isFromOnboarding,
      ),
    );
  }
}

class ConfirmPinCodeView extends StatefulWidget {
  const ConfirmPinCodeView({
    Key? key,
    required this.storedPassword,
    required this.isValidCallback,
    required this.isFromOnboarding,
  }) : super(key: key);

  final String storedPassword;
  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  @override
  State<StatefulWidget> createState() => _ConfirmPinCodeViewState();
}

class _ConfirmPinCodeViewState extends State<ConfirmPinCodeView> {
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
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: PinCodeWidget(
        title: l10n.confirmYourPinCode,
        passwordEnteredCallback: _onPasscodeEntered,
        header: widget.isFromOnboarding
            ? const MStepper(
                step: 1,
                totalStep: 3,
              )
            : null,
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
