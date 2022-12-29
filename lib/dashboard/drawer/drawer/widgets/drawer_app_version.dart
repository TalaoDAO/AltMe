import 'package:altme/splash/splash.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawerAppVersion extends StatelessWidget {
  const DrawerAppVersion({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        return Text(
          'Talao: V${state.versionNumber} (${state.buildNumber})',
          style: Theme.of(context).textTheme.drawerMenu,
        );
      },
    );
  }
}
