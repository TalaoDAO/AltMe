import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/route/route.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reown_walletkit/reown_walletkit.dart';
import 'package:secure_storage/secure_storage.dart';

class OperationPage extends StatelessWidget {
  const OperationPage({
    super.key,
    required this.connectionBridgeType,
  });

  final ConnectionBridgeType connectionBridgeType;

  static Route<dynamic> route({
    required ConnectionBridgeType connectionBridgeType,
  }) {
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
        dioClient: DioClient(
          secureStorageProvider: getSecureStorage,
          dio: Dio(),
        ),
        keyGenerator: KeyGenerator(),
        nftCubit: context.read<NftCubit>(),
        tokensCubit: context.read<TokensCubit>(),
        walletConnectCubit: context.read<WalletConnectCubit>(),
        connectedDappRepository: ConnectedDappRepository(getSecureStorage),
        manageNetworkCubit: context.read<ManageNetworkCubit>(),
      ),
      child: OperationView(connectionBridgeType: connectionBridgeType),
    );
  }
}

class OperationView extends StatefulWidget {
  const OperationView({
    super.key,
    required this.connectionBridgeType,
  });

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
            .initialise(widget.connectionBridgeType);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
        late String sender;
        late String reciever;
        late String? symbol;

        bool isSmartContract = false;

        final BeaconRequest? beaconRequest =
            context.read<BeaconCubit>().state.beaconRequest;

        final WalletConnectState walletConnectState =
            context.read<WalletConnectCubit>().state;

        final List<OperationDetails>? tezosOperationDetails =
            walletConnectState.operationDetails;

        final Transaction? transaction = walletConnectState.transaction;

        if (beaconRequest != null || tezosOperationDetails != null) {
          if (beaconRequest != null) {
            symbol = 'XTZ';
            sender = beaconRequest.request!.sourceAddress!;
            reciever = beaconRequest.operationDetails!.first.destination!;
          } else {
            symbol = 'XTZ';
            sender = tezosOperationDetails!.first.source!;
            reciever = tezosOperationDetails.first.destination!;
          }

          if (isContract(reciever)) isSmartContract = true;
        } else if (transaction != null) {
          symbol = state.cryptoAccountData?.blockchainType.symbol;
          sender = transaction.from!.toString();
          reciever = transaction.to!.toString();
        }

        String message = '';
        if (state.message != null) {
          final MessageHandler messageHandler = state.message!.messageHandler!;
          message = messageHandler.getMessage(context, messageHandler);
        }

        return PopScope(
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            context.read<OperationCubit>().rejectOperation(
                  connectionBridgeType: widget.connectionBridgeType,
                );
            if (didPop) Navigator.of(context).pop();
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
                            .initialise(widget.connectionBridgeType);
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
                              state.dAppName,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: Sizes.spaceSmall),
                            MyText(
                              '''${state.amount.decimalNumber(6).formatNumber} ${symbol ?? ''}''',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
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
                              dAppName: state.dAppName,
                            ),
                            const SizedBox(height: Sizes.spaceNormal),
                            Image.asset(
                              IconStrings.arrowDown,
                              height: Sizes.icon3x,
                            ),
                            const SizedBox(height: Sizes.spaceNormal),
                            if (symbol != null)
                              FeeDetails(
                                amount: state.amount,
                                symbol: symbol,
                                tokenUSDRate: state.usdRate,
                                totalFee: state.totalFee,
                                bakerFee: state.bakerFee,
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
                    MyElevatedButton(
                      verticalSpacing: 15,
                      borderRadius: Sizes.normalRadius,
                      text: isSmartContract ? l10n.confirm : l10n.send,
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
                      text: isSmartContract ? l10n.reject : l10n.cancel,
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
