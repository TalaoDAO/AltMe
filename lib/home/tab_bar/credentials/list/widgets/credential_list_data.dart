import 'package:altme/home/home.dart';
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
            Row(
              children: const [
                Spacer(),
                GetCardsWidget(),
                Spacer(),
              ],
            ),
            if (state.gamingCredentials.isNotEmpty) ...[
              const SizedBox(height: 10),
              GamingCredentials(credentials: state.gamingCredentials),
            ],
            if (state.communityCredentials.isNotEmpty) ...[
              const SizedBox(height: 10),
              CommunityCredentials(credentials: state.communityCredentials),
            ],
            if (state.identityCredentials.isNotEmpty) ...[
              const SizedBox(height: 10),
              IdentityCredentials(credentials: state.identityCredentials),
            ],
            if (state.identityCredentials.isNotEmpty) ...[
              const SizedBox(height: 10),
              OtherCredentials(credentials: state.othersCredentials),
            ],
          ],
        ),
      ),
    );
  }
}
