import 'package:altme/app/app.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AltMeLogo extends StatelessWidget {
  const AltMeLogo({Key? key, this.size = Sizes.logoLarge}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    final FlavorCubit flavorCubit = context.read<FlavorCubit>();
    return Image.asset(
      flavorCubit.state == FlavorMode.development
          ? ImageStrings.splashDev
          : flavorCubit.state == FlavorMode.staging
              ? ImageStrings.splashStage
              : ImageStrings.splash,
      width: size,
      height: size,
      fit: BoxFit.fitHeight,
    );
  }
}
