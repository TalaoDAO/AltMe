import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageNetworkPage extends StatelessWidget {
  const ManageNetworkPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
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
          final currentNetworkList = blockchainType.networks;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.chooseNetWork,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 15),
              ...List.generate(
                currentNetworkList.length,
                (index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NetworkSelector(
                        network: currentNetworkList[index],
                        groupValue: state.network,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Divider(
                          height: 0,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
