import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/cubit/pin_code_view_cubit.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class PinCodePage extends StatelessWidget {
  const PinCodePage({
    super.key,
    required this.isValidCallback,
    this.restrictToBack = true,
    required this.localAuthApi,
  });

  final VoidCallback isValidCallback;
  final bool restrictToBack;
  final LocalAuthApi localAuthApi;

  static Route<dynamic> route({
    required VoidCallback isValidCallback,
    bool restrictToBack = true,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => PinCodePage(
          isValidCallback: isValidCallback,
          restrictToBack: restrictToBack,
          localAuthApi: LocalAuthApi(),
        ),
        settings: const RouteSettings(name: '/pinCodePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(),
      child: PinCodeView(
        isValidCallback: isValidCallback,
        restrictToBack: restrictToBack,
        localAuthApi: LocalAuthApi(),
      ),
    );
  }
}

class PinCodeView extends StatefulWidget {
  const PinCodeView({
    super.key,
    required this.isValidCallback,
    this.restrictToBack = true,
    required this.localAuthApi,
  });

  final VoidCallback isValidCallback;
  final bool restrictToBack;
  final LocalAuthApi localAuthApi;

  @override
  State<StatefulWidget> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final fingerprintEnabled =
          await getSecureStorage.get(SecureStorageKeys.fingerprintEnabled);
      if (fingerprintEnabled == true.toString()) {
        final l10n = context.l10n;
        final authenticated = await widget.localAuthApi
            .authenticate(localizedReason: l10n.scanFingerprintToAuthenticate);
        if (authenticated) {
          Navigator.pop(context);
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
        body: PinCodeWidget(
          title: l10n.enterYourPinCode,
          subTitle: l10n.pinCodeMessage,
          passwordEnteredCallback: _onPasscodeEntered,
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelCallback: _onPasscodeCancelled,
          isValidCallback: () {
            Navigator.pop(context);
            widget.isValidCallback.call();
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
    Navigator.of(context).maybePop();
  }
}
