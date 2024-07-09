import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptographicHolderBindingWidget extends StatelessWidget {
  const CryptographicHolderBindingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Cryptographic Holder Binding',
          subtitle:
              'Default : On\nDisable cryptographic binding for claim based'
              ' binding credentials.',
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    cryptoHolderBinding: value,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.cryptoHolderBinding,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
