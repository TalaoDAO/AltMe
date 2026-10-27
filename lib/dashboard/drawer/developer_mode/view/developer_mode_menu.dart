import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:protocol_trace/protocol_trace.dart';

/// Everything for developers and testers: the developer mode switch, the BLE
/// modes of the proximity holder and, in debug builds, the protocol trace logs.
class DeveloperModeMenu extends StatelessWidget {
  const DeveloperModeMenu({super.key});

  static Route<dynamic> route() {
    final route = MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/DeveloperModeMenu'),
      builder: (_) => const DeveloperModeMenu(),
    );
    return route;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BasePage(
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      scrollView: true,
      titleAlignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final profileModel = state.model;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackLeadingButton(padding: EdgeInsets.zero),
              const DrawerLogo(),
              if (profileModel
                  .profileSetting
                  .settingsMenu
                  .displayDeveloperMode) ...[
                DrawerCategoryItem(
                  title: l10n.developerMode,
                  subTitle: l10n.developerModeSubtitle,
                  trailing: SizedBox(
                    height: 25,
                    child: Switch(
                      key: const Key('developerMode'),
                      onChanged: (value) async {
                        await context
                            .read<ProfileCubit>()
                            .setDeveloperModeStatus(enabled: value);
                      },
                      value: profileModel.isDeveloperMode,
                      activeThumbColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: Sizes.spaceSmall),
              ],
              const ProximityBleModes(),
              if (ProtocolTrace.current != null)
                DrawerItem(
                  title: l10n.protocolTraceLogs,
                  subtitle: l10n.protocolTraceLogsDescription,
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push<void>(ProtocolTraceLogsPage.route());
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
