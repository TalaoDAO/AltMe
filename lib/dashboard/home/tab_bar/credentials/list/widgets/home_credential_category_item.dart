import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/list/widgets/credential_list_widget.dart';
import 'package:altme/l10n/l10n.dart';

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
    final credentialCategoryConfig = credentialCategory.config(context.l10n);
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
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
            child: Text(
              credentialCategoryConfig.homeSubTitle,
              maxLines: 3,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w100,
                  ),
            ),
          ),
          const SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 0,
            ),
            child: CredentialListWidget(
              sortedCredentials: sortedCredentials,
              credentialCategory: credentialCategory,
            ),
          ),
        ],
      ),
    );
  }
}
