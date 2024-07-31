import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkSelector extends StatelessWidget {
  const NetworkSelector({
    super.key,
    required this.network,
    required this.groupValue,
  });

  final BlockchainNetwork network;
  final BlockchainNetwork groupValue;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
      builder: (context, state) {
        return ListTile(
          onTap: () async {
            await context.read<ManageNetworkCubit>().setNetwork(network);
          },
          title: RichText(
            text: TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: network.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const TextSpan(text: '\n'),
                TextSpan(
                  text: network.subTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          trailing: Icon(
            state.network == network
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: Sizes.icon2x,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
