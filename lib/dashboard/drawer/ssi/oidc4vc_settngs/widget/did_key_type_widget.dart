import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/divider_for_radio_list.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class DidKeyTypeWidget extends StatelessWidget {
  const DidKeyTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: 'Default DID',
          subtitle: 'Select one of the DIDs',
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

              /// there is no new key for EBSI V4
              if (didKeyType == DidKeyType.ebsiv4) {
                return Container();
              }

              return Column(
                children: [
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
                          didKeyType == DidKeyType.ebsiv4 ||
                          didKeyType == DidKeyType.jwkP256;

                      if (isldpVc && isUnmatchedDid) {
                        showDialog<bool>(
                          context: context,
                          builder: (context) => const ErrorDetailsDialog(
                            erroDescription: 'The ldp_format is not supported'
                                ' by this DID method.',
                          ),
                        );

                        return;
                      }

                      context.read<ProfileCubit>().updateProfileSetting(
                            didKeyType: didKeyType,
                          );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      didKeyType.didString,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    trailing: Icon(
                      state.model.profileSetting.selfSovereignIdentityOptions
                                  .customOidc4vcProfile.defaultDid ==
                              didKeyType
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
