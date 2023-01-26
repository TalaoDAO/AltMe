import 'package:altme/app/app.dart';
import 'package:altme/dashboard/drawer/manage_network/cubit/manage_network_cubit.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NetworkSwitcherButton extends StatelessWidget {
  const NetworkSwitcherButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.activeColorOfNetwork,
              shape: BoxShape.circle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
            child: BlocBuilder<ManageNetworkCubit, ManageNetworkState>(
              builder: (context, state) {
                return Text(
                  state.network.title!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                );
              },
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: Sizes.icon,
            color: Theme.of(context).colorScheme.inversePrimary,
          )
        ],
      ),
    );
  }
}
