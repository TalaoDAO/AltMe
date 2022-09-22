import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class CredentialListData extends StatelessWidget {
  const CredentialListData({
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
          GamingCredentials(credentials: state.gamingCredentials),
          const SizedBox(height: Sizes.spaceNormal),
          CommunityCredentials(credentials: state.communityCredentials),
          const SizedBox(height: Sizes.spaceNormal),
          IdentityCredentials(credentials: state.identityCredentials),
          const SizedBox(height: Sizes.spaceNormal),
          // ProofOfOwnershipCredentials is hidden. Later we will
          // give user an option to show it
          // if (state.proofOfOwnershipCredentials.isNotEmpty) ...[
          //   ProofOfOwnershipCredentials(
          //     credentials: state.proofOfOwnershipCredentials,
          //   ),
          //   const SizedBox(height: Sizes.spaceNormal),
          // ],
          OtherCredentials(credentials: state.othersCredentials),
          const SizedBox(height: Sizes.spaceNormal),
        ],
      ),
    );
  }
}
