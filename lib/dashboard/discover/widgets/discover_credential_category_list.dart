import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DiscoverCredentialCategoryList extends StatelessWidget {
  const DiscoverCredentialCategoryList({
    super.key,
    required this.onRefresh,
    required this.dummyCredentials,
  });

  final RefreshCallback onRefresh;
  final Map<CredentialCategory, List<DiscoverDummyCredential>> dummyCredentials;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        scrollDirection: Axis.vertical,
        children: dummyCredentials.keys
            .where(
          (category) => dummyCredentials[category]?.isNotEmpty ?? false,
        )
            .map(
          (category) {
            return DiscoverCredentialCategoryItem(
              dummyCredentials: dummyCredentials[category] ?? [],
              credentialCategory: category,
            );
          },
        ).toList(),
      ),
    );
  }
}
