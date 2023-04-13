import 'package:altme/app/app.dart';
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
      case CredentialCategory.gamingCards:
        return 100;
      case CredentialCategory.identityCards:
        return 99;
      case CredentialCategory.communityCards:
        return 98;
      case CredentialCategory.blockchainAccountsCards:
        return 97;
      case CredentialCategory.educationCards:
        return 96;
      case CredentialCategory.passCards:
        return 95;
      case CredentialCategory.othersCards:
        return 93;
      case CredentialCategory.myProfessionalCards:
        return 94;
    }
  }

  List<CredentialSubjectType> get discoverCredentialSubjectTypes {
    switch (this) {
      case CredentialCategory.gamingCards:
        return [
          CredentialSubjectType.tezotopiaMembership,
          CredentialSubjectType.chainbornMembership,
          CredentialSubjectType.bloometaPass,
          // CredentialSubjectType.troopezPass,
          // CredentialSubjectType.pigsPass,
          // CredentialSubjectType.matterlightPass,
          // CredentialSubjectType.dogamiPass,
          // CredentialSubjectType.bunnyPass,
        ];
      case CredentialCategory.identityCards:
        return [
          CredentialSubjectType.emailPass,
          //CredentialSubjectType.gender,
          CredentialSubjectType.ageRange,
          CredentialSubjectType.nationality,
          CredentialSubjectType.over18,
          CredentialSubjectType.over15,
          CredentialSubjectType.over13,
          CredentialSubjectType.passportFootprint,
          CredentialSubjectType.verifiableIdCard,
          CredentialSubjectType.phonePass,
          CredentialSubjectType.twitterCard,
        ];
      case CredentialCategory.communityCards:
        return [
          // CredentialSubjectType.talaoCommunityCard
        ];
      case CredentialCategory.blockchainAccountsCards:
        return [];
      case CredentialCategory.educationCards:
        return [];
      case CredentialCategory.passCards:
        return [];
      case CredentialCategory.othersCards:
        return [];
      case CredentialCategory.myProfessionalCards:
        return [];
    }
  }

  bool get showInHome {
    switch (this) {
      case CredentialCategory.gamingCards:
        return true;
      case CredentialCategory.identityCards:
        return true;
      case CredentialCategory.communityCards:
        return true;
      case CredentialCategory.blockchainAccountsCards:
        return true;
      case CredentialCategory.educationCards:
        return true;
      case CredentialCategory.passCards:
        return true;
      case CredentialCategory.othersCards:
        return true;
      case CredentialCategory.myProfessionalCards:
        return true;
    }
  }

  bool get showInDiscover {
    switch (this) {
      case CredentialCategory.gamingCards:
        return true;
      case CredentialCategory.identityCards:
        return true;
      case CredentialCategory.communityCards:
        return true;
      case CredentialCategory.blockchainAccountsCards:
        return true;
      case CredentialCategory.educationCards:
        return true;
      case CredentialCategory.passCards:
        return true;
      case CredentialCategory.othersCards:
        return true;
      case CredentialCategory.myProfessionalCards:
        return true;
    }
  }

  bool get showInHomeIfListEmpty {
    switch (this) {
      case CredentialCategory.gamingCards:
        return true;
      case CredentialCategory.identityCards:
        return true;
      case CredentialCategory.communityCards:
        return false;
      case CredentialCategory.blockchainAccountsCards:
        return false;
      case CredentialCategory.educationCards:
        return false;
      case CredentialCategory.passCards:
        return false;
      case CredentialCategory.othersCards:
        return false;
      case CredentialCategory.myProfessionalCards:
        return false;
    }
  }

  bool get showAddButtonInHome {
    switch (this) {
      case CredentialCategory.gamingCards:
        return true;
      case CredentialCategory.identityCards:
        return true;
      case CredentialCategory.communityCards:
        return true;
      case CredentialCategory.blockchainAccountsCards:
        return true;
      case CredentialCategory.educationCards:
        return true;
      case CredentialCategory.passCards:
        return true;
      case CredentialCategory.othersCards:
        return true;
      case CredentialCategory.myProfessionalCards:
        return true;
    }
  }

  CredentialCategoryConfig config(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case CredentialCategory.gamingCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.gamingCards.toLowerCase()}',
          homeSubTitle: l10n.gamingCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.gamingCards.toLowerCase()}',
          discoverSubTitle: l10n.gamingCredentialDiscoverSubtitle,
        );
      case CredentialCategory.identityCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.identityCards.toLowerCase()}',
          homeSubTitle: l10n.identityCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.identityCards.toLowerCase()}',
          discoverSubTitle: l10n.identityCredentialDiscoverSubtitle,
        );
      case CredentialCategory.communityCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.communityCards.toLowerCase()}',
          homeSubTitle: l10n.communityCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.communityCards.toLowerCase()}',
          discoverSubTitle: l10n.communityCredentialDiscoverSubtitle,
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
          discoverTitle:
              '${l10n.get} ${l10n.educationCredentials.toLowerCase()}',
          discoverSubTitle: '',
        );
      case CredentialCategory.passCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.pass.toLowerCase()}',
          homeSubTitle: l10n.passCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.pass.toLowerCase()}',
          discoverSubTitle: '',
        );
      case CredentialCategory.othersCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.otherCards.toLowerCase()}',
          homeSubTitle: l10n.otherCredentialHomeSubtitle,
          discoverTitle: '${l10n.get} ${l10n.otherCards.toLowerCase()}',
          discoverSubTitle: l10n.otherCredentialDiscoverSubtitle,
        );
      case CredentialCategory.myProfessionalCards:
        return CredentialCategoryConfig(
          homeTitle: '${l10n.my} ${l10n.myProfessionalCards.toLowerCase()}',
          homeSubTitle: l10n.myProfessionalrCardsSubtitle,
          discoverTitle:
              '${l10n.get} ${l10n.myProfessionalCards.toLowerCase()}',
          discoverSubTitle: l10n.myProfessionalCredentialDiscoverSubtitle,
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
