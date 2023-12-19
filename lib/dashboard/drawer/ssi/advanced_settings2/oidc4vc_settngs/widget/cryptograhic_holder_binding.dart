import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CryptographicHolderBindingWidget extends StatelessWidget {
  const CryptographicHolderBindingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: l10n.cryptographicHolderBinding,
          subtitle: l10n.cryptographicHolderBindingSubtitle,
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
