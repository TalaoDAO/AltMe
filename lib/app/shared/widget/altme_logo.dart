import 'package:altme/app/app.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AltMeLogo extends StatelessWidget {
  const AltMeLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlavorCubit flavorCubit = context.read<FlavorCubit>();
    return Image.asset(
      flavorCubit.state == FlavorMode.development
          ? ImageStrings.splashDev
          : flavorCubit.state == FlavorMode.staging
              ? ImageStrings.splashStage
              : ImageStrings.splash,
      width: Sizes.logoLarge,
      height: Sizes.logoLarge,
      fit: BoxFit.fitHeight,
    );
  }
}
