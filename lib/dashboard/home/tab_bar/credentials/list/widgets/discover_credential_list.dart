import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DiscoverCredentialList extends StatelessWidget {
  const DiscoverCredentialList({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final CredentialListState state;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          if (state.gamingCredentials.isNotEmpty) ...[
            /// Gaming Credentials
            HomeCredentialWidget(
              title: l10n.gamingCards,
              credentials: state.gamingCredentials,
              fromDiscover: true,
              categorySubtitle: l10n.gamingCredentialDiscoverSubtitle,
            ),
            const SizedBox(height: Sizes.spaceNormal),
          ],
          if (state.communityCredentials.isNotEmpty) ...[
            /// Community Credentials
            HomeCredentialWidget(
              title: l10n.communityCards,
              credentials: state.communityCredentials,
              fromDiscover: true,
              categorySubtitle: l10n.communityCredentialDiscoverSubtitle,
            ),
            const SizedBox(height: Sizes.spaceNormal),
          ],
          if (state.identityCredentials.isNotEmpty) ...[
            /// Identity Credentials
            HomeCredentialWidget(
              title: l10n.identityCards,
              credentials: state.identityCredentials,
              fromDiscover: true,
              categorySubtitle: l10n.identityCredentialDiscoverSubtitle,
            ),
            const SizedBox(height: Sizes.spaceNormal),
          ],
          if (state.myProfessionalCategories.isNotEmpty) ...[
            /// Professional Credentials
            HomeCredentialWidget(
              title: l10n.myProfessionalCards,
              credentials: state.myProfessionalCredentials,
              fromDiscover: true,
              categorySubtitle: l10n.myProfessionalCredentialDiscoverSubtitle,
            ),
            const SizedBox(height: Sizes.spaceNormal),
          ],
          // Note: ProofOfOwnershipCredentials is hidden. Later we will
          // give user an option to show it
          // if (state.proofOfOwnershipCredentials.isNotEmpty) ...[
          //   /// ProofOfOwnership Credentials
          //   HomeCredentialWidget(
          //     title: l10n.proofOfOwnership,
          //     credentials: state.proofOfOwnershipCredentials,
          //     fromDiscover: true,
          //   ),
          //   const SizedBox(height: Sizes.spaceNormal),
          // ],
          if (state.othersCredentials.isNotEmpty) ...[
            /// Other Credentials
            HomeCredentialWidget(
              title: l10n.otherCards,
              credentials: state.othersCredentials,
              fromDiscover: true,
              categorySubtitle: l10n.otherCredentialDiscoverSubtitle,
            ),
            const SizedBox(height: Sizes.spaceNormal),
          ],
        ],
      ),
    );
  }
}
