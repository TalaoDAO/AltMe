import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DPopSupoprtWidget extends StatelessWidget {
  const DPopSupoprtWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Demonstrating Proof of Possession (DPoP)',
          subtitle: 'Enable to protect code and access token.',
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    dpopSupport: value,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.dpopSupport,
            activeThumbColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
