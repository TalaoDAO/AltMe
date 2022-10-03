import 'package:arago_wallet/dashboard/dashboard.dart';
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
          CommunityCredentials(credentials: state.communityCredentials),
          IdentityCredentials(credentials: state.identityCredentials),
          OtherCredentials(credentials: state.othersCredentials),
        ],
      ),
    );
  }
}
