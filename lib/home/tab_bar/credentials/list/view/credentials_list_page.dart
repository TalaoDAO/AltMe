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
    return BasePage(
      scrollView: false,
      padding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).colorScheme.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: const [
          Expanded(child: GamingCredentials()),
          Expanded(child: CommunityCredentials()),
          Expanded(child: IdentityCredentials()),
          Expanded(child: OtherCredentials()),
        ],
      ),
    );
  }
}

class GamingCredentials extends StatelessWidget {
  const GamingCredentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        var _credentialList = <CredentialModel>[];
        _credentialList = state.credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialCategory ==
                  CredentialCategory.gamingCards,
            )
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.gamingCards} (${_credentialList.length})',
              style: Theme.of(context).textTheme.credentialCategoryTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2,
                ),
                itemCount: _credentialList.length,
                itemBuilder: (_, index) => CredentialsListPageItem(
                  credentialModel: _credentialList[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CommunityCredentials extends StatelessWidget {
  const CommunityCredentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final l10n = context.l10n;
        var _credentialList = <CredentialModel>[];
        _credentialList = state.credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialCategory ==
                  CredentialCategory.communityCards,
            )
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.communityCards} (${_credentialList.length})',
              style: Theme.of(context).textTheme.credentialCategoryTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2,
                ),
                itemCount: _credentialList.length,
                itemBuilder: (_, index) => CredentialsListPageItem(
                  credentialModel: _credentialList[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class IdentityCredentials extends StatelessWidget {
  const IdentityCredentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final l10n = context.l10n;
        var _credentialList = <CredentialModel>[];
        _credentialList = state.credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialCategory ==
                  CredentialCategory.identityCards,
            )
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.identityCards} (${_credentialList.length})',
              style: Theme.of(context).textTheme.credentialCategoryTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2,
                ),
                itemCount: _credentialList.length,
                itemBuilder: (_, index) => CredentialsListPageItem(
                  credentialModel: _credentialList[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class OtherCredentials extends StatelessWidget {
  const OtherCredentials({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final l10n = context.l10n;
        var _credentialList = <CredentialModel>[];
        _credentialList = state.credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialCategory ==
                  CredentialCategory.othersCards,
            )
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.otherCards} (${_credentialList.length})',
              style: Theme.of(context).textTheme.credentialCategoryTitle,
            ),
            const SizedBox(
              height: 8,
            ),
            Flexible(
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1.2,
                ),
                itemCount: _credentialList.length,
                itemBuilder: (_, index) => CredentialsListPageItem(
                  credentialModel: _credentialList[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
