import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileSelectorWidget extends StatelessWidget {
  const ProfileSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(Sizes.spaceSmall),
              margin: const EdgeInsets.all(Sizes.spaceXSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.drawerSurface,
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
                          l10n.walletProfilesDescription,
                          style: Theme.of(context).textTheme.drawerItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: [
                      ListTile(
                        onTap: () {
                          context
                              .read<ProfileCubit>()
                              .setEbsiV3Profile(enabled: true);
                        },
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFFDDDDEE),
                            width: 0.5,
                          ),
                        ),
                        title: Text(
                          Profile.ebsiV3.getTitle(l10n),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        trailing: Icon(
                          state.model.isEbsiV3Profile == true
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: Sizes.icon2x,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          context
                              .read<ProfileCubit>()
                              .setEbsiV3Profile(enabled: false);
                        },
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color(0xFFDDDDEE),
                            width: 0.5,
                          ),
                        ),
                        title: Text(
                          Profile.custom.getTitle(l10n),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                        ),
                        trailing: Icon(
                          state.model.isEbsiV3Profile == false
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: Sizes.icon2x,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
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
