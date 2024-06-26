import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';

import 'package:flutter/material.dart';

class DiscoverCredentialCategoryItem extends StatelessWidget {
  const DiscoverCredentialCategoryItem({
    super.key,
    required this.dummyCredentials,
    required this.credentialCategory,
    this.margin = const EdgeInsets.only(bottom: Sizes.spaceNormal),
  });

  final List<DiscoverDummyCredential> dummyCredentials;
  final CredentialCategory credentialCategory;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    final credentialCategoryConfig = credentialCategory.config(context.l10n);
    //sort credentials by order
    dummyCredentials.sort(
      (a, b) =>
          a.credentialSubjectType.order < b.credentialSubjectType.order ? 1 : 0,
    );

    if (dummyCredentials.isEmpty) {
      return Container();
    }

    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            child: Text(
              credentialCategoryConfig.discoverTitle,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ), 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            child: Text(
              credentialCategoryConfig.discoverSubTitle,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
            ),
          ),
          const SizedBox(height: 14),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: Sizes.credentialAspectRatio,
            ),
            itemCount: dummyCredentials.length,
            itemBuilder: (_, index) {
              final dummyCredential = dummyCredentials[index];

              return DiscoverCredentialItem(
                dummyCredential: dummyCredential,
              );
            },
          ),
        ],
      ),
    );
  }
}
