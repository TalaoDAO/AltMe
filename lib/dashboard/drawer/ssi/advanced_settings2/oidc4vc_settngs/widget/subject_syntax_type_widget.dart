import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectSyntaxTypeWidget extends StatelessWidget {
  const SubjectSyntaxTypeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return OptionContainer(
          title: l10n.subjectSyntaxType,
          subtitle: l10n.enableToUseTheJWKThumprintOfTheKey,
          body: Switch(
            onChanged: (value) async {
              await context.read<ProfileCubit>().updateProfileSetting(
                    subjectSyntax:
                        value ? SubjectSyntax.jwkThumbprint : SubjectSyntax.did,
                  );
            },
            value: state.model.profileSetting.selfSovereignIdentityOptions
                    .customOidc4vcProfile.subjectSyntaxeType ==
                SubjectSyntax.jwkThumbprint,
            activeColor: Theme.of(context).colorScheme.primary,
          ),
        );
      },
    );
  }
}
