import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/widgets/m_stepper.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmPinCodePage extends StatelessWidget {
  const ConfirmPinCodePage({
    super.key,
    required this.storedPassword,
    required this.isValidCallback,
    required this.isFromOnboarding,
  });

  final String storedPassword;
  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  static Route<dynamic> route({
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
    super.key,
    required this.storedPassword,
    required this.isValidCallback,
    required this.isFromOnboarding,
  });

  final String storedPassword;
  final VoidCallback isValidCallback;
  final bool isFromOnboarding;

  @override
  State<StatefulWidget> createState() => _ConfirmPinCodeViewState();
}

class _ConfirmPinCodeViewState extends State<ConfirmPinCodeView> {
  bool get byPassScreen => !Parameters.walletHandlesCrypto;

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
    return WillPopScope(
      onWillPop: () async => !widget.isFromOnboarding,
      child: BasePage(
        scrollView: false,
        title: '',
        titleAlignment: Alignment.topCenter,
        titleLeading: const BackLeadingButton(),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: PinCodeWidget(
          title: l10n.confirmYourPinCode,
        header: widget.isFromOnboarding
            ? MStepper(
                step: 1,
                totalStep: byPassScreen ? 2 : 3,
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
          isValidCallback: widget.isValidCallback,
          isNewCode: false,
        ),
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
