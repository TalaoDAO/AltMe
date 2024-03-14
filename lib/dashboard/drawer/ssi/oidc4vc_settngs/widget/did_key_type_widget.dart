import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DidKeyTypeWidget extends StatelessWidget {
  const DidKeyTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: l10n.defaultDid,
          subtitle: l10n.selectOneOfTheDid,
          body: ListView.builder(
            itemCount: DidKeyType.values.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final didKeyType = DidKeyType.values[index];

              if (didKeyType == DidKeyType.jwtClientAttestation) {
                return Container();
              }
              return Column(
                children: [
                  if (index != 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Divider(
                        height: 0,
                        color: Theme.of(context).colorScheme.borderColor,
                      ),
                    ),
                  ListTile(
                    onTap: () {
                      final customOidc4vcProfile = state.model.profileSetting
                          .selfSovereignIdentityOptions.customOidc4vcProfile;

                      /// if user chooses VC format ldp_vc with did:ebsi or
                      /// did:jwk - Display message "The ldp_format is not
                      /// supported by this DID method"
                      final isldpVc = customOidc4vcProfile.vcFormatType ==
                          VCFormatType.ldpVc;

                      final isUnmatchedDid = didKeyType == DidKeyType.ebsiv3 ||
                          didKeyType == DidKeyType.jwkP256;

                      if (isldpVc && isUnmatchedDid) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => ErrorDetailsDialog(
                            erroDescription:
                                l10n.theLdpFormatIsNotSupportedByThisDIDMethod,
                          ),
                        );

                        return;
                      }

                      context.read<ProfileCubit>().updateProfileSetting(
                            didKeyType: didKeyType,
                          );
                    },
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFFDDDDEE),
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      didKeyType.formattedString,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    trailing: Icon(
                      state.model.profileSetting.selfSovereignIdentityOptions
                                  .customOidc4vcProfile.defaultDid ==
                              didKeyType
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
        );
      },
    );
  }
}
