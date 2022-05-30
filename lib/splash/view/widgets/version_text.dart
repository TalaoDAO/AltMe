import 'package:altme/l10n/l10n.dart';
import 'package:altme/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VersionText extends StatelessWidget {
  const VersionText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<SplashCubit, SplashState>(
      builder: (context, state) {
        return Text(
          '${l10n.version} ${state.versionNumber}',
          maxLines: 1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText2,
        );
      },
    );
  }
}
