import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeNetworkBottomSheetView extends StatelessWidget {
  const ChangeNetworkBottomSheetView({Key? key}) : super(key: key);

  static Future<void> show({required BuildContext context}) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const ChangeNetworkBottomSheetView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ManageNetworkCubit>.value(
      value: context.read<ManageNetworkCubit>(),
      child: const ChangeNetworkBottomSheetPage(),
    );
  }
}

class ChangeNetworkBottomSheetPage extends StatefulWidget {
  const ChangeNetworkBottomSheetPage({Key? key}) : super(key: key);

  @override
  State<ChangeNetworkBottomSheetPage> createState() =>
      _ChangeNetworkBottomSheetPageState();
}

class _ChangeNetworkBottomSheetPageState
    extends State<ChangeNetworkBottomSheetPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
      builder: (context, state) {
        final blockchainType =
            context.read<WalletCubit>().state.currentAccount.blockchainType;
        final allNetworks = blockchainType.networks;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.inversePrimary,
                blurRadius: 5,
                spreadRadius: -3,
              )
            ],
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(Sizes.largeRadius),
              topLeft: Radius.circular(Sizes.largeRadius),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.network_wifi_rounded,
                      size: Sizes.icon2x,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                    const SizedBox(width: Sizes.spaceXSmall),
                    Text(
                      l10n.chooseNetWork,
                      style: Theme.of(context).textTheme.accountsText,
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceNormal),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Sizes.space2XSmall),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .accountBottomSheetBorder,
                        width: 0.2,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(Sizes.normalRadius),
                      ),
                    ),
                    child: ListView.separated(
                      itemCount: allNetworks.length,
                      itemBuilder: (context, i) {
                        return NetworkSelector(
                          network: allNetworks[i],
                          groupValue: state.network,
                        );
                      },
                      separatorBuilder: (_, __) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.spaceSmall,
                        ),
                        child: Divider(
                          height: 0.2,
                          color: Theme.of(context).colorScheme.borderColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
