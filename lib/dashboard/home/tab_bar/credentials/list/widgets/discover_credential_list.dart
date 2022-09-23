import 'package:altme/dashboard/dashboard.dart';
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
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          if (state.gamingCredentials.isNotEmpty) ...[
            GamingCredentials(
              credentials: state.gamingCredentials,
              isDiscover: true,
            ),
            const SizedBox(height: 10),
          ],
          if (state.communityCredentials.isNotEmpty) ...[
            CommunityCredentials(
              credentials: state.communityCredentials,
              isDiscover: true,
            ),
            const SizedBox(height: 10),
          ],
          if (state.identityCredentials.isNotEmpty) ...[
            IdentityCredentials(
              credentials: state.identityCredentials,
              isDiscover: true,
            ),
            const SizedBox(height: 10),
          ],
          // ProofOfOwnershipCredentials is hidden. Later we will
          // give user an option to show it
          //  if (state.proofOfOwnershipCredentials.isNotEmpty) ...[
          //   ProofOfOwnershipCredentials(
          //     credentials: state.proofOfOwnershipCredentials,
          //     isDiscover: true,
          //   ),
          //   const SizedBox(height: 10),
          // ],
          if (state.othersCredentials.isNotEmpty) ...[
            OtherCredentials(
              credentials: state.othersCredentials,
              isDiscover: true,
            ),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
