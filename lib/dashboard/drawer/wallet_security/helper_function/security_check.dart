import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> securityCheck({
  required BuildContext context,
  required String title,
  required VoidCallback onSuccess,
  required LocalAuthApi localAuthApi,
}) async {
  final l10n = context.l10n;
  final profile = context.read<ProfileCubit>().state.model;
  final walletProtectionType = profile.walletProtectionType;

  switch (walletProtectionType) {
    case WalletProtectionType.pinCode:
    case WalletProtectionType.FA2:
      await Navigator.of(context).push<void>(
        PinCodePage.route(
          title: title,
          isValidCallback: onSuccess.call,
          restrictToBack: false,
          walletProtectionType: walletProtectionType,
        ),
      );
    case WalletProtectionType.biometrics:
      final authenticated = await localAuthApi.authenticate(
        localizedReason: l10n.scanFingerprintToAuthenticate,
      );
      if (authenticated) {
        onSuccess.call();
      } else {
        AlertMessage.showStateMessage(
          context: context,
          stateMessage: StateMessage.error(
            showDialog: true,
            stringMessage: l10n.authenticationFailed,
          ),
        );
      }
  }
}
