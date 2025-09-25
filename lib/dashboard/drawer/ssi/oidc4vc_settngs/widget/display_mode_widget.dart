import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayModeWidget extends StatelessWidget {
  const DisplayModeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Display Mode',
          subtitle:
              // ignore: lines_longer_than_80_chars
              'When activated, the wallet display only VC attributes having a display claim in the issuer metadata',
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    displayMode: value,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.displayMode,
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
