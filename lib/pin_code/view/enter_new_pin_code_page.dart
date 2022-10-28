import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnterNewPinCodePage extends StatelessWidget {
  const EnterNewPinCodePage({
    Key? key,
    required this.isValidCallback,
  }) : super(key: key);

  final VoidCallback isValidCallback;

  static Route route({
    required VoidCallback isValidCallback,
    bool restrictToBack = true,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => EnterNewPinCodePage(
          isValidCallback: isValidCallback,
        ),
        settings: const RouteSettings(name: '/enterPinCodePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(),
      child: EnterNewPinCodeView(
        isValidCallback: isValidCallback,
      ),
    );
  }
}

class EnterNewPinCodeView extends StatefulWidget {
  const EnterNewPinCodeView({
    Key? key,
    required this.isValidCallback,
  }) : super(key: key);

  final VoidCallback isValidCallback;

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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: PinCodeWidget(
          title: l10n.enterNewPinCode,
          passwordEnteredCallback: _onPasscodeEntered,
          header: const MStepper(step: 1,totalStep: 3,),
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.button,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.button,
          ),
          cancelCallback: _onPasscodeCancelled,
        ),
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      ConfirmPinCodePage.route(enteredPasscode, widget.isValidCallback),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
