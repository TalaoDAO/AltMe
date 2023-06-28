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
import 'package:walletconnect_flutter_v2/walletconnect_flutter_v2.dart';

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

    final walletConnectCubit = context.read<WalletConnectCubit>();

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
                          // : context
                          //     .read<WalletConnectCubit>()
                          //     .state
                          //     .currentDAppPeerMeta!
                          //     .name,
                          : walletConnectCubit.state.sessionProposalEvent!
                              .params.proposer.metadata.name,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: Sizes.spaceXLarge),
                    const Permissions(),
                    const SizedBox(height: Sizes.spaceXLarge),
                    if (connectionBridgeType ==
                        ConnectionBridgeType.walletconnect) ...[
                      Text(
                        walletConnectCubit.state.sessionProposalEvent!.params
                            .proposer.metadata.url,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: Sizes.spaceLarge),
                      ListView.builder(
                        itemCount: walletConnectCubit
                            .state
                            .sessionProposalEvent!
                            .params
                            .requiredNamespaces
                            .length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, i) {
                          final key = walletConnectCubit
                              .state
                              .sessionProposalEvent!
                              .params
                              .requiredNamespaces
                              .keys
                              .elementAt(i);

                          final RequiredNamespace ns = walletConnectCubit
                              .state
                              .sessionProposalEvent!
                              .params
                              .requiredNamespaces[key]!;

                          return Column(
                            children: [
                              Text('$key : '),
                              if (ns.chains != null) ...[
                                Column(
                                  children: [
                                    const Text('Chains'),
                                    Text(ns.chains!.toString()),
                                  ],
                                ),
                              ],
                              Column(
                                children: [
                                  const Text('Methods'),
                                  Text(ns.methods.toString()),
                                ],
                              ),
                              Column(
                                children: [
                                  const Text('Events'),
                                  Text(ns.events.toString()),
                                ],
                              ),
                              const SizedBox(height: Sizes.spaceNormal),
                            ],
                          );
                        },
                      )
                    ],
                    if (connectionBridgeType !=
                        ConnectionBridgeType.walletconnect) ...[
                      const SizedBox(height: Sizes.spaceXLarge),
                      SelectAccount(connectionBridgeType: connectionBridgeType),
                    ],
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
