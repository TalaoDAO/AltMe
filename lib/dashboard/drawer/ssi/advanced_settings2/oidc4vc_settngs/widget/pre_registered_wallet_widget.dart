import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreRegisteredWalletWidget extends StatelessWidget {
  const PreRegisteredWalletWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final clientIdController = TextEditingController();
        final clientSecretController = TextEditingController();
        clientIdController.text =
            context.read<ProfileCubit>().state.model.clientId;
        clientSecretController.text =
            context.read<ProfileCubit>().state.model.clientSecret;

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
                          l10n.preRegisteredWallet,
                          style: Theme.of(context).textTheme.drawerItemTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.preRegisteredWalletSubtitle,
                          style: Theme.of(context).textTheme.drawerItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Switch(
                    onChanged: (value) async {
                      await context
                          .read<ProfileCubit>()
                          .updatePreRegisteredWalletStatus(
                            enabled: value,
                          );
                    },
                    value: state.model.isPreRegisteredWallet,
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  TextFormField(
                    controller: clientIdController,
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Sizes.smallRadius,
                          ),
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                      hintText: 'Client Id',
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.spaceSmall,
                  ),
                  TextFormField(
                    controller: clientSecretController,
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            Sizes.smallRadius,
                          ),
                        ),
                      ),
                      hintText: 'Client Secret',
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 10,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Sizes.spaceNormal,
                  ),
                  MyElevatedButton(
                    text: l10n.confirm,
                    verticalSpacing: 14,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    borderRadius: Sizes.smallRadius,
                    fontSize: 15,
                    elevation: 0,
                    onPressed: () async {
                      await context
                          .read<ProfileCubit>()
                          .updatePreRegisteredWalletSettings(
                            clientId: clientIdController.value.text.trim(),
                            clientSecret:
                                clientSecretController.value.text.trim(),
                          );
                    },
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
