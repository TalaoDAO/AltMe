import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BeaconSignPayloadPage extends StatelessWidget {
  const BeaconSignPayloadPage({
    Key? key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const BeaconSignPayloadPage(),
      settings: const RouteSettings(name: '/BeaconSignPayloadPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BeaconSignPayloadCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        qrCodeScanCubit: context.read<QRCodeScanCubit>(),
      ),
      child: const BeaconSignPayloadView(),
    );
  }
}

class BeaconSignPayloadView extends StatefulWidget {
  const BeaconSignPayloadView({
    Key? key,
  }) : super(key: key);

  @override
  State<BeaconSignPayloadView> createState() => _BeaconSignPayloadViewState();
}

class _BeaconSignPayloadViewState extends State<BeaconSignPayloadView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<BeaconSignPayloadCubit>().decodeMessage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BeaconRequest beaconRequest =
        context.read<BeaconCubit>().state.beaconRequest!;

    final l10n = context.l10n;
    return BlocConsumer<BeaconSignPayloadCubit, BeaconSignPayloadState>(
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
          Navigator.of(context).pop();
        }

        if (state.status == AppStatus.goBack) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            context.read<BeaconSignPayloadCubit>().rejectSigning();
            return true;
          },
          child: BasePage(
            scrollView: false,
            title: l10n.confirm_sign,
            titleLeading: BackLeadingButton(
              onPressed: () =>
                  context.read<BeaconSignPayloadCubit>().rejectSigning(),
            ),
            body: BackgroundCard(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(Sizes.spaceXSmall),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        beaconRequest.request!.appMetadata!.name!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceXLarge),
                      const Permissions(),
                      const SizedBox(height: Sizes.spaceXLarge),
                      Text(
                        l10n.cryptoAccount,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      MyText(
                        beaconRequest.request!.sourceAddress!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.beaconPayload,
                      ),
                      const SizedBox(height: Sizes.spaceXLarge),
                      Text(
                        l10n.payload_to_sign,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceXSmall),
                      Text(
                        state.payloadMessage ?? '',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.beaconPayload,
                      ),
                      const SizedBox(height: Sizes.spaceNormal),
                    ],
                  ),
                ),
              ),
            ),
            navigation: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: Sizes.spaceSmall,
                  right: Sizes.spaceSmall,
                  bottom: Sizes.spaceSmall,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MyGradientButton(
                      verticalSpacing: 15,
                      borderRadius: Sizes.normalRadius,
                      text: l10n.sign,
                      onPressed: state.encodedPaylod == null
                          ? null
                          : () {
                              context.read<BeaconSignPayloadCubit>().sign();
                            },
                    ),
                    const SizedBox(height: 8),
                    MyOutlinedButton(
                      borderRadius: Sizes.normalRadius,
                      text: l10n.cancel,
                      onPressed: () {
                        context.read<BeaconSignPayloadCubit>().rejectSigning();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
