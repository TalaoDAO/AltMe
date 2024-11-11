import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class PinCodePage extends StatelessWidget {
  const PinCodePage({
    super.key,
    required this.title,
    required this.isValidCallback,
    this.restrictToBack = true,
    required this.localAuthApi,
    required this.walletProtectionType,
  });

  final String title;
  final VoidCallback isValidCallback;
  final bool restrictToBack;
  final LocalAuthApi localAuthApi;
  final WalletProtectionType walletProtectionType;

  static Route<dynamic> route({
    required String title,
    required VoidCallback isValidCallback,
    required WalletProtectionType walletProtectionType,
    bool restrictToBack = true,
  }) =>
      MaterialPageRoute<void>(
        builder: (_) => PinCodePage(
          title: title,
          isValidCallback: isValidCallback,
          restrictToBack: restrictToBack,
          localAuthApi: LocalAuthApi(),
          walletProtectionType: walletProtectionType,
        ),
        settings: const RouteSettings(name: '/pinCodePage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PinCodeViewCubit(
        totalPermitedLoginAttempt: 3,
        secureStorageProvider: getSecureStorage,
      ),
      child: PinCodeView(
        title: title,
        isValidCallback: isValidCallback,
        restrictToBack: restrictToBack,
        localAuthApi: localAuthApi,
        walletProtectionType: walletProtectionType,
      ),
    );
  }
}

class PinCodeView extends StatefulWidget {
  const PinCodeView({
    super.key,
    required this.title,
    required this.isValidCallback,
    this.restrictToBack = true,
    required this.localAuthApi,
    required this.walletProtectionType,
  });

  final String title;
  final VoidCallback isValidCallback;
  final bool restrictToBack;
  final LocalAuthApi localAuthApi;
  final WalletProtectionType walletProtectionType;

  @override
  State<StatefulWidget> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  final totalPermitedLoginAttempt = 3;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return PopScope(
      canPop: !widget.restrictToBack,
      child: BasePage(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBarHeight: Sizes.defaltAppBarHeight,
        titleAlignment: Alignment.topCenter,
        titleLeading: widget.restrictToBack ? null : const BackLeadingButton(),
        scrollView: false,
        body: PinCodeWidget(
          title: widget.title,
          deleteButton: Text(
            l10n.delete,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelButton: Text(
            l10n.cancel,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          cancelCallback: _onPasscodeCancelled,
          isValidCallback: () async {
            switch (widget.walletProtectionType) {
              case WalletProtectionType.pinCode:
                Navigator.pop(context);
                widget.isValidCallback.call();
              case WalletProtectionType.biometrics:
                throw ResponseMessage(
                  data: {
                    'error': 'invalid_format',
                    'error_description': 'The biomertics is not supported.',
                  },
                );
              case WalletProtectionType.FA2:
                final LocalAuthApi localAuthApi = LocalAuthApi();
                final authenticated = await localAuthApi.authenticate(
                  localizedReason: l10n.scanFingerprintToAuthenticate,
                );
                if (authenticated) {
                  Navigator.pop(context);
                  widget.isValidCallback.call();
                } else {
                  Navigator.pop(context);
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage: StateMessage.success(
                      showDialog: false,
                      stringMessage: l10n.authenticationFailed,
                    ),
                  );
                }
            }
          },
          onLoginAttempt: (loginAttempt, loginAttemptsRemaining) {
            if (loginAttemptsRemaining == 0) {
              Navigator.of(context).push(DeleteMyWalletPage.route());
            }
          },
        ),
      ),
    );
  }

  void _onPasscodeCancelled() {
    Navigator.of(context).maybePop();
  }
}
