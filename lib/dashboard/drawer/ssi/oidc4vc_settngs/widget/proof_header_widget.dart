import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class ProofHeaderWidget extends StatelessWidget {
  const ProofHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: l10n.proofHeader,
          subtitle: l10n.proofHeaderSubtitle,
          body: ListView.builder(
            itemCount: ProofHeaderType.values.length,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final proofHeaderType = ProofHeaderType.values[index];
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
                      context.read<ProfileCubit>().updateProfileSetting(
                            proofHeaderType: proofHeaderType,
                          );
                    },
                    shape: const RoundedRectangleBorder(
                      side: BorderSide(
                        color: Color(0xFFDDDDEE),
                        width: 0.5,
                      ),
                    ),
                    title: Text(
                      proofHeaderType.formattedString,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                    trailing: Icon(
                      state.model.profileSetting.selfSovereignIdentityOptions
                                  .customOidc4vcProfile.proofHeader ==
                              proofHeaderType
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
