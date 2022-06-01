import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/view/confirm_pin_code_page.dart';
import 'package:altme/pin_code/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PinCodePage extends StatefulWidget {
  const PinCodePage({
    Key? key,
    required this.routeTo,
  }) : super(key: key);

  final Route routeTo;

  static MaterialPageRoute route(Route routeTo) {
    return MaterialPageRoute<void>(
      builder: (_) => PinCodePage(routeTo: routeTo,),
      settings: const RouteSettings(name: '/pinCodePage'),
    );
  }

  @override
  State<StatefulWidget> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
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
        child: PinCodeView(
          title: l10n.enterNewPinCode,
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
        ),
      ),
    );
  }

  void _onPasscodeEntered(String enteredPasscode) {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      ConfirmPinCodePage.route(enteredPasscode,widget.routeTo),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
