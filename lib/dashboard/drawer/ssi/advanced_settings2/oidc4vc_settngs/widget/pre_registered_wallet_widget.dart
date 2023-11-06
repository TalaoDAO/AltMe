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
                        const SizedBox(height: 10),
                        TransparentInkWell(
                          onTap: () async {
                            final String? clientId = await showDialog<String?>(
                              context: context,
                              builder: (_) {
                                final color =
                                    Theme.of(context).colorScheme.primary;
                                final background = Theme.of(context)
                                    .colorScheme
                                    .popupBackground;
                                final textColor =
                                    Theme.of(context).colorScheme.dialogText;

                                final clientIdController =
                                    TextEditingController(
                                  text: state.model.clientId,
                                );

                                return AlertDialog(
                                  backgroundColor: background,
                                  surfaceTintColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        IconStrings.cardReceive,
                                        width: 50,
                                        height: 50,
                                        color: textColor,
                                      ),
                                      const SizedBox(
                                        height: Sizes.spaceNormal,
                                      ),
                                      TextFormField(
                                        controller: clientIdController,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
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
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Sizes.spaceNormal,
                                      ),
                                      MyElevatedButton(
                                        text: l10n.confirm,
                                        verticalSpacing: 14,
                                        backgroundColor: color,
                                        borderRadius: Sizes.smallRadius,
                                        fontSize: 15,
                                        elevation: 0,
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                            clientIdController.text.trim(),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                );
                              },
                            );

                            if (clientId != null) {
                              await context
                                  .read<ProfileCubit>()
                                  .updateClientId(clientId);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  Sizes.smallRadius,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${l10n.clientId}: ${state.model.clientId}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .drawerItemSubtitle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TransparentInkWell(
                          onTap: () async {
                            final String? clientSecret =
                                await showDialog<String?>(
                              context: context,
                              builder: (_) {
                                final color =
                                    Theme.of(context).colorScheme.primary;
                                final background = Theme.of(context)
                                    .colorScheme
                                    .popupBackground;
                                final textColor =
                                    Theme.of(context).colorScheme.dialogText;

                                final clientSecretController =
                                    TextEditingController(
                                  text: state.model.clientSecret,
                                );

                                return AlertDialog(
                                  backgroundColor: background,
                                  surfaceTintColor: Colors.transparent,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 15,
                                  ),
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        IconStrings.cardReceive,
                                        width: 50,
                                        height: 50,
                                        color: textColor,
                                      ),
                                      const SizedBox(
                                        height: Sizes.spaceNormal,
                                      ),
                                      TextFormField(
                                        controller: clientSecretController,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium,
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
                                        ),
                                      ),
                                      const SizedBox(
                                        height: Sizes.spaceNormal,
                                      ),
                                      MyElevatedButton(
                                        text: l10n.confirm,
                                        verticalSpacing: 14,
                                        backgroundColor: color,
                                        borderRadius: Sizes.smallRadius,
                                        fontSize: 15,
                                        elevation: 0,
                                        onPressed: () {
                                          Navigator.of(context).pop(
                                            clientSecretController.text.trim(),
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 15),
                                    ],
                                  ),
                                );
                              },
                            );

                            if (clientSecret != null) {
                              await context
                                  .read<ProfileCubit>()
                                  .updateClientSecret(clientSecret);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 7,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  Sizes.smallRadius,
                                ),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    '${l10n.clientSecret}: '
                                    '${state.model.clientSecret}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .drawerItemSubtitle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.edit,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
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
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
