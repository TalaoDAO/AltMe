import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendReceiveHomePage extends StatefulWidget {
  const SendReceiveHomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SendReceiveHomePage(),
      settings: const RouteSettings(name: '/sendReceiveHomePage'),
    );
  }

  @override
  State<SendReceiveHomePage> createState() => _SendReceiveHomePageState();
}

class _SendReceiveHomePageState extends State<SendReceiveHomePage> {
  late final sendReceiveHomeCubit = SendReceiveHomeCubit(
    client: DioClient(
      context.read<ManageNetworkCubit>().state.network.tzktUrl,
      Dio(),
    ),
    walletCubit: context.read<WalletCubit>(),
  );

  @override
  void initState() {
    Future.microtask(
      sendReceiveHomeCubit.getOperations,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SendReceiveHomeCubit>(
      create: (_) => sendReceiveHomeCubit,
      child: const _SendReceiveHomePageView(),
    );
  }
}

class _SendReceiveHomePageView extends StatefulWidget {
  const _SendReceiveHomePageView({Key? key}) : super(key: key);

  @override
  State<_SendReceiveHomePageView> createState() =>
      _SendReceiveHomePageViewState();
}

class _SendReceiveHomePageViewState extends State<_SendReceiveHomePageView> {
  final tempToken = const TokenModel(
    '',
    'Tezos',
    'XTZ',
    'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
    null,
    '00000000',
    '6',
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      scrollView: false,
      titleLeading: const BackLeadingButton(),
      titleTrailing: const CryptoAccountSwitcherButton(),
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletCubit, WalletState>(
            listenWhen: (prev, next) =>
                prev.currentCryptoIndex != next.currentCryptoIndex,
            listener: (_, walletState) {
              context.read<SendReceiveHomeCubit>().getOperations();
            },
          ),
          BlocListener<ManageNetworkCubit, ManageNetworkState>(
            listenWhen: (prev, next) => prev.network != next.network,
            listener: (_, manageNetworkState) {
              context
                  .read<SendReceiveHomeCubit>()
                  .getOperations(baseUrl: manageNetworkState.network.tzktUrl);
            },
          ),
          BlocListener<SendReceiveHomeCubit, SendReceiveHomeState>(
            listenWhen: (prev, next) => prev.status != next.status,
            listener: (_, sendReceiveHomeState) {
              if (sendReceiveHomeState.status == AppStatus.loading) {
                LoadingView().show(context: context);
              } else {
                LoadingView().hide();
                if (sendReceiveHomeState.status == AppStatus.error) {
                  AlertMessage.showStateMessage(
                    context: context,
                    stateMessage:
                        sendReceiveHomeState.message ?? const StateMessage(),
                  );
                }
              }
            },
          ),
        ],
        child: BlocBuilder<SendReceiveHomeCubit, SendReceiveHomeState>(
            builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundCard(
                height: double.infinity,
                width: double.infinity,
                margin: EdgeInsets.only(top: Sizes.icon3x / 2),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CachedImageFromNetwork(
                    tempToken.iconUrl ?? '',
                    width: Sizes.icon3x,
                    height: Sizes.icon3x,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(Sizes.icon3x),
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  Text(l10n.myTokens,
                      style: Theme.of(context).textTheme.headline5),
                  const TezosNetworkSwitcherButton(),
                  const SizedBox(
                    height: Sizes.spaceLarge,
                  ),
                  MyText(
                    '${tempToken.calculatedBalance.formatNumber()} ${tempToken.symbol}',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  MyText(
                    r'$--.--',
                    style: Theme.of(context).textTheme.normal,
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MyGradientButton(
                        upperCase: false,
                        text: l10n.send,
                        verticalSpacing: 0,
                        margin: const EdgeInsets.all(Sizes.spaceSmall),
                        fontSize: 16,
                        borderRadius: Sizes.smallRadius,
                        height: Sizes.normalButton,
                        icon: Image.asset(
                          IconStrings.send,
                          width: Sizes.icon,
                        ),
                        onPressed: () {
                          Navigator.of(context).push<void>(SendToPage.route());
                        },
                      ),
                      MyGradientButton(
                        upperCase: false,
                        text: l10n.receive,
                        verticalSpacing: 0,
                        fontSize: 16,
                        margin: const EdgeInsets.all(Sizes.spaceSmall),
                        borderRadius: Sizes.smallRadius,
                        height: Sizes.normalButton,
                        icon: Image.asset(
                          IconStrings.receive,
                          width: Sizes.icon,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  RecentTransactions(
                    onRefresh: () async {
                      await context.read<SendReceiveHomeCubit>().getOperations(
                            baseUrl: context
                                .read<ManageNetworkCubit>()
                                .state
                                .network
                                .tzktUrl,
                          );
                    },
                    operations: state.operations,
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
