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
            // Row(
            //   children: const [
            //     Spacer(),
            //     GetCardsWidget(),
            //     Spacer(),
            //   ],
            // ),
            if (state.gamingCredentials.isNotEmpty) ...[
              GamingCredentials(credentials: state.gamingCredentials),
              const SizedBox(height: 10),
            ],
            if (state.communityCredentials.isNotEmpty) ...[
              CommunityCredentials(credentials: state.communityCredentials),
              const SizedBox(height: 10),
            ],
            if (state.identityCredentials.isNotEmpty) ...[
              IdentityCredentials(credentials: state.identityCredentials),
              const SizedBox(height: 10),
            ],
            if (state.identityCredentials.isNotEmpty) ...[
              OtherCredentials(credentials: state.othersCredentials),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    );
  }
}
