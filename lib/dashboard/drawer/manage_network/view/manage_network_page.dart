import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/l10n/l10n.dart';
import 'package:arago_wallet/theme/theme.dart';
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
                      groupValue: groupValue,
                    ),
                    TezosNetworkSelector(
                      tezosNetwork: TezosNetwork.ghostnet(),
                      groupValue: groupValue,
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
