import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oidc4vc/oidc4vc.dart';

class HomeCredentialCategoryList extends StatelessWidget {
  const HomeCredentialCategoryList({
    super.key,
    required this.credentials,
    required this.onRefresh,
  });

  final List<CredentialModel> credentials;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdvanceSettingsCubit, AdvanceSettingsState>(
      builder: (context, advanceSettingsState) {
        final vcFormatType = context
            .read<ProfileCubit>()
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile
            .vcFormatType;
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.space2XSmall),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: getCredentialCategorySorted.where(
                (category) {
                  return advanceSettingsState.categoryIsEnabledMap[category] ??
                      true;
                },
              ).map((category) {
                final categorizedCredentials = credentials.where(
                  (element) {
                    /// id credential category does not match, do not show
                    if (element.credentialPreview.credentialSubjectModel
                            .credentialCategory !=
                        category) {
                      return false;
                    }

                    /// wallet credential to be shown always
                    if (element.credentialPreview.credentialSubjectModel
                            .credentialSubjectType ==
                        CredentialSubjectType.walletCredential) {
                      return true;
                    }

                    /// do not load the credential if vc format is different
                    if (vcFormatType.value != element.getFormat) {
                      return false;
                    }

                    return true;
                  },
                ).toList();
                if (categorizedCredentials.isEmpty) {
                  if (category.showInHomeIfListEmpty) {
                    return HomeCredentialCategoryItem(
                      credentials: const [],
                      credentialCategory: category,
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return HomeCredentialCategoryItem(
                    credentials: categorizedCredentials,
                    credentialCategory: category,
                  );
                }
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
