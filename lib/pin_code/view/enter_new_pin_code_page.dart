import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/widgets/m_stepper.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

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
      create: (context) => PinCodeViewCubit(
        secureStorageProvider: getSecureStorage,
      ),
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
    return BasePage(
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: PinCodeWidget(
        title: l10n.enterNewPinCode,
        header: widget.isFromOnboarding
            ? MStepper(
                step: 1,
                totalStep: byPassScreen ? 2 : 3,
              )
            : null,
        deleteButton: Text(
          l10n.deleteDigit,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        cancelButton: Text(
          l10n.cancel,
          style: Theme.of(context).textTheme.labelLarge,
        ),
        cancelCallback: _onPasscodeCancelled,
        isNewCode: true,
        isValidCallback: _isValidCallback,
      ),
    );
  }

  void _isValidCallback() {
    Navigator.pushReplacement<dynamic, dynamic>(
      context,
      ConfirmPinCodePage.route(
        storedPassword: context.read<PinCodeViewCubit>().state.enteredPasscode,
        isValidCallback: widget.isValidCallback,
        isFromOnboarding: widget.isFromOnboarding,
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.maybePop(context);
  }
}
