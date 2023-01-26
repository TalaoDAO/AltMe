import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterNewPinCodePage extends StatelessWidget {
  const EnterNewPinCodePage({
    super.key,
    required this.isValidCallback,
    required this.isFromOnboarding,
  });

  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  static Route<dynamic> route({
    required VoidCallback isValidCallback,
    required bool isFromOnboarding,
    bool restrictToBack = true,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => EnterNewPinCodePage(
          isValidCallback: isValidCallback,
          isFromOnboarding: isFromOnboarding,
        ),
        settings: const RouteSettings(name: '/enterPinCodePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(),
      child: EnterNewPinCodeView(
        isValidCallback: isValidCallback,
        isFromOnboarding: isFromOnboarding,
      ),
    );
  }
}

class EnterNewPinCodeView extends StatefulWidget {
  const EnterNewPinCodeView({
    super.key,
    required this.isValidCallback,
    required this.isFromOnboarding,
  });

  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  @override
  State<StatefulWidget> createState() => _EnterNewPinCodeViewState();
}

class _EnterNewPinCodeViewState extends State<EnterNewPinCodeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        title: l10n.enterNewPinCode,
        passwordEnteredCallback: _onPasscodeEntered,
        header: widget.isFromOnboarding
            ? const MStepper(
                step: 1,
                totalStep: 3,
              )
            : null,
        deleteButton: Text(
          l10n.delete,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        cancelButton: Text(
          l10n.cancel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        cancelCallback: _onPasscodeCancelled,
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      ConfirmPinCodePage.route(
        storedPassword: enteredPasscode,
        isValidCallback: widget.isValidCallback,
        isFromOnboarding: widget.isFromOnboarding,
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
