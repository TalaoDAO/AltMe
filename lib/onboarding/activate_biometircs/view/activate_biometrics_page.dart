import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:altme/route/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ActiviateBiometricsPage extends StatelessWidget {
  const ActiviateBiometricsPage({
    super.key,
    required this.isFromOnboarding,
    required this.onAction,
    required this.localAuthApi,
  });

  final bool isFromOnboarding;
  final void Function({required bool isEnabled}) onAction;
  final LocalAuthApi localAuthApi;

  static Route<dynamic> route({
    required void Function({required bool isEnabled}) onAction,
    required bool isFromOnboarding,
    required LocalAuthApi localAuthApi,
  }) => RightToLeftRoute<void>(
    builder: (context) => ActiviateBiometricsPage(
      onAction: onAction,
      isFromOnboarding: isFromOnboarding,
      localAuthApi: localAuthApi,
    ),
    settings: const RouteSettings(name: '/activiateBiometricsPage'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ActiveBiometricsCubit(profileCubit: context.read<ProfileCubit>()),
      child: ActivateBiometricsView(
        isFromOnboarding: isFromOnboarding,
        onAction: onAction,
        localAuthApi: localAuthApi,
      ),
    );
  }
}

class ActivateBiometricsView extends StatefulWidget {
  const ActivateBiometricsView({
    super.key,
    required this.isFromOnboarding,
    required this.onAction,
    required this.localAuthApi,
  });

  final bool isFromOnboarding;
  final void Function({required bool isEnabled}) onAction;
  final LocalAuthApi localAuthApi;

  @override
  State<ActivateBiometricsView> createState() => _ActivateBiometricsViewState();
}

class _ActivateBiometricsViewState extends State<ActivateBiometricsView> {
  @override
  void initState() {
    context.read<ActiveBiometricsCubit>().load();
    super.initState();
  }

  bool get byPassScreen => !Parameters.walletHandlesCrypto;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ActiveBiometricsCubit, bool>(
      builder: (context, isEnabled) {
        return BasePage(
          scrollView: false,
          padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceXSmall),
          titleLeading: const BackLeadingButton(),
          body: Column(
            children: [
              if (widget.isFromOnboarding) ...[
                MStepper(step: 1, totalStep: byPassScreen ? 2 : 3),
                const Spacer(),
              ],
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
              const SizedBox(height: Sizes.spaceSmall),
              BiometricsSwitch(
                value: isEnabled,
                onChange: (value) async {
                  final hasBiometrics = await widget.localAuthApi
                      .hasBiometrics();

                  if (hasBiometrics) {
                    final result = await widget.localAuthApi.authenticate(
                      localizedReason: l10n.scanFingerprintToAuthenticate,
                    );

                    if (result) {
                      context.read<ActiveBiometricsCubit>().updateSwitch(
                        value: value,
                      );
                    }
                  } else {
                    await showDialog<bool>(
                      context: context,
                      builder: (context) => ConfirmDialog(
                        title: l10n.biometricsNotSupported,
                        subtitle:
                            l10n.deviceDoNotSupportBiometricsAuthentication,
                        yes: l10n.ok,
                      ),
                    );
                  }
                },
              ),
              const Spacer(flex: 5),
              const SizedBox(height: Sizes.spaceXSmall),
            ],
          ),
          navigation: Padding(
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: MyElevatedButton(
              text: l10n.next,
              onPressed: isEnabled
                  ? () => widget.onAction.call(isEnabled: true)
                  : null,
            ),
          ),
        );
      },
    );
  }
}
