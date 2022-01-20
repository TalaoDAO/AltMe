import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ssi_crypto_wallet/app/cubit/theme_mode_cubit.dart';

class IconThemeSwitch extends StatelessWidget {
  const IconThemeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.select((ThemeModeCubit cubit) => cubit.state) ==
        ThemeMode.light) {
      return IconButton(
        icon: const Icon(Icons.dark_mode),
        onPressed: () {
          context.read<ThemeModeCubit>().setDarkTheme();
        },
      );
    } else {
      return IconButton(
        icon: const Icon(Icons.light_mode),
        onPressed: () {
          context.read<ThemeModeCubit>().setLightTheme();
        },
      );
    }
  }
}
