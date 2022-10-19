import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
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
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      body: BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
        bloc: context.read<ManageNetworkCubit>(),
        builder: (context, state) {
          var groupValue = TezosNetwork.mainNet();
          switch (state.network.networkname) {
            case 'Mainnet':
              groupValue = TezosNetwork.mainNet();
              break;
            case 'Ghostnet':
              groupValue = TezosNetwork.ghostnet();
              break;
          }
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
                Column(
                  children: [
                    TezosNetworkSelector(
                      tezosNetwork: TezosNetwork.mainNet(),
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
                    TezosNetworkSelector(
                      tezosNetwork: TezosNetwork.ghostnet(),
                      groupValue: state.network,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
