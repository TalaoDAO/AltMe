import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/divider_for_radio_list.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
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
        return OptionContainer(
          title: 'OIDC4VCI',
          subtitle: l10n.protocoleStandardRelease,
          body: ListView.builder(
            itemCount: OIDC4VCIDraftType.values.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final draftType = OIDC4VCIDraftType.values[index];
              return Column(
                children: [
                  ListTile(
                    onTap: () {
                      context.read<ProfileCubit>().updateProfileSetting(
                            oidc4vciDraftType: draftType,
                          );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      draftType.formattedString,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      state.model.profileSetting.selfSovereignIdentityOptions
                                  .customOidc4vcProfile.oidc4vciDraft ==
                              draftType
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: Sizes.icon2x,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const DividerForRadioList(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
