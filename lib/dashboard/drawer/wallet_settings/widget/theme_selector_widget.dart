import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/theme/theme_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSelectorWidget extends StatelessWidget {
  const ThemeSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              margin: const EdgeInsets.all(Sizes.spaceXSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(
                  Radius.circular(Sizes.largeRadius),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.themeSettingsDescription,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      ThemeModeLine(
                        label: l10n.darkThemeText,
                        themeMode: ThemeMode.dark,
                      ),
                      ThemeModeLine(
                        label: l10n.lightThemeText,
                        themeMode: ThemeMode.light,
                      ),
                      ThemeModeLine(
                        label: l10n.systemThemeText,
                        themeMode: ThemeMode.system,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class ThemeModeLine extends StatelessWidget {
  const ThemeModeLine({
    super.key,
    required this.label,
    required this.themeMode,
  });
  final String label;
  final ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () async {
            context.read<ThemeCubit>().switchTheme(themeMode);
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.onSurface,
              width: 0.5,
            ),
          ),
          title: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          trailing: BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, state) {
              return Icon(
                state.themeMode == themeMode
                    ? Icons.radio_button_checked
                    : Icons.radio_button_unchecked,
                size: Sizes.icon2x,
                color: Theme.of(context).colorScheme.primary,
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Divider(
            height: 0,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.12),
          ),
        ),
      ],
    );
  }
}
