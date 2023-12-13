import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialManifestSupportWidget extends StatelessWidget {
  const CredentialManifestSupportWidget({super.key});

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
                          l10n.credentialManifestSupport,
                          style: Theme.of(context).textTheme.drawerItemTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.credentialManifestSupportSubtitle,
                          style: Theme.of(context).textTheme.drawerItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Switch(
                    onChanged: (value) async {
                      await context.read<ProfileCubit>().updateProfileSetting(
                            credentialManifestSupport: value,
                          );
                    },
                    value: state
                        .model
                        .profileSetting
                        .selfSovereignIdentityOptions
                        .customOidc4vcProfile
                        .credentialManifestSupport,
                    activeColor: Theme.of(context).colorScheme.primary,
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
