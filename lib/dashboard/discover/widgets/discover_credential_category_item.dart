import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class DiscoverCredentialCategoryItem extends StatelessWidget {
  const DiscoverCredentialCategoryItem({
    super.key,
    required this.dummyCredentials,
    required this.credentialCategory,
  });

  final List<DiscoverDummyCredential> dummyCredentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    final credentialCategoryConfig = credentialCategory.config(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: Text(
            credentialCategoryConfig.discoverTitle,
            style: Theme.of(context).textTheme.credentialCategoryTitle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: Text(
            credentialCategoryConfig.discoverSubTitle,
            maxLines: 3,
            style: Theme.of(context).textTheme.credentialCategorySubTitle,
          ),
        ),
        const SizedBox(height: 4),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: dummyCredentials.length,
          itemBuilder: (_, index) {
            return DiscoverCredentialItem(
              dummyCredential: dummyCredentials[index],
            );
          },
        ),
      ],
    );
  }
}
