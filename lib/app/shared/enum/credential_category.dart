import 'package:altme/l10n/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CredentialCategory {
  gamingCards,
  identityCards,
  communityCards,
  blockchainAccountsCards,
  educationCards,
  passCards,
  othersCards,
  myProfessionalCards,
}

List<CredentialCategory> getCredentialsCategories({
  required BuildContext context,
  bool sortedByOrder = true,
}) {
  const values = CredentialCategory.values;
  if (sortedByOrder) {
    values.sort(
      (a, b) {
        final aOrder = a.config(context).order;
        final bOrder = b.config(context).order;
        return aOrder > bOrder ? aOrder : bOrder;
      },
    );
  }
  return values;
}

extension CredentialCategoryX on CredentialCategory {
  CredentialCategoryConfig config(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialCategory.gamingCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.gamingCards}',
          homeSubTitle: l10n.gamingCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.gamingCards}',
          discoverSubTitle: l10n.gamingCredentialDiscoverSubtitle,
          showInDiscover: true,
          showInHome: true,
          showInHomeIfListEmpty: true,
          order: 100,
        );
      case CredentialCategory.identityCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.identityCards}',
          homeSubTitle: l10n.identityCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.identityCards}',
          discoverSubTitle: l10n.identityCredentialDiscoverSubtitle,
          order: 99,
          showInHome: true,
          showInHomeIfListEmpty: true,
          showInDiscover: true,
        );
      case CredentialCategory.communityCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.communityCards}',
          homeSubTitle: l10n.communityCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.communityCards}',
          discoverSubTitle: l10n.communityCredentialDiscoverSubtitle,
          order: 98,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
        );
      case CredentialCategory.blockchainAccountsCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.blockchainAccounts}',
          homeSubTitle: l10n.blockchainAccountsCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.blockchainAccounts}',
          discoverSubTitle: '',
          order: 96,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
        );
      case CredentialCategory.educationCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.educationCredentials}',
          homeSubTitle: l10n.educationCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.educationCredentials}',
          discoverSubTitle: '',
          order: 95,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
          showAddButtonInHome: false,
        );
      case CredentialCategory.passCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.pass}',
          homeSubTitle: l10n.passCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.pass}',
          discoverSubTitle: '',
          order: 94,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
        );
      case CredentialCategory.othersCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.otherCards}',
          homeSubTitle: l10n.otherCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.otherCards}',
          discoverSubTitle: l10n.otherCredentialDiscoverSubtitle,
          order: 97,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
        );
      case CredentialCategory.myProfessionalCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.myProfessionalCards}',
          homeSubTitle: l10n.myProfessionalrCardsSubtitle,
          discoverTitle: '${l10n.get} ${l10n.myProfessionalCards}',
          discoverSubTitle: l10n.myProfessionalCredentialDiscoverSubtitle,
          order: 93,
          showInHome: true,
          showInHomeIfListEmpty: false,
          showInDiscover: true,
        );
    }
  }
}

class CredentialCategoryConfig extends Equatable {
  const CredentialCategoryConfig({
    required this.homeTitle,
    required this.homeSubTitle,
    required this.discoverTitle,
    required this.discoverSubTitle,
    required this.order,
    required this.showInHome,
    required this.showInHomeIfListEmpty,
    required this.showInDiscover,
    this.showAddButtonInHome = true,
  });

  final String homeTitle;
  final String homeSubTitle;
  final String discoverTitle;
  final String discoverSubTitle;
  final int order;
  final bool showInHome;
  final bool showInHomeIfListEmpty;
  final bool showInDiscover;
  final bool showAddButtonInHome;

  @override
  List<Object?> get props => [
        homeTitle,
        homeSubTitle,
        discoverTitle,
        discoverSubTitle,
        order,
        showInHome,
        showInHomeIfListEmpty,
        showInDiscover,
      ];
}
