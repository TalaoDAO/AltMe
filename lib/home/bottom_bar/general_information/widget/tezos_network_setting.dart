import 'package:altme/app/shared/tezos_network/models/tezos_network.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TezosNetworksetting extends StatelessWidget {
  const TezosNetworksetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<ProfileCubit, ProfileState>(
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                l10n.tezosNetwork,
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
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
        );
      },
    );
  }
}

class TezosNetworkSelector extends StatefulWidget {
  const TezosNetworkSelector({
    Key? key,
    required this.tezosNetwork,
    required this.groupValue,
  }) : super(key: key);

  final TezosNetwork tezosNetwork;
  final TezosNetwork groupValue;

  @override
  State<TezosNetworkSelector> createState() => _TezosNetworkSelectorState();
}

class _TezosNetworkSelectorState extends State<TezosNetworkSelector> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            widget.tezosNetwork.networkname,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          trailing: Radio<TezosNetwork>(
            value: widget.tezosNetwork,
            groupValue: widget.groupValue,
            onChanged: (TezosNetwork? value) async {
              if (value != null) {
                await context.read<ProfileCubit>().updateTezosNetwork(value);
              }
            },
          ),
        );
      },
    );
  }
}
