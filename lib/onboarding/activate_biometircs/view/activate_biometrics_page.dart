import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/import_wallet/import_wallet.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/route/route.dart';
import 'package:altme/splash/splash.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';
import 'package:secure_storage/secure_storage.dart';

class ActiviateBiometricsPage extends StatelessWidget {
  const ActiviateBiometricsPage({
    super.key,
    required this.routeType,
  });

  final WalletRouteType routeType;

  static Route<dynamic> route({required WalletRouteType routeType}) =>
      RightToLeftRoute<void>(
        builder: (context) => ActiviateBiometricsPage(
          routeType: routeType,
        ),
        settings: const RouteSettings(name: '/activiateBiometricsPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BiometricsCubit(
        secureStorageProvider: getSecureStorage,
        didCubit: context.read<DIDCubit>(),
        didKitProvider: DIDKitProvider(),
        keyGenerator: KeyGenerator(),
        homeCubit: context.read<HomeCubit>(),
        walletCubit: context.read<WalletCubit>(),
        splashCubit: context.read<SplashCubit>(),
      ),
      child: ActivateBiometricsView(
        localAuthApi: LocalAuthApi(),
        routeType: routeType,
      ),
    );
  }
}

class ActivateBiometricsView extends StatelessWidget {
  const ActivateBiometricsView({
    super.key,
    required this.localAuthApi,
    required this.routeType,
  });
  final LocalAuthApi localAuthApi;
  final WalletRouteType routeType;

  bool get byPassScreen => !Parameters.hasCryptoCallToAction;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: BlocConsumer<BiometricsCubit, BiometricsState>(
        listener: (context, state) {
          if (state.status == AppStatus.loading) {
            LoadingView().show(context: context);
          } else {
            LoadingView().hide();
          }

          if (state.message != null) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }

          if (state.status == AppStatus.success) {
            context.read<AltmeChatSupportCubit>().init();
            Navigator.pushAndRemoveUntil<void>(
              context,
              WalletReadyPage.route(),
              (Route<dynamic> route) => route.isFirst,
            );
          }
        },
        builder: (context, state) {
          return BasePage(
            scrollView: false,
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.spaceXSmall,
            ),
            titleLeading: const BackLeadingButton(),
            body: Column(
              children: [
                MStepper(
                  step: 2,
                  totalStep: byPassScreen ? 2 : 3,
                ),
                const Spacer(),
                Text(
                  l10n.activateBiometricsTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Image.asset(
                  ImageStrings.biometrics,
                  fit: BoxFit.fitHeight,
                  height: MediaQuery.of(context).size.longestSide * 0.26,
                ),
                const SizedBox(
                  height: Sizes.spaceSmall,
                ),
                BiometricsSwitch(
                  value: state.isBiometricsEnabled,
                  onChange: (value) async {
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
                            .read<BiometricsCubit>()
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
                              .yourDeviceDoseNotSupportBiometricsAuthentication,
                          yes: l10n.ok,
                        ),
                      );
                    }
                  },
                ),
                const Spacer(
                  flex: 5,
                ),
                MyGradientButton(
                  text: l10n.next,
                  onPressed: () async {
                    if (routeType == WalletRouteType.create) {
                      if (byPassScreen) {
                        final mnemonic = bip39.generateMnemonic().split(' ');
                        await context
                            .read<BiometricsCubit>()
                            .generateSSIAndCryptoAccount(mnemonic);
                      } else {
                        await Navigator.of(context)
                            .push<void>(OnBoardingGenPhrasePage.route());
                      }
                    } else {
                      await Navigator.of(context).push<void>(
                        ImportWalletPage.route(
                          isFromOnboarding: true,
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: Sizes.spaceXSmall,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
