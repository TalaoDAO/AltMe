import 'package:altme/app/shared/constants/sizes.dart';
import 'package:altme/app/shared/enum/credential_category.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/list/widgets/home_credential_item.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_model/credential_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/credential_widget/add_credential_button.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class CredentialListWidget extends StatelessWidget {
  const CredentialListWidget({
    super.key,
    required this.sortedCredentials,
    required this.credentialCategory,
  });

  final List<CredentialModel> sortedCredentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    return CredentialListStack(
      sortedCredentials: sortedCredentials,
      credentialCategory: credentialCategory,
    );
  }
}

class CredentialListGrid extends StatelessWidget {
  const CredentialListGrid({
    super.key,
    required this.sortedCredentials,
    required this.credentialCategory,
  });

  final List<CredentialModel> sortedCredentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
    );
  }
}

class CredentialListStack extends StatelessWidget {
  const CredentialListStack({
    super.key,
    required this.sortedCredentials,
    required this.credentialCategory,
  });

  final List<CredentialModel> sortedCredentials;
  final CredentialCategory credentialCategory;

  @override
  Widget build(BuildContext context) {
    const double cardHeight = 150;
    return SizedBox(
      height: 200,
      child: Swiper(
        scrollDirection: Axis.horizontal,
        loop: false,
        containerHeight: 200,
        containerWidth: 150,
        itemHeight: cardHeight,
        itemWidth: cardHeight * 1.586,
        layout: SwiperLayout.CUSTOM,
        customLayoutOption: CustomLayoutOption(startIndex: -1, stateCount: 3)
          ..addRotate([-60.0 / 180, 0.0, 60.0 / 180])
          ..addTranslate(
              [Offset(-210.0, -20.0), Offset(0.0, 0.0), Offset(210.0, -20.0)]),
        itemBuilder: (BuildContext context, int index) {
          return HomeCredentialItem(
            credentialModel: sortedCredentials[index],
          );
        },
        itemCount: sortedCredentials.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    );
  }
}
