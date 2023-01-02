import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkSelector extends StatelessWidget {
  const NetworkSelector({
    Key? key,
    required this.network,
    required this.groupValue,
  }) : super(key: key);

  final BlockchainNetwork network;
  final BlockchainNetwork groupValue;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ManageNetworkCubit, ManageNetworkState>(
      listener: (context, state) {},
      builder: (context, state) {
        return RadioListTile(
          value: network,
          groupValue: groupValue,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.onPrimary,
          dense: true,
          visualDensity: VisualDensity.compact,
          title: Text(
            network.title!,
            style: Theme.of(context).textTheme.radioOption,
          ),
          subtitle: Text(
            network.subTitle!,
            style: Theme.of(context).textTheme.caption2,
          ),
          onChanged: (BlockchainNetwork? value) async {
            if (value != null) {
              await context.read<ManageNetworkCubit>().setNetwork(value);
            }
          },
        );
      },
    );
  }
}
