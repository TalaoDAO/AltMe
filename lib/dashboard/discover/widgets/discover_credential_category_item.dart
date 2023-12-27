import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final discoverCardsOptions = context
        .read<ProfileCubit>()
        .state
        .model
        .profileSetting
        .discoverCardsOptions;

    if (discoverCardsOptions != null &&
        !discoverCardsOptions.displayRewardsCategory &&
        credentialCategory == CredentialCategory.advantagesCards) {
      return Container();
    }

    final credentialCategoryConfig = credentialCategory.config(context);
    //sort credentials by order
    dummyCredentials.sort(
      (a, b) =>
          a.credentialSubjectType.order < b.credentialSubjectType.order ? 1 : 0,
    );
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
              return DiscoverCredentialItem(
                dummyCredential: dummyCredentials[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
