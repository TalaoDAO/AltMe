import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/profile.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DraftTypeWidget extends StatelessWidget {
  const DraftTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final l10n = context.l10n;
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
                          'OIDC4VCI',
                          style: Theme.of(context).textTheme.drawerItemTitle,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          l10n.protocoleStandardRelease,
                          style: Theme.of(context).textTheme.drawerItemSubtitle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    itemCount: OIDC4VCIDraftType.values.length,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final draftType = OIDC4VCIDraftType.values[index];
                      return Column(
                        children: [
                          if (index != 0)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Divider(
                                height: 0,
                                color:
                                    Theme.of(context).colorScheme.borderColor,
                              ),
                            ),
                          ListTile(
                            onTap: () {
                              context
                                  .read<ProfileCubit>()
                                  .updateDraftType(draftType);
                            },
                            shape: const RoundedRectangleBorder(
                              side: BorderSide(
                                color: Color(0xFFDDDDEE),
                                width: 0.5,
                              ),
                            ),
                            title: Text(
                              draftType.formattedString,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                            ),
                            trailing: Icon(
                              state.model.draftType == draftType.toString()
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: Sizes.icon2x,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      );
                    },
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
