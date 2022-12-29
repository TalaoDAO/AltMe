import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/route/route.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:key_generator/key_generator.dart';

class OperationPage extends StatelessWidget {
  const OperationPage({
    Key? key,
    required this.connectionBridgeType,
  }) : super(key: key);

  final ConnectionBridgeType connectionBridgeType;

  static Route route({required ConnectionBridgeType connectionBridgeType}) {
    return MaterialPageRoute<void>(
      builder: (_) => OperationPage(
        connectionBridgeType: connectionBridgeType,
      ),
      settings: const RouteSettings(name: OPERATION_PAGE),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OperationCubit(
        beacon: Beacon(),
        beaconCubit: context.read<BeaconCubit>(),
        walletCubit: context.read<WalletCubit>(),
        dioClient: DioClient('', Dio()),
        keyGenerator: KeyGenerator(),
        nftCubit: context.read<NftCubit>(),
        tokensCubit: context.read<TokensCubit>(),
        walletConnectCubit: context.read<WalletConnectCubit>(),
      ),
      child: OperationView(connectionBridgeType: connectionBridgeType),
    );
  }
}

class OperationView extends StatefulWidget {
  const OperationView({
    Key? key,
    required this.connectionBridgeType,
  }) : super(key: key);

  final ConnectionBridgeType connectionBridgeType;

  @override
  State<OperationView> createState() => _OperationViewState();
}

class _OperationViewState extends State<OperationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context
            .read<OperationCubit>()
            .getUsdPrice(widget.connectionBridgeType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final BeaconRequest? beaconRequest =
        context.read<BeaconCubit>().state.beaconRequest;

    final WalletConnectState walletConnectState =
        context.read<WalletConnectCubit>().state;

    late String dAppName;
    late String sender;
    late String reciever;

    late String symbol;

    switch (widget.connectionBridgeType) {
      case ConnectionBridgeType.beacon:
        dAppName = beaconRequest!.request!.appMetadata!.name!;
        symbol = 'XTZ';
        sender = beaconRequest.request!.sourceAddress!;
        reciever = beaconRequest.operationDetails!.first.destination!;
        break;

      case ConnectionBridgeType.walletconnect:
        dAppName = walletConnectState.currentDAppPeerMeta!.name;
        symbol = 'ETH';
        sender = walletConnectState.transaction!.from;
        reciever = walletConnectState.transaction!.to ?? '';
        break;
    }

    return BlocConsumer<OperationCubit, OperationState>(
      listener: (context, state) {
        if (state.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (state.message != null) {
          if (state.status != AppStatus.errorWhileFetching) {
            AlertMessage.showStateMessage(
              context: context,
              stateMessage: state.message!,
            );
          }
        }

        if (state.status == AppStatus.success) {
          Navigator.of(context).pop();
        }

        if (state.status == AppStatus.goBack) {
          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        String message = '';
        if (state.message != null) {
          final MessageHandler messageHandler = state.message!.messageHandler!;
          message = messageHandler.getMessage(context, messageHandler);
        }

        return WillPopScope(
          onWillPop: () async {
            context.read<OperationCubit>().rejectOperation(
                  connectionBridgeType: widget.connectionBridgeType,
                );
            return true;
          },
          child: BasePage(
            scrollView: false,
            title: l10n.confirm,
            titleLeading: BackLeadingButton(
              onPressed: () => context.read<OperationCubit>().rejectOperation(
                    connectionBridgeType: widget.connectionBridgeType,
                  ),
            ),
            body: BackgroundCard(
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              child: state.status == AppStatus.errorWhileFetching
                  ? ErrorView(
                      message: message,
                      onTap: () {
                        context
                            .read<OperationCubit>()
                            .getOtherPrices(widget.connectionBridgeType);
                      },
                    )
                  : SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(Sizes.spaceXSmall),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              dAppName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: Sizes.spaceSmall),
                            MyText(
                              '''${state.amount.toStringAsFixed(6).formatNumber()} $symbol''',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                            ),
                            const SizedBox(height: Sizes.space2XSmall),
                            Text(
                              l10n.amount,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: Sizes.spaceSmall),
                            SenderReceiver(
                              from: sender,
                              to: reciever,
                              dAppName: dAppName,
                            ),
                            const SizedBox(height: Sizes.spaceNormal),
                            Image.asset(
                              IconStrings.arrowDown,
                              height: Sizes.icon3x,
                            ),
                            const SizedBox(height: Sizes.spaceNormal),
                            FeeDetails(
                              amount: state.amount,
                              symbol: symbol,
                              tokenUSDRate: state.usdRate,
                              fee: state.fee,
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
                      text: l10n.send,
                      onPressed: state.status != AppStatus.idle
                          ? null
                          : () {
                              context
                                  .read<OperationCubit>()
                                  .sendOperataion(widget.connectionBridgeType);
                            },
                    ),
                    const SizedBox(height: 8),
                    MyOutlinedButton(
                      borderRadius: Sizes.normalRadius,
                      text: l10n.cancel,
                      onPressed: () {
                        context.read<OperationCubit>().rejectOperation(
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
