import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsListPage extends StatelessWidget {
  const CredentialsListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CredentialSubjectType> gamingCategories = [
      CredentialSubjectType.voucher
    ];
    final List<CredentialSubjectType> communityCategories = [
      CredentialSubjectType.studentCard,
    ];
    final List<CredentialSubjectType> identityCategories = [
      CredentialSubjectType.emailPass,
      CredentialSubjectType.over18,
      CredentialSubjectType.certificateOfEmployment,
      CredentialSubjectType.learningAchievement,
      CredentialSubjectType.phonePass,
    ];
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final gamingCredentials = <HomeCredential>[];
        final communityCredentials = <HomeCredential>[];
        final identityCredentials = <HomeCredential>[];
        final othersCredentials = <HomeCredential>[];

        for (final credential in state.credentials) {
          final CredentialSubjectType credentialSubjectType = credential
              .credentialPreview.credentialSubjectModel.credentialSubjectType;

          switch (credential
              .credentialPreview.credentialSubjectModel.credentialCategory) {
            case CredentialCategory.gamingCards:
              gamingCredentials.add(HomeCredential.isNotDummy(credential));
              if (gamingCategories.contains(credentialSubjectType)) {
                gamingCategories.remove(credentialSubjectType);
              }
              break;
            case CredentialCategory.communityCards:
              communityCredentials.add(HomeCredential.isNotDummy(credential));
              if (communityCategories.contains(credentialSubjectType)) {
                communityCategories.remove(credentialSubjectType);
              }
              break;
            case CredentialCategory.identityCards:
              identityCredentials.add(HomeCredential.isNotDummy(credential));
              if (identityCategories.contains(credentialSubjectType)) {
                identityCategories.remove(credentialSubjectType);
              }
              break;
            case CredentialCategory.othersCards:
              othersCredentials.add(HomeCredential.isNotDummy(credential));
              break;
          }
        }

        for (final credentialSubjectType in gamingCategories) {
          gamingCredentials.add(HomeCredential.isDummy(credentialSubjectType));
        }

        for (final credentialSubjectType in communityCategories) {
          communityCredentials
              .add(HomeCredential.isDummy(credentialSubjectType));
        }

        for (final credentialSubjectType in identityCategories) {
          identityCredentials
              .add(HomeCredential.isDummy(credentialSubjectType));
        }

        return BasePage(
          scrollView: true,
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GamingCredentials(credentials: gamingCredentials),
              const SizedBox(height: 10),
              CommunityCredentials(credentials: communityCredentials),
              const SizedBox(height: 10),
              IdentityCredentials(credentials: identityCredentials),
              const SizedBox(height: 10),
              OtherCredentials(credentials: othersCredentials),
            ],
          ),
        );
      },
    );
  }
}

class GamingCredentials extends StatelessWidget {
  const GamingCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<HomeCredential> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '''${l10n.gamingCards} (${credentials.where((element) => !element.isDummy).toList().length})''',
          style: Theme.of(context).textTheme.credentialCategoryTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => HomeCredentialItem(
            homeCredential: credentials[index],
          ),
        ),
      ],
    );
  }
}

class CommunityCredentials extends StatelessWidget {
  const CommunityCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<HomeCredential> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '''${l10n.communityCards} (${credentials.where((element) => !element.isDummy).toList().length})''',
          style: Theme.of(context).textTheme.credentialCategoryTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => HomeCredentialItem(
            homeCredential: credentials[index],
          ),
        ),
      ],
    );
  }
}

class IdentityCredentials extends StatelessWidget {
  const IdentityCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<HomeCredential> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '''${l10n.identityCards} (${credentials.where((element) => !element.isDummy).toList().length})''',
          style: Theme.of(context).textTheme.credentialCategoryTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => HomeCredentialItem(
            homeCredential: credentials[index],
          ),
        ),
      ],
    );
  }
}

class OtherCredentials extends StatelessWidget {
  const OtherCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<HomeCredential> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '''${l10n.otherCards} (${credentials.where((element) => !element.isDummy).toList().length})''',
          style: Theme.of(context).textTheme.credentialCategoryTitle,
        ),
        const SizedBox(
          height: 8,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4,
            mainAxisSpacing: 4,
            childAspectRatio: Sizes.homeCredentialRatio,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => HomeCredentialItem(
            homeCredential: credentials[index],
          ),
        ),
      ],
    );
  }
}
