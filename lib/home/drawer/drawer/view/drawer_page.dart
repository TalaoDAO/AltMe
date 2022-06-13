import 'package:altme/app/app.dart';
import 'package:altme/home/drawer/secret_key/view/secret_key_view.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/pin_code/pin_code.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DrawerCubit(),
      child: DrawerView(localAuthApi: LocalAuthApi()),
    );
  }
}

class DrawerView extends StatelessWidget {
  const DrawerView({Key? key, required this.localAuthApi}) : super(key: key);

  final LocalAuthApi localAuthApi;

  //method for set new pin code
  Future<void> setNewPinCode(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    Navigator.of(context).pop();
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
    final drawerCubit = context.read<DrawerCubit>();

    final profileModel = context.read<ProfileCubit>().state.model;

    final firstName = profileModel.firstName;
    final lastName = profileModel.lastName;
    final isEnterprise = profileModel.isEnterprise;

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        backgroundColor: Theme.of(context).colorScheme.drawerBackground,
        child: SafeArea(
          child: SingleChildScrollView(
            child: BlocBuilder<DrawerCubit, DrawerState>(
              bloc: drawerCubit,
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const DrawerCloseButton(),
                    const SizedBox(height: 20),
                    const AltMeLogo(size: Sizes.logoLarge),
                    if (firstName.isNotEmpty || lastName.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: MyText(
                          '$firstName $lastName',
                          style: Theme.of(context).textTheme.infoTitle,
                        ),
                      ),
                    DrawerItem(
                      icon: IconStrings.reset,
                      title: l10n.resetWalletButton,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                              context: context,
                              builder: (_) => ConfirmDialog(
                                title: l10n.resetWalletConfirmationText,
                                yes: l10n.showDialogYes,
                                no: l10n.showDialogNo,
                                dialogColor:
                                    Theme.of(context).colorScheme.error,
                                icon: IconStrings.trash,
                              ),
                            ) ??
                            false;
                        if (confirm) {
                          final pinCode = await getSecureStorage
                              .get(SecureStorageKeys.pinCode);
                          if (pinCode?.isEmpty ?? true) {
                            await context.read<WalletCubit>().resetWallet();
                          } else {
                            await Navigator.of(context).push<void>(
                              PinCodePage.route(
                                isValidCallback: () =>
                                    context.read<WalletCubit>().resetWallet(),
                                restrictToBack: false,
                              ),
                            );
                          }
                        }
                      },
                    ),
                    DrawerItem(
                      icon: IconStrings.restore,
                      title: l10n.restoreCredential,
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                title: l10n.warningDialogTitle,
                                subtitle: l10n
                                    .recoveryCredentialWarningDialogSubtitle,
                                yes: l10n.showDialogYes,
                                no: l10n.showDialogNo,
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          await Navigator.of(context)
                              .push<void>(RecoveryCredentialPage.route());
                        }
                      },
                    ),
                    DrawerItem(
                      icon: IconStrings.terms,
                      title: l10n.privacyTitle,
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () =>
                          Navigator.of(context).push<void>(PrivacyPage.route()),
                    ),
                    DrawerItem(
                      icon: IconStrings.fingerprint,
                      title: l10n.loginWithBiometrics,
                      trailing: Switch(
                        onChanged: (value) async {
                          final hasBiometrics =
                              await localAuthApi.hasBiometrics();
                          if (hasBiometrics) {
                            final result = await localAuthApi.authenticate(
                              localizedReason:
                                  l10n.scanFingerprintToAuthenticate,
                            );
                            if (result) {
                              await getSecureStorage.set(
                                SecureStorageKeys.fingerprintEnabled,
                                value.toString(),
                              );
                              drawerCubit.setFingerprintEnabled(enabled: value);
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
                        value: state.isBiometricsEnable,
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    DrawerItem(
                      icon: IconStrings.terms,
                      title: l10n.onBoardingTosTitle,
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () =>
                          Navigator.of(context).push<void>(TermsPage.route()),
                    ),
                    DrawerItem(
                      icon: IconStrings.key,
                      title: l10n.changePinCode,
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () async {
                        final pinCode = await getSecureStorage
                            .get(SecureStorageKeys.pinCode);
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
                    if (isEnterprise)
                      const SizedBox.shrink()
                    else
                      DrawerItem(
                        icon: IconStrings.key,
                        title: l10n.recoveryKeyTitle,
                        trailing: Icon(
                          Icons.chevron_right,
                          size: 24,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => ConfirmDialog(
                                  title: l10n.warningDialogTitle,
                                  subtitle: l10n.warningDialogSubtitle,
                                  yes: l10n.showDialogYes,
                                  no: l10n.showDialogNo,
                                ),
                              ) ??
                              false;

                          if (confirm) {
                            final pinCode = await getSecureStorage
                                .get(SecureStorageKeys.pinCode);
                            if (pinCode?.isEmpty ?? true) {
                              await setNewPinCode(context, l10n);
                            } else {
                              await Navigator.of(context).push<void>(
                                PinCodePage.route(
                                  isValidCallback: () => Navigator.of(context)
                                      .push<void>(RecoveryKeyPage.route()),
                                  restrictToBack: false,
                                ),
                              );
                            }
                          }
                        },
                      ),
                    DrawerItem(
                      icon: IconStrings.key,
                      title: l10n.exportSecretKey,
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => ConfirmDialog(
                                title: l10n.warningDialogTitle,
                                subtitle: l10n.warningDialogSubtitle,
                                yes: l10n.showDialogYes,
                                no: l10n.showDialogNo,
                              ),
                            ) ??
                            false;

                        if (confirm) {
                          final pinCode = await getSecureStorage
                              .get(SecureStorageKeys.pinCode);
                          if (pinCode?.isEmpty ?? true) {
                            await Navigator.of(context)
                                .pushReplacement<void, void>(
                              SecretKeyPage.route(),
                            );
                          } else {
                            await Navigator.of(context).push<void>(
                              PinCodePage.route(
                                isValidCallback: () => Navigator.of(context)
                                    .pushReplacement<void, void>(
                                  SecretKeyPage.route(),
                                ),
                                restrictToBack: false,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
