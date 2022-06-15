import 'package:altme/home/tab_bar/credentials/list/cubit/credential_list_cubit.dart';
import 'package:altme/home/tab_bar/credentials/list/widgets/community_credentials.dart';
import 'package:altme/home/tab_bar/credentials/list/widgets/game_credentials.dart';
import 'package:altme/home/tab_bar/credentials/list/widgets/identity_credentials.dart';
import 'package:altme/home/tab_bar/credentials/list/widgets/other_credentials.dart';
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GamingCredentials(credentials: state.gamingCredentials),
            const SizedBox(height: 10),
            CommunityCredentials(credentials: state.communityCredentials),
            const SizedBox(height: 10),
            IdentityCredentials(credentials: state.identityCredentials),
            const SizedBox(height: 10),
            OtherCredentials(credentials: state.othersCredentials),
          ],
        ),
      ),
    );
  }
}
