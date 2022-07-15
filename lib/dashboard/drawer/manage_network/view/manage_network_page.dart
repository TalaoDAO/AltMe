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
      title: l10n.manageNetwork,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      body: BlocBuilder<ProfileCubit, ProfileState>(
        bloc: context.read<ProfileCubit>(),
        builder: (context, state) {
          var groupValue = TezosNetwork.mainNet();
          switch (state.model.tezosNetwork.networkname) {
            case 'mainnet':
              groupValue = TezosNetwork.mainNet();
              break;
            case 'ithacanet':
              groupValue = TezosNetwork.ithacaNet();
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
                      tezosNetwork: TezosNetwork.ithacaNet(),
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
