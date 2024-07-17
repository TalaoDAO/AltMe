import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
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
        final profileModel = context.read<ProfileCubit>().state.model;

        final customOidc4vcProfile = profileModel
            .profileSetting.selfSovereignIdentityOptions.customOidc4vcProfile;

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
                      if (!profileModel.isDeveloperMode) {
                        return false;
                      }
                    }

                    /// crypto credential account to be shown always
                    if (element.credentialPreview.credentialSubjectModel
                        .credentialSubjectType.isBlockchainAccount) {
                      /// only show crypto card with matches current account
                      /// wallet address
                      final String? currentWalletAddress = context
                          .read<WalletCubit>()
                          .state
                          .currentAccount
                          ?.walletAddress;

                      final String? walletAddress = getWalletAddress(
                        element.credentialPreview.credentialSubjectModel,
                      );

                      if (currentWalletAddress.toString() !=
                          walletAddress.toString()) {
                        return false;
                      }
                    }

                    if (customOidc4vcProfile.vcFormatType.vcValue ==
                        VCFormatType.auto.vcValue) {
                      return true;
                    }

                    /// do not load the credential if vc format is different
                    if (customOidc4vcProfile.vcFormatType.vcValue !=
                        element.getFormat) {
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
