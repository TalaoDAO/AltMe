import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageNetworkPage extends StatelessWidget {
  const ManageNetworkPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const ManageNetworkPage(),
        settings: const RouteSettings(name: '/manageNetworkPage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      title: l10n.network,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      body: BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
        bloc: context.read<ManageNetworkCubit>(),
        builder: (context, state) {
          final blockchainType =
              context.read<WalletCubit>().state.currentAccount!.blockchainType;
          final allNetworks = blockchainType.networks;

          return BackgroundCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    l10n.chooseNetWork,
                    style: Theme.of(context).textTheme.radioTitle,
                  ),
                ),
                const SizedBox(height: 15),
                ...List.generate(allNetworks.length, (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NetworkSelector(
                        network: allNetworks[index],
                        groupValue: state.network,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceSmall,
                          vertical: Sizes.spaceXSmall,
                        ),
                        child: Divider(
                          height: 0.2,
                          color: Theme.of(context).colorScheme.borderColor,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
