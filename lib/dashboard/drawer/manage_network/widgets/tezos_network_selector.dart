import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TezosNetworkSelector extends StatelessWidget {
  const TezosNetworkSelector({
    Key? key,
    required this.tezosNetwork,
    required this.groupValue,
  }) : super(key: key);

  final TezosNetwork tezosNetwork;
  final TezosNetwork groupValue;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ListTile(
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            tezosNetwork.networkname,
            style: Theme.of(context).textTheme.radioOption,
          ),
          trailing: Radio<TezosNetwork>(
            value: tezosNetwork,
            groupValue: groupValue,
            activeColor: Theme.of(context).colorScheme.onPrimary,
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
