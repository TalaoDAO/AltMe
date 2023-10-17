import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SixOrForUserPinWidget extends StatelessWidget {
  const SixOrForUserPinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return DrawerItem2(
          title: l10n.userPinTitle,
          subtitle: l10n.userPinSubtitle,
          trailing: SizedBox(
            height: 25,
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                return Switch(
                  onChanged: (value) async {
                    await context
                        .read<ProfileCubit>()
                        .enable4DigitPINCode(enabled: value);
                  },
                  value: state.model.enable4DigitPINCode,
                  activeColor: Theme.of(context).colorScheme.primary,
                );
              },
            ),
          ),
        );
      },
    );
  }
}
