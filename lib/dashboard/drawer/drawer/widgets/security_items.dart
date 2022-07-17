import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class SecurityItems extends StatelessWidget {
  const SecurityItems({
    Key? key,
    required this.localAuthApi,
    required this.drawerState,
  }) : super(key: key);

  final LocalAuthApi localAuthApi;
  final DrawerState drawerState;

  //method for set new pin code
  Future<void> setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push<void>(
      EnterNewPinCodePage.route(
        isValidCallback: () {
          Navigator.of(context).pop();
          AlertMessage.showStringMessage(
            context: context,
            message: l10n.yourPinCodeChangedSuccessfully,
            messageType: MessageType.success,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.security,
          style: Theme.of(context).textTheme.drawerMenu,
        ),
        const SizedBox(height: 5),
        BackgroundCard(
          color: Theme.of(context).colorScheme.drawerSurface,
          child: Column(
            children: [
              DrawerItem(
                icon: IconStrings.shieldTick,
                title: l10n.changePinCode,
                onTap: () async {
                  final pinCode =
                      await getSecureStorage.get(SecureStorageKeys.pinCode);
                  if (pinCode?.isEmpty ?? true) {
                    await setNewPinCode(context, l10n);
                  } else {
                    await Navigator.of(context).push<void>(
                      PinCodePage.route(
                        isValidCallback: () =>
                            setNewPinCode.call(context, l10n),
                        restrictToBack: false,
                      ),
                    );
                  }
                },
              ),
              const DrawerItemDivider(),
              DrawerItem(
                icon: IconStrings.fingerprint,
                title: l10n.loginWithBiometrics,
                trailing: SizedBox(
                  height: 25,
                  child: Switch(
                    onChanged: (value) async {
                      final hasBiometrics = await localAuthApi.hasBiometrics();
                      if (hasBiometrics) {
                        final result = await localAuthApi.authenticate(
                          localizedReason: l10n.scanFingerprintToAuthenticate,
                        );
                        if (result) {
                          await getSecureStorage.set(
                            SecureStorageKeys.fingerprintEnabled,
                            value.toString(),
                          );
                          context
                              .read<DrawerCubit>()
                              .setFingerprintEnabled(enabled: value);
                          await showDialog<bool>(
                            context: context,
                            builder: (context) => InfoDialog(
                              title: value
                                  ? l10n.biometricsEnabledMessage
                                  : l10n.biometricsDisabledMessage,
                              button: l10n.ok,
                            ),
                          );
                        }
                      } else {
                        await showDialog<bool>(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: l10n.biometricsNotSupported,
                            subtitle: l10n
                                .yourDeviceDoseNotSupportBiometricsAuthentication, // ignore: lines_longer_than_80_chars
                            yes: l10n.ok,
                          ),
                        );
                      }
                    },
                    value: drawerState.isBiometricsEnabled,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                l10n.loginWithBiometricsMessage,
                style: Theme.of(context).textTheme.biometricMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
