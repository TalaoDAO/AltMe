import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/route/route.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class ConfirmConnectionPage extends StatelessWidget {
  const ConfirmConnectionPage({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  static Route<dynamic> route({
    required ConnectionBridgeType connectionBridgeType,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => ConfirmConnectionPage(
        connectionBridgeType: connectionBridgeType,
      ),
      settings: const RouteSettings(name: CONFIRM_CONNECTION_PAGE),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConfirmConnectionCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        connectedDappRepository:
            ConnectedDappRepository(secure_storage.getSecureStorage),
        walletConnectCubit: context.read<WalletConnectCubit>(),
      ),
      child: ConfirmConnectionView(connectionBridgeType: connectionBridgeType),
    );
  }
}

class ConfirmConnectionView extends StatelessWidget {
  const ConfirmConnectionView({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<ConfirmConnectionCubit, ConfirmConnectionState>(
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
      child: WillPopScope(
        onWillPop: () async {
          context.read<ConfirmConnectionCubit>().rejectConnection(
                connectionBridgeType: connectionBridgeType,
              );
          return true;
        },
        child: BasePage(
          scrollView: false,
          title: l10n.connection,
          titleLeading: BackLeadingButton(
            onPressed: () =>
                context.read<ConfirmConnectionCubit>().rejectConnection(
                      connectionBridgeType: connectionBridgeType,
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
                      connectionBridgeType == ConnectionBridgeType.beacon
                          ? context
                              .read<BeaconCubit>()
                              .state
                              .beaconRequest!
                              .request!
                              .appMetadata!
                              .name!
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
                    SelectAccount(connectionBridgeType: connectionBridgeType),
                    const SizedBox(
                      height: Sizes.spaceNormal,
                    ),
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
                  BlocBuilder<WalletCubit, WalletState>(
                    builder: (context, walletState) {
                      return MyGradientButton(
                        verticalSpacing: 15,
                        borderRadius: Sizes.normalRadius,
                        text: l10n.connect,
                        onPressed: walletState.currentAccount!.blockchainType
                                    .connectionBridge !=
                                connectionBridgeType
                            ? null
                            : () {
                                context.read<ConfirmConnectionCubit>().connect(
                                      connectionBridgeType:
                                          connectionBridgeType,
                                    );
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  MyOutlinedButton(
                    borderRadius: Sizes.normalRadius,
                    text: l10n.cancel,
                    onPressed: () {
                      context.read<ConfirmConnectionCubit>().rejectConnection(
                            connectionBridgeType: connectionBridgeType,
                          );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
