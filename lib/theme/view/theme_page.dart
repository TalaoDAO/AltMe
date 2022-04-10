import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({Key? key}) : super(key: key);

  static Route route(ThemeCubit themeCubit) => MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: themeCubit,
          child: const ThemePage(),
        ),
        settings: const RouteSettings(name: '/themePage'),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, state) {
        return BasePage(
          title: l10n.selectThemeText,
          titleLeading: const BackLeadingButton(),
          padding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ThemeItem(
                key: const Key('set_light_theme'),
                isTrue: state == ThemeMode.light,
                title: l10n.lightThemeText,
                onTap: () => context.read<ThemeCubit>().setLightTheme(),
              ),
              ThemeItem(
                key: const Key('set_dark_theme'),
                isTrue: state == ThemeMode.dark,
                title: l10n.darkThemeText,
                onTap: () => context.read<ThemeCubit>().setDarkTheme(),
              ),
              ThemeItem(
                key: const Key('set_system_theme'),
                isTrue: state == ThemeMode.system,
                title: l10n.systemThemeText,
                onTap: () => context.read<ThemeCubit>().setSystemTheme(),
              ),
            ],
          ),
        );
      },
    );
  }
}
