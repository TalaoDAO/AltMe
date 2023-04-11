import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DiscoverCredentialCategoryList extends StatelessWidget {
  const DiscoverCredentialCategoryList({
    super.key,
    required this.onRefresh,
  });

  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: getCredentialsCategories(context: context).map(
          (category) {
            return DiscoverCredentialCategoryItem(
              dummyCredentials: [], //TODO(Taleb): update the list of dummy items
              credentialCategory: category,
            );
          },
        ).toList(),
        // children: [
        //   if (state.gamingCredentials.isNotEmpty) ...[
        //     /// Gaming Credentials
        //     HomeCredentialWidget(
        //       title: l10n.gamingCards,
        //       credentials: state.gamingCredentials,
        //       fromDiscover: true,
        //       categorySubtitle: l10n.gamingCredentialDiscoverSubtitle,
        //       credentialCategory: CredentialCategory.gamingCards,
        //     ),
        //     const SizedBox(height: Sizes.spaceNormal),
        //   ],
        //   if (state.communityCredentials.isNotEmpty) ...[
        //     /// Community Credentials
        //     HomeCredentialWidget(
        //       title: l10n.communityCards,
        //       credentials: state.communityCredentials,
        //       fromDiscover: true,
        //       categorySubtitle: l10n.communityCredentialDiscoverSubtitle,
        //       credentialCategory: CredentialCategory.communityCards,
        //     ),
        //     const SizedBox(height: Sizes.spaceNormal),
        //   ],
        //   if (state.identityCredentials.isNotEmpty) ...[
        //     /// Identity Credentials
        //     HomeCredentialWidget(
        //       title: l10n.identityCards,
        //       credentials: state.identityCredentials,
        //       fromDiscover: true,
        //       categorySubtitle: l10n.identityCredentialDiscoverSubtitle,
        //       credentialCategory: CredentialCategory.identityCards,
        //     ),
        //     const SizedBox(height: Sizes.spaceNormal),
        //   ],
        //   if (state.myProfessionalCategories.isNotEmpty) ...[
        //     /// Professional Credentials
        //     HomeCredentialWidget(
        //       title: l10n.myProfessionalCards,
        //       credentials: state.myProfessionalCredentials,
        //       fromDiscover: true,
        //       categorySubtitle: l10n.myProfessionalCredentialDiscoverSubtitle,
        //       credentialCategory: CredentialCategory.myProfessionalCards,
        //     ),
        //     const SizedBox(height: Sizes.spaceNormal),
        //   ],
        //   // Note: ProofOfOwnershipCredentials is hidden. Later we will
        //   // give user an option to show it
        //   // if (state.proofOfOwnershipCredentials.isNotEmpty) ...[
        //   //   /// ProofOfOwnership Credentials
        //   //   HomeCredentialWidget(
        //   //     title: l10n.proofOfOwnership,
        //   //     credentials: state.proofOfOwnershipCredentials,
        //   //     fromDiscover: true,
        //   //   ),
        //   //   const SizedBox(height: Sizes.spaceNormal),
        //   // ],
        //   if (state.othersCredentials.isNotEmpty) ...[
        //     /// Other Credentials
        //     HomeCredentialWidget(
        //       title: l10n.otherCards,
        //       credentials: state.othersCredentials,
        //       fromDiscover: true,
        //       categorySubtitle: l10n.otherCredentialDiscoverSubtitle,
        //       credentialCategory: CredentialCategory.othersCards,
        //     ),
        //     const SizedBox(height: Sizes.spaceNormal),
        //   ],
        // ],
      ),
    );
  }
}
