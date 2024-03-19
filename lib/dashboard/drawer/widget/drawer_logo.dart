import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerLogo extends StatelessWidget {
  const DrawerLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WalletLogo(
          profileModel: context.read<ProfileCubit>().state.model,
          height: 90,
          width: MediaQuery.of(context).size.shortestSide * 0.5,
          showPoweredBy: true,
        ),
        const SizedBox(height: Sizes.spaceSmall),
      ],
    );
  }
}
