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
    return BlocConsumer<ManageNetworkCubit, ManageNetworkState>(
      listener: (context, state) {},
      builder: (context, state) {
        return RadioListTile(
          value: tezosNetwork,
          groupValue: groupValue,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            tezosNetwork.title!,
            style: Theme.of(context).textTheme.radioOption,
          ),
          subtitle: Text(
            tezosNetwork.subTitle!,
            style: Theme.of(context).textTheme.caption2,
          ),
          onChanged: (TezosNetwork? value) async {
            if (value != null) {
              await context.read<ManageNetworkCubit>().setNetwork(value);
            }
          },
        );
      },
    );
  }
}
