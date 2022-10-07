import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/cubit/flavor_cubit.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, homeState) {
        if (homeState.status == AppStatus.loading) {
          LoadingView().show(context: context);
        } else {
          LoadingView().hide();
        }

        if (homeState.message != null) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: homeState.message!,
          );
        }

        if (homeState.status == AppStatus.success) {}

        if (homeState.status == AppStatus.gotTokenReward &&
            homeState.tokenReward != null) {
          showDialog<void>(
            context: context,
            builder: (_) => DefaultDialog(
              title: l10n.reward,
              description:
                  '''${l10n.youHaveReceivedARewardOf} ${homeState.tokenReward!.amount.toString().formatNumber()} ${homeState.tokenReward!.symbol}''',
              buttonLabel: l10n.gotIt.toUpperCase(),
            ),
          );
        }
      },
      // TODO(all): Remove IosTabControllerPage when apple accept our NFT #664, https://github.com/TalaoDAO/AltMe/issues/664
      // Setting to hide gallery when on ios
      child: context.read<FlavorCubit>().state == FlavorMode.production
          ? isAndroid()
              ? const TabControllerPage()
              : const IosTabControllerPage()
          : const TabControllerPage(),
      // child: const TabControllerPage(),
    );
  }
}
