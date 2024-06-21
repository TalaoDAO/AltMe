import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class HomeCredentialCategoryList extends StatelessWidget {
  const HomeCredentialCategoryList({
    super.key,
    required this.credentials,
    required this.onRefresh,
  });

  final List<CredentialModel> credentials;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
      builder: (context, advanceSettingsState) {
        final profileModel = context.read<ProfileCubit>().state.model;

        final customOidc4vcProfile = profileModel
            .profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;
        final colorScheme = Theme.of(context).colorScheme;
        const Widget divider = SizedBox(height: 10);
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                ColorGroup(children: <ColorChip>[
                  ColorChip(
                      'primary', colorScheme.primary, colorScheme.onPrimary),
                  ColorChip(
                      'onPrimary', colorScheme.onPrimary, colorScheme.primary),
                  ColorChip('primaryContainer', colorScheme.primaryContainer,
                      colorScheme.onPrimaryContainer),
                  ColorChip(
                    'onPrimaryContainer',
                    colorScheme.onPrimaryContainer,
                    colorScheme.primaryContainer,
                  ),
                ]),
                divider,
                ColorGroup(children: <ColorChip>[
                  ColorChip('primaryFixed', colorScheme.primaryFixed,
                      colorScheme.onPrimaryFixed),
                  ColorChip('onPrimaryFixed', colorScheme.onPrimaryFixed,
                      colorScheme.primaryFixed),
                  ColorChip('primaryFixedDim', colorScheme.primaryFixedDim,
                      colorScheme.onPrimaryFixedVariant),
                  ColorChip(
                    'onPrimaryFixedVariant',
                    colorScheme.onPrimaryFixedVariant,
                    colorScheme.primaryFixedDim,
                  ),
                ]),
                divider,
                ColorGroup(children: <ColorChip>[
                  ColorChip('secondary', colorScheme.secondary,
                      colorScheme.onSecondary),
                  ColorChip('onSecondary', colorScheme.onSecondary,
                      colorScheme.secondary),
                  ColorChip(
                    'secondaryContainer',
                    colorScheme.secondaryContainer,
                    colorScheme.onSecondaryContainer,
                  ),
                  ColorChip(
                    'onSecondaryContainer',
                    colorScheme.onSecondaryContainer,
                    colorScheme.secondaryContainer,
                  ),
                ]),
                divider,
                ColorGroup(children: <ColorChip>[
                  ColorChip('secondaryFixed', colorScheme.secondaryFixed,
                      colorScheme.onSecondaryFixed),
                  ColorChip('onSecondaryFixed', colorScheme.onSecondaryFixed,
                      colorScheme.secondaryFixed),
                  ColorChip(
                    'secondaryFixedDim',
                    colorScheme.secondaryFixedDim,
                    colorScheme.onSecondaryFixedVariant,
                  ),
                  ColorChip(
                    'onSecondaryFixedVariant',
                    colorScheme.onSecondaryFixedVariant,
                    colorScheme.secondaryFixedDim,
                  ),
                ]),
                divider,
                ColorGroup(
                  children: <ColorChip>[
                    ColorChip('tertiary', colorScheme.tertiary,
                        colorScheme.onTertiary),
                    ColorChip('onTertiary', colorScheme.onTertiary,
                        colorScheme.tertiary),
                    ColorChip(
                      'tertiaryContainer',
                      colorScheme.tertiaryContainer,
                      colorScheme.onTertiaryContainer,
                    ),
                    ColorChip(
                      'onTertiaryContainer',
                      colorScheme.onTertiaryContainer,
                      colorScheme.tertiaryContainer,
                    ),
                  ],
                ),
                divider,
                ColorGroup(children: <ColorChip>[
                  ColorChip('tertiaryFixed', colorScheme.tertiaryFixed,
                      colorScheme.onTertiaryFixed),
                  ColorChip('onTertiaryFixed', colorScheme.onTertiaryFixed,
                      colorScheme.tertiaryFixed),
                  ColorChip('tertiaryFixedDim', colorScheme.tertiaryFixedDim,
                      colorScheme.onTertiaryFixedVariant),
                  ColorChip(
                    'onTertiaryFixedVariant',
                    colorScheme.onTertiaryFixedVariant,
                    colorScheme.tertiaryFixedDim,
                  ),
                ]),
                divider,
                ColorGroup(
                  children: <ColorChip>[
                    ColorChip('error', colorScheme.error, colorScheme.onError),
                    ColorChip(
                        'onError', colorScheme.onError, colorScheme.error),
                    ColorChip('errorContainer', colorScheme.errorContainer,
                        colorScheme.onErrorContainer),
                    ColorChip('onErrorContainer', colorScheme.onErrorContainer,
                        colorScheme.errorContainer),
                  ],
                ),
                divider,
                ColorGroup(
                  children: <ColorChip>[
                    ColorChip('surfaceDim', colorScheme.surfaceDim,
                        colorScheme.onSurface),
                    ColorChip(
                        'surface', colorScheme.surface, colorScheme.onSurface),
                    ColorChip('surfaceBright', colorScheme.surfaceBright,
                        colorScheme.onSurface),
                    ColorChip(
                        'surfaceContainerLowest',
                        colorScheme.surfaceContainerLowest,
                        colorScheme.onSurface),
                    ColorChip('surfaceContainerLow',
                        colorScheme.surfaceContainerLow, colorScheme.onSurface),
                    ColorChip('surfaceContainer', colorScheme.surfaceContainer,
                        colorScheme.onSurface),
                    ColorChip(
                        'surfaceContainerHigh',
                        colorScheme.surfaceContainerHigh,
                        colorScheme.onSurface),
                    ColorChip(
                        'surfaceContainerHighest',
                        colorScheme.surfaceContainerHighest,
                        colorScheme.onSurface),
                    ColorChip('onSurface', colorScheme.onSurface,
                        colorScheme.surface),
                    ColorChip(
                      'onSurfaceVariant',
                      colorScheme.onSurfaceVariant,
                      colorScheme.surfaceContainerHighest,
                    ),
                  ],
                ),
                divider,
                ColorGroup(
                  children: <ColorChip>[
                    ColorChip('outline', colorScheme.outline, null),
                    ColorChip('shadow', colorScheme.shadow, null),
                    ColorChip('inverseSurface', colorScheme.inverseSurface,
                        colorScheme.onInverseSurface),
                    ColorChip('onInverseSurface', colorScheme.onInverseSurface,
                        colorScheme.inverseSurface),
                    ColorChip('inversePrimary', colorScheme.inversePrimary,
                        colorScheme.primary),
                  ],
                ),
              ]),
            ),
          ),
        );
      },
    );
  }
}

class ColorChip extends StatelessWidget {
  const ColorChip(this.label, this.color, this.onColor, {super.key});

  final Color color;
  final Color? onColor;
  final String label;

  static Color contrastColor(Color color) {
    final Brightness brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black;
  }

  @override
  Widget build(BuildContext context) {
    final Color labelColor = onColor ?? contrastColor(color);
    return ColoredBox(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Expanded>[
            Expanded(child: Text(label, style: TextStyle(color: labelColor))),
          ],
        ),
      ),
    );
  }
}

class ColorGroup extends StatelessWidget {
  const ColorGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child:
          Card(clipBehavior: Clip.antiAlias, child: Column(children: children)),
    );
  }
}
