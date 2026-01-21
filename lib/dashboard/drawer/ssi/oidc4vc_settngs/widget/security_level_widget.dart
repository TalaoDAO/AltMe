import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityLevelWidget extends StatelessWidget {
  const SecurityLevelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Wallet Level',
          subtitle:
              'Set to Strict to strengthen'
              ' controls for issuers and verifiers. Default: Permissive.',
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                securityLevel: value,
              );
            },
            value: state
                .model
                .profileSetting
                .selfSovereignIdentityOptions
                .customOidc4vcProfile
                .securityLevel,
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
