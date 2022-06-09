import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CredentialsListPage extends StatefulWidget {
  const CredentialsListPage({
    Key? key,
  }) : super(key: key);

  @override
  State<CredentialsListPage> createState() => _CredentialsListPageState();
}

class _CredentialsListPageState extends State<CredentialsListPage> {
  @override
  void initState() {
    context.read<CredentialListCubit>().initialise();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CredentialListCubit, CredentialListState>(
      builder: (context, state) {
        return BasePage(
          scrollView: true,
          padding: EdgeInsets.zero,
          backgroundColor: Theme.of(context).colorScheme.transparent,
          body: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GamingCredentials(credentials: state.gamingCredentials),
              const SizedBox(height: 10),
              CommunityCredentials(credentials: state.communityCredentials),
              const SizedBox(height: 10),
              IdentityCredentials(credentials: state.identityCredentials),
              const SizedBox(height: 10),
              OtherCredentials(credentials: state.othersCredentials),
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
