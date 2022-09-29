import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter/material.dart';

class DiscoverCredentialList extends StatelessWidget {
  const DiscoverCredentialList({
    Key? key,
    required this.state,
    required this.onRefresh,
  }) : super(key: key);

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
            ),
            const SizedBox(height: 10),
          ],
          if (state.communityCredentials.isNotEmpty) ...[
            /// Community Credentials
            HomeCredentialWidget(
              title: l10n.communityCards,
              credentials: state.communityCredentials,
            ),
            const SizedBox(height: 10),
          ],
          if (state.identityCredentials.isNotEmpty) ...[
            /// Identity Credentials
            HomeCredentialWidget(
              title: l10n.identityCards,
              credentials: state.identityCredentials,
            ),
            const SizedBox(height: 10),
          ],
          // Note: ProofOfOwnershipCredentials is hidden. Later we will
          // give user an option to show it
          // if (state.proofOfOwnershipCredentials.isNotEmpty) ...[
          //   /// ProofOfOwnership Credentials
          //   HomeCredentialWidget(
          //     title: l10n.proofOfOwnership,
          //     credentials: state.proofOfOwnershipCredentials,
          //   ),
          //   const SizedBox(height: 10),
          // ],
          if (state.othersCredentials.isNotEmpty) ...[
            /// Other Credentials
            HomeCredentialWidget(
              title: l10n.otherCards,
              credentials: state.othersCredentials,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
