import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The BLE modes the mdoc proximity holder offers a reader, as two checkboxes.
/// A change applies to the next proximity session; the last ticked mode cannot
/// be unticked.
class ProximityBleModes extends StatelessWidget {
  const ProximityBleModes({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final options = state.model.profileSetting.selfSovereignIdentityOptions;
        final peripheralServer = options.proximityPeripheralServer;
        final centralClient = options.proximityCentralClient;
        final profileCubit = context.read<ProfileCubit>();
        return OptionContainer(
          title: l10n.proximityBleSettings,
          subtitle: l10n.proximityBleSettingsSubtitle,
          // The tiles' ink needs a Material above the container's colour.
          body: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                _ModeTile(
                  title: l10n.proximityBlePeripheralServer,
                  subtitle: l10n.proximityBlePeripheralServerSubtitle,
                  value: peripheralServer,
                  // The last ticked mode cannot be unticked.
                  locked: peripheralServer && !centralClient,
                  onChanged: (value) => profileCubit.updateProfileSetting(
                    proximityPeripheralServer: value,
                  ),
                ),
                _ModeTile(
                  title: l10n.proximityBleCentralClient,
                  subtitle: l10n.proximityBleCentralClientSubtitle,
                  value: centralClient,
                  locked: centralClient && !peripheralServer,
                  onChanged: (value) => profileCubit.updateProfileSetting(
                    proximityCentralClient: value,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.locked,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final bool locked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      activeColor: Theme.of(context).colorScheme.primary,
      onChanged: locked ? null : (value) => onChanged(value ?? false),
    );
  }
}
