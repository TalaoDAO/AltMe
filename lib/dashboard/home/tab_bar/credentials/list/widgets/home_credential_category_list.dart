import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: Padding(
            padding: const EdgeInsets.all(Sizes.space2XSmall),
            child: ListView(
              scrollDirection: Axis.vertical,
              children:
                  getCredentialsCategories(context: context).map((category) {
                // TODO(Taleb): update advanceSettingsState code
                return HomeCredentialCategoryItem(
                  credentials: credentials
                      .where(
                        (element) =>
                            element.credentialPreview.credentialSubjectModel
                                .credentialCategory ==
                            category,
                      )
                      .toList(),
                  credentialCategory: category,
                  margin: const EdgeInsets.only(
                    bottom: Sizes.spaceNormal,
                  ),
                );
              }).toList(),
              // children: [
              //   if (advanceSettingsState.isGamingEnabled) ...[
              //     /// Gaming Credentials
              //     HomeCredentialWidget(
              //       title: l10n.gamingCards,
              //       credentials: state.gamingCredentials,
              //       credentialCategory: CredentialCategory.gamingCards,
              //       categorySubtitle: l10n.gamingCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isCommunityEnabled &&
              //       state.communityCredentials.isNotEmpty) ...[
              //     /// Community Credentials
              //     HomeCredentialWidget(
              //       title: l10n.communityCards,
              //       credentials: state.communityCredentials,
              //       credentialCategory: CredentialCategory.communityCards,
              //       categorySubtitle: l10n.communityCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isIdentityEnabled) ...[
              //     /// Identity Credentials
              //     HomeCredentialWidget(
              //       title: l10n.identityCards,
              //       credentials: state.identityCredentials,
              //       credentialCategory: CredentialCategory.identityCards,
              //       categorySubtitle: l10n.identityCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isEducationEnabled &&
              //       state.educationCredentials.isNotEmpty) ...[
              //     /// Education Credentials
              //     HomeCredentialWidget(
              //       title: l10n.educationCredentials,
              //       credentials: state.educationCredentials,
              //       credentialCategory: CredentialCategory.educationCards,
              //       categorySubtitle: l10n.educationCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isPassEnabled &&
              //       state.passCredentials.isNotEmpty) ...[
              //     /// Pass Credentials
              //     HomeCredentialWidget(
              //       title: l10n.pass,
              //       credentials: state.passCredentials,
              //       categorySubtitle: l10n.passCredentialHomeSubtitle,
              //       credentialCategory: CredentialCategory.passCards,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (state.myProfessionalCredentials.isNotEmpty) ...[
              //     /// My Professional Credentials
              //     HomeCredentialWidget(
              //       title: l10n.myProfessionalrCards,
              //       credentials: state.myProfessionalCredentials,
              //       credentialCategory: CredentialCategory.myProfessionalCards,
              //       categorySubtitle: l10n.myProfessionalrCardsSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isOtherEnabled &&
              //       state.othersCredentials.isNotEmpty) ...[
              //     /// Other Credentials
              //     HomeCredentialWidget(
              //       title: l10n.otherCards,
              //       credentials: state.othersCredentials,
              //       credentialCategory: CredentialCategory.othersCards,
              //       categorySubtitle: l10n.otherCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              //   if (advanceSettingsState.isBlockchainAccountsEnabled &&
              //       state.blockchainAccountsCredentials.isNotEmpty) ...[
              //     /// BlockchainAccounts Credentials
              //     HomeCredentialWidget(
              //       title: l10n.blockchainAccounts,
              //       credentials: state.blockchainAccountsCredentials,
              //       credentialCategory:
              //           CredentialCategory.blockchainAccountsCards,
              //       categorySubtitle:
              //           l10n.blockchainAccountsCredentialHomeSubtitle,
              //     ),
              //     const SizedBox(height: Sizes.spaceNormal),
              //   ],
              // ],
            ),
          ),
        );
      },
    );
  }
}
