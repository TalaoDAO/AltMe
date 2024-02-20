import 'package:altme/l10n/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum CredentialCategory {
  advantagesCards,
  identityCards,
  professionalCards,
  contactInfoCredentials,
  educationCards,
  financeCards,
  humanityProofCards,
  socialMediaCards,
  walletIntegrity,
  blockchainAccountsCards,
  othersCards,
  polygonidCards,
  pendingCards,
}

List<CredentialCategory> get getCredentialCategorySorted {
  final values = List<CredentialCategory>.from(CredentialCategory.values);
  return values
    ..sort((a, b) {
      final aOrder = a.order;
      final bOrder = b.order;
      return aOrder > bOrder ? 0 : 1;
    });
}

extension CredentialCategoryX on CredentialCategory {
  int get order {
    switch (this) {
      case CredentialCategory.advantagesCards:
        return 8;
      case CredentialCategory.identityCards:
        return 140;
      case CredentialCategory.professionalCards:
        return 135;
      case CredentialCategory.contactInfoCredentials:
        return 130;
      case CredentialCategory.blockchainAccountsCards:
        return 70;
      case CredentialCategory.educationCards:
        return 120;
      case CredentialCategory.othersCards:
        return 10;
      case CredentialCategory.financeCards:
        return 110;
      case CredentialCategory.humanityProofCards:
        return 100;
      case CredentialCategory.socialMediaCards:
        return 90;
      case CredentialCategory.walletIntegrity:
        return 80;
      case CredentialCategory.polygonidCards:
        return 75;
      case CredentialCategory.pendingCards:
        return 9;
    }
  }

  bool get showInHomeIfListEmpty {
    switch (this) {
      case CredentialCategory.advantagesCards:
      case CredentialCategory.identityCards:
        return true;
      case CredentialCategory.professionalCards:
      case CredentialCategory.contactInfoCredentials:
      case CredentialCategory.blockchainAccountsCards:
      case CredentialCategory.educationCards:
      case CredentialCategory.othersCards:
      case CredentialCategory.financeCards:
      case CredentialCategory.humanityProofCards:
      case CredentialCategory.socialMediaCards:
      case CredentialCategory.walletIntegrity:
      case CredentialCategory.polygonidCards:
      case CredentialCategory.pendingCards:
        return false;
    }
  }

  CredentialCategoryConfig config(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialCategory.advantagesCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.advantagesCards.toLowerCase()}',
          homeSubTitle: l10n.advantagesCredentialHomeSubtitle,
          discoverTitle: l10n.advantagesDiscoverCards,
          discoverSubTitle: l10n.advantagesCredentialDiscoverSubtitle,
        );
      case CredentialCategory.identityCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.identityCards.toLowerCase()}',
          homeSubTitle: l10n.identityCredentialHomeSubtitle,
          discoverTitle: l10n.identityDiscoverCards,
          discoverSubTitle: l10n.identityCredentialDiscoverSubtitle,
        );
      case CredentialCategory.professionalCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.myProfessionalCards.toLowerCase()}',
          homeSubTitle: l10n.myProfessionalrCardsSubtitle,
          discoverTitle: l10n.myProfessionalCredentialDiscoverSubtitle,
          discoverSubTitle: l10n.myProfessionalCredentialDiscoverSubtitle,
        );
      case CredentialCategory.contactInfoCredentials:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.contactInfoCredentials.toLowerCase()}',
          homeSubTitle: l10n.contactInfoCredentialHomeSubtitle,
          discoverTitle: l10n.contactInfoDiscoverCredentials,
          discoverSubTitle: l10n.contactInfoCredentialDiscoverSubtitle,
        );
      case CredentialCategory.blockchainAccountsCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.blockchainAccounts.toLowerCase()}',
          homeSubTitle: l10n.blockchainAccountsCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.blockchainAccounts.toLowerCase()}',
          discoverSubTitle: '',
        );
      case CredentialCategory.educationCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.educationCredentials.toLowerCase()}',
          homeSubTitle: l10n.educationCredentialHomeSubtitle,
          discoverTitle: l10n.educationDiscoverCredentials,
          discoverSubTitle: l10n.educationCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.othersCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.otherCards.toLowerCase()}',
          homeSubTitle: l10n.otherCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.otherCards.toLowerCase()}',
          discoverSubTitle: l10n.otherCredentialDiscoverSubtitle,
        );
      case CredentialCategory.financeCards:
        return CredentialCategoryConfig(
          homeTitle: l10n.financeCredentialsHomeTitle,
          homeSubTitle: l10n.financeCredentialsHomeSubtitle,
          discoverTitle: l10n.financeCredentialsDiscoverTitle,
          discoverSubTitle: l10n.financeCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.humanityProofCards:
        return CredentialCategoryConfig(
          homeTitle: l10n.hummanityProofCredentialsHomeTitle,
          homeSubTitle: l10n.hummanityProofCredentialsHomeSubtitle,
          discoverTitle: l10n.hummanityProofCredentialsDiscoverTitle,
          discoverSubTitle: l10n.hummanityProofCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.socialMediaCards:
        return CredentialCategoryConfig(
          homeTitle: l10n.socialMediaCredentialsHomeTitle,
          homeSubTitle: l10n.socialMediaCredentialsHomeSubtitle,
          discoverTitle: l10n.socialMediaCredentialsDiscoverTitle,
          discoverSubTitle: l10n.socialMediaCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.walletIntegrity:
        return CredentialCategoryConfig(
          homeTitle: l10n.walletIntegrityCredentialsHomeTitle,
          homeSubTitle: l10n.walletIntegrityCredentialsHomeSubtitle,
          discoverTitle: l10n.walletIntegrityCredentialsDiscoverTitle,
          discoverSubTitle: l10n.walletIntegrityCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.polygonidCards:
        return CredentialCategoryConfig(
          homeTitle: l10n.polygonCredentialsHomeTitle,
          homeSubTitle: l10n.polygonCredentialsHomeSubtitle,
          discoverTitle: l10n.polygonCredentialsDiscoverTitle,
          discoverSubTitle: l10n.polygonCredentialsDiscoverSubtitle,
        );
      case CredentialCategory.pendingCards:
        return CredentialCategoryConfig(
          homeTitle: l10n.pendingCredentialsHomeTitle,
          homeSubTitle: l10n.pendingCredentialsHomeSubtitle,
          discoverTitle: '',
          discoverSubTitle: '',
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
  });

  final String homeTitle;
  final String homeSubTitle;
  final String discoverTitle;
  final String discoverSubTitle;

  @override
  List<Object?> get props => [
        homeTitle,
        homeSubTitle,
        discoverTitle,
        discoverSubTitle,
      ];
}
