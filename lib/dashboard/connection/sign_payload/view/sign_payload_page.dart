import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/route/route.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class SignPayloadPage extends StatelessWidget {
  const SignPayloadPage({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  static Route<dynamic> route({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => SignPayloadPage(
        connectionBridgeType: connectionBridgeType,
      ),
      settings: const RouteSettings(name: SIGN_PAYLOAD_PAGE),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignPayloadCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        qrCodeScanCubit: context.read<QRCodeScanCubit>(),
        walletConnectCubit: context.read<WalletConnectCubit>(),
        connectedDappRepository: ConnectedDappRepository(
          secure_storage.getSecureStorage,
        ),
      ),
      child: SignPayloadView(connectionBridgeType: connectionBridgeType),
    );
  }
}

class SignPayloadView extends StatefulWidget {
  const SignPayloadView({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  @override
  State<SignPayloadView> createState() => _SignPayloadViewState();
}

class _SignPayloadViewState extends State<SignPayloadView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<SignPayloadCubit>().decodeMessage(
            connectionBridgeType: widget.connectionBridgeType,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final BeaconRequest? beaconRequest =
        context.read<BeaconCubit>().state.beaconRequest;

    final l10n = context.l10n;
    return BlocConsumer<SignPayloadCubit, SignPayloadState>(
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
            context.read<SignPayloadCubit>().rejectSigning(
                  connectionBridgeType: widget.connectionBridgeType,
                );
            return true;
          },
          child: BasePage(
            scrollView: false,
            title: l10n.confirm_sign,
            titleLeading: BackLeadingButton(
              onPressed: () => context.read<SignPayloadCubit>().rejectSigning(
                    connectionBridgeType: widget.connectionBridgeType,
                  ),
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
                        widget.connectionBridgeType ==
                                ConnectionBridgeType.beacon
                            ? beaconRequest!.request!.appMetadata!.name!
                            : context
                                .read<WalletConnectCubit>()
                                .state
                                .currentDAppPeerMeta!
                                .name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: Sizes.spaceXLarge),
                      const Permissions(),
                      const SizedBox(height: Sizes.spaceXLarge),
                      if (widget.connectionBridgeType ==
                          ConnectionBridgeType.beacon) ...[
                        Text(
                          l10n.cryptoAccount,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: Sizes.spaceXSmall),
                        MyText(
                          beaconRequest!.request!.sourceAddress!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.beaconPayload,
                        ),
                        const SizedBox(height: Sizes.spaceXLarge),
                      ],
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
                      onPressed: state.payloadMessage == null
                          ? null
                          : () {
                              context.read<SignPayloadCubit>().sign(
                                    connectionBridgeType:
                                        widget.connectionBridgeType,
                                  );
                            },
                    ),
                    const SizedBox(height: 8),
                    MyOutlinedButton(
                      borderRadius: Sizes.normalRadius,
                      text: l10n.cancel,
                      onPressed: () {
                        context.read<SignPayloadCubit>().rejectSigning(
                              connectionBridgeType: widget.connectionBridgeType,
                            );
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
