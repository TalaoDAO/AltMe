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
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final gamingCredentials = <CredentialModel>[];
        final communityCredentials = <CredentialModel>[];
        final identityCredentials = <CredentialModel>[];
        final othersCredentials = <CredentialModel>[];

        for (final credential in state.credentials) {
          switch (credential
              .credentialPreview.credentialSubjectModel.credentialCategory) {
            case CredentialCategory.gamingCards:
              gamingCredentials.add(credential);
              break;
            case CredentialCategory.communityCards:
              communityCredentials.add(credential);
              break;
            case CredentialCategory.identityCards:
              identityCredentials.add(credential);
              break;
            case CredentialCategory.othersCards:
              othersCredentials.add(credential);
              break;
          }
        }

        return BasePage(
          scrollView: true,
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GamingCredentials(credentials: gamingCredentials),
              CommunityCredentials(credentials: communityCredentials),
              IdentityCredentials(credentials: identityCredentials),
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

  final List<CredentialModel> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.gamingCards} (${credentials.length})',
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
            childAspectRatio: 1.2,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => CredentialsListPageItem(
            credentialModel: credentials[index],
          ),
        ),
      ],
    );
  }
}

class CommunityCredentials extends StatelessWidget {
  const CommunityCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<CredentialModel> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.communityCards} (${credentials.length})',
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
            childAspectRatio: 1.2,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => CredentialsListPageItem(
            credentialModel: credentials[index],
          ),
        ),
      ],
    );
  }
}

class IdentityCredentials extends StatelessWidget {
  const IdentityCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<CredentialModel> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.identityCards} (${credentials.length})',
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
            childAspectRatio: 1.2,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => CredentialsListPageItem(
            credentialModel: credentials[index],
          ),
        ),
      ],
    );
  }
}

class OtherCredentials extends StatelessWidget {
  const OtherCredentials({Key? key, required this.credentials})
      : super(key: key);

  final List<CredentialModel> credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${l10n.otherCards} (${credentials.length})',
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
            childAspectRatio: 1.2,
          ),
          itemCount: credentials.length,
          itemBuilder: (_, index) => CredentialsListPageItem(
            credentialModel: credentials[index],
          ),
        ),
      ],
    );
  }
}
