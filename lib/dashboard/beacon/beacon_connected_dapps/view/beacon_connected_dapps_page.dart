import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class BeaconConnectedDappsPage extends StatelessWidget {
  const BeaconConnectedDappsPage({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  final String walletAddress;

  static Route route({required String walletAddress}) {
    return MaterialPageRoute<void>(
      builder: (_) => BeaconConnectedDappsPage(walletAddress: walletAddress),
      settings: const RouteSettings(name: '/BeaconConnectedDappsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BeaconConnectedDappsCubit(
        beacon: Beacon(),
        networkCubit: context.read<ManageNetworkCubit>(),
        client: DioClient(
          context.read<ManageNetworkCubit>().state.network.tzktUrl,
          Dio(),
        ),
        beaconRepository: BeaconRepository(
          secure_storage.getSecureStorage,
        ),
      ),
      child: BeaconConnectedDappsView(walletAddress: walletAddress),
    );
  }
}

class BeaconConnectedDappsView extends StatefulWidget {
  const BeaconConnectedDappsView({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  final String walletAddress;

  @override
  State<BeaconConnectedDappsView> createState() =>
      _BeaconConnectedDappsViewState();
}

class _BeaconConnectedDappsViewState extends State<BeaconConnectedDappsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context
            .read<BeaconConnectedDappsCubit>()
            .init(widget.walletAddress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<BeaconConnectedDappsCubit, BeaconConnectedDappsState>(
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
      },
      builder: (context, state) {
        String message = '';
        if (state.message != null) {
          final MessageHandler messageHandler = state.message!.messageHandler!;
          message = messageHandler.getMessage(context, messageHandler);
        }
        return BasePage(
          scrollView: false,
          title: l10n.tezos,
          titleLeading: const BackLeadingButton(),
          body: BackgroundCard(
            height: double.infinity,
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.spaceSmall),
            child: state.status == AppStatus.error
                ? ErrorView(
                    message: message,
                    onTap: () {
                      context
                          .read<BeaconConnectedDappsCubit>()
                          .init(widget.walletAddress);
                    },
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.spaceXSmall),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            l10n.address,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: Sizes.spaceXSmall),
                          MyText(
                            widget.walletAddress,
                            style:
                                Theme.of(context).textTheme.beaconWalletAddress,
                          ),
                          const SizedBox(height: Sizes.spaceXLarge),
                          if (state.xtzModel != null)
                            TransparentInkWell(
                              child: TokenItem(token: state.xtzModel!),
                              onTap: () {
                                // Navigator.of(context).push<void>(
                                //   SendReceiveHomePage.route(
                                //     selectedToken: state.xtzModel!,
                                //    beaconWalletAddress: widget.walletAddress,
                                //   ),
                                // );
                              },
                            )
                          else
                            const TokenItem(
                              token: TokenModel(
                                id: -1,
                                contractAddress: '',
                                name: 'Tezos',
                                symbol: 'XTZ',
                                icon:
                                    'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
                                balance: '0',
                                decimals: '6',
                                standard: 'fa1.2',
                                tokenUSDPrice: 0,
                                balanceInUSD: 0,
                              ),
                            ),
                          const SizedBox(height: Sizes.spaceNormal),
                          Center(
                            child: ShareButton(
                              onTap: () {
                                Navigator.of(context).push<void>(
                                  ReceivePage.route(
                                    accountAddress: widget.walletAddress,
                                    item: 'XTZ or NFTs',
                                    description: l10n.beaconShareMessage,
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: Sizes.spaceXLarge),
                          Text(
                            l10n.connection,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: Sizes.spaceNormal),
                          if (state.peers.isEmpty)
                            Center(
                              child: Text(
                                l10n.noDappConnected,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          else
                            ListView.separated(
                              itemCount: state.peers.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, i) {
                                return TransparentInkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            state.peers[i].name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .dappName,
                                          ),
                                        ),
                                        Icon(
                                          Icons.chevron_right,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                        )
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.of(context).push<void>(
                                      BeaconRightPage.route(
                                        p2pPeer: state.peers[i],
                                      ),
                                    );
                                    await context
                                        .read<BeaconConnectedDappsCubit>()
                                        .getPeers(widget.walletAddress);
                                  },
                                );
                              },
                              separatorBuilder: (_, __) => Divider(
                                height: 0.1,
                                color:
                                    Theme.of(context).colorScheme.borderColor,
                              ),
                            )
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
