import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart' as secure_storage;

class ConnectedDappsPage extends StatelessWidget {
  const ConnectedDappsPage({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  final String walletAddress;

  static Route route({required String walletAddress}) {
    return MaterialPageRoute<void>(
      builder: (_) => ConnectedDappsPage(walletAddress: walletAddress),
      settings: const RouteSettings(name: '/ConnectedDappsPage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectedDappsCubit(
        beacon: Beacon(),
        networkCubit: context.read<ManageNetworkCubit>(),
        client: DioClient(
          context.read<ManageNetworkCubit>().state.network.apiUrl,
          Dio(),
        ),
        connectedDappRepository: ConnectedDappRepository(
          secure_storage.getSecureStorage,
        ),
      ),
      child: ConnectedDappsView(walletAddress: walletAddress),
    );
  }
}

class ConnectedDappsView extends StatefulWidget {
  const ConnectedDappsView({
    Key? key,
    required this.walletAddress,
  }) : super(key: key);

  final String walletAddress;

  @override
  State<ConnectedDappsView> createState() => _ConnectedDappsViewState();
}

class _ConnectedDappsViewState extends State<ConnectedDappsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        await context.read<ConnectedDappsCubit>().init(widget.walletAddress);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<ConnectedDappsCubit, ConnectedDappsState>(
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
          title: l10n.connectedApps,
          titleAlignment: Alignment.topCenter,
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
                          .read<ConnectedDappsCubit>()
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
                          Text(
                            l10n.connection,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: Sizes.spaceNormal),
                          if (state.savedDapps.isEmpty)
                            Center(
                              child: Text(
                                l10n.noDappConnected,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            )
                          else
                            ListView.separated(
                              itemCount: state.savedDapps.length,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, i) {
                                final SavedDappData savedDappData =
                                    state.savedDapps[i];
                                return TransparentInkWell(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            savedDappData.blockchainType ==
                                                    BlockchainType.tezos
                                                ? savedDappData.peer!.name
                                                : savedDappData.wcSessionStore!
                                                    .remotePeerMeta.name,
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
                                      RightsPage.route(
                                        savedDappData: state.savedDapps[i],
                                      ),
                                    );
                                    await context
                                        .read<ConnectedDappsCubit>()
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
