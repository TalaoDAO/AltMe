import 'package:altme/app/app.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AltMeLogo extends StatelessWidget {
  const AltMeLogo({super.key, this.size = Sizes.logoLarge});

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
      fit: BoxFit.contain,
    );
  }
}
