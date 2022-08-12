import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendReceiveHomePage extends StatelessWidget {
  const SendReceiveHomePage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => const SendReceiveHomePage(),
      settings: const RouteSettings(name: '/sendReceiveHomePage'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SendReceiveHomePageCubit(),
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
      body: Stack(
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
            ],
          )
        ],
      ),
    );
  }
}
