import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';

class HomeCredentialCategoryItem extends StatelessWidget {
  const HomeCredentialCategoryItem({
    super.key,
    required this.credentials,
    required this.credentialCategory,
    this.margin = const EdgeInsets.only(
      bottom: Sizes.spaceNormal,
    ),
  });

  final List<CredentialModel> credentials;
  final CredentialCategory credentialCategory;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    //sort credentials by order
    final sortedCredentials = List.of(credentials)
      ..sort(
        (a, b) => a.credentialPreview.credentialSubjectModel
                    .credentialSubjectType.order <
                b.credentialPreview.credentialSubjectModel.credentialSubjectType
                    .order
            ? 1
            : 0,
      );
    final credentialCategoryConfig = credentialCategory.config(context);
    return Padding(
      padding: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            child: Text(
              credentialCategoryConfig.homeTitle,
              style: Theme.of(context).textTheme.credentialCategoryTitle,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            child: Text(
              credentialCategoryConfig.homeSubTitle,
              maxLines: 3,
              style: Theme.of(context).textTheme.credentialCategorySubTitle,
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
            itemCount: sortedCredentials.length + 1,
            itemBuilder: (_, index) {
              if (index == sortedCredentials.length) {
                if (credentialCategory == CredentialCategory.pendingCards) {
                  return Container();
                }
                return AddCredentialButton(
                  credentialCategory: credentialCategory,
                );
              } else {
                return HomeCredentialItem(
                  credentialModel: sortedCredentials[index],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
