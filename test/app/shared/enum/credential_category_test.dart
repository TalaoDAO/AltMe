import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  final my = 'My';
  @override
  final get = 'Get';
  @override
  final advantagesCards = 'A1';
  @override
  final advantagesCredentialHomeSubtitle = 'A2';
  @override
  final advantagesDiscoverCards = 'A3';
  @override
  final advantagesCredentialDiscoverSubtitle = 'A4';
  @override
  final identityCards = 'A1';
  @override
  final identityCredentialHomeSubtitle = 'A2';
  @override
  final identityDiscoverCards = 'A3';
  @override
  final identityCredentialDiscoverSubtitle = 'A4';

  @override
  final myProfessionalCards = 'A1';
  @override
  final myProfessionalrCardsSubtitle = 'A2';
  @override
  final myProfessionalCredentialDiscoverSubtitle = 'A3';

  @override
  final contactInfoCredentials = 'A1';
  @override
  final contactInfoCredentialHomeSubtitle = 'A2';
  @override
  final contactInfoDiscoverCredentials = 'A3';
  @override
  final contactInfoCredentialDiscoverSubtitle = 'A4';

  @override
  final blockchainAccounts = 'A1';
  @override
  final blockchainAccountsCredentialHomeSubtitle = 'A2';
  @override
  final blockchainCardsDiscoverTitle = 'A3';
  @override
  final blockchainCardsDiscoverSubtitle = 'A4';

  @override
  final educationCredentials = 'A1';
  @override
  final educationCredentialHomeSubtitle = 'A2';
  @override
  final educationDiscoverCredentials = 'A3';
  @override
  final educationCredentialsDiscoverSubtitle = 'A4';

  @override
  final otherCards = 'A1';
  @override
  final otherCredentialHomeSubtitle = 'A2';
  @override
  final otherCredentialDiscoverSubtitle = 'A4';

  @override
  final financeCredentialsHomeTitle = 'A1';
  @override
  final financeCredentialsHomeSubtitle = 'A2';
  @override
  final financeCredentialsDiscoverTitle = 'A3';
  @override
  final financeCredentialsDiscoverSubtitle = 'A4';

  @override
  final hummanityProofCredentialsHomeTitle = 'A1';
  @override
  final hummanityProofCredentialsHomeSubtitle = 'A2';
  @override
  final hummanityProofCredentialsDiscoverTitle = 'A3';
  @override
  final hummanityProofCredentialsDiscoverSubtitle = 'A4';

  @override
  final socialMediaCredentialsHomeTitle = 'A1';
  @override
  final socialMediaCredentialsHomeSubtitle = 'A2';
  @override
  final socialMediaCredentialsDiscoverTitle = 'A3';
  @override
  final socialMediaCredentialsDiscoverSubtitle = 'A4';

  @override
  final walletIntegrityCredentialsHomeTitle = 'A1';
  @override
  final walletIntegrityCredentialsHomeSubtitle = 'A2';
  @override
  final walletIntegrityCredentialsDiscoverTitle = 'A3';
  @override
  final walletIntegrityCredentialsDiscoverSubtitle = 'A4';

  @override
  final polygonCredentialsHomeTitle = 'A1';
  @override
  final polygonCredentialsHomeSubtitle = 'A2';
  @override
  final polygonCredentialsDiscoverTitle = 'A3';
  @override
  final polygonCredentialsDiscoverSubtitle = 'A4';

  @override
  final pendingCredentialsHomeTitle = 'A1';
  @override
  final pendingCredentialsHomeSubtitle = 'A2';
}

void main() {
  test('getCredentialCategorySorted should return categories in sorted order',
      () {
    final sortedCategories = [
      CredentialCategory.identityCards,
      CredentialCategory.professionalCards,
      CredentialCategory.contactInfoCredentials,
      CredentialCategory.educationCards,
      CredentialCategory.financeCards,
      CredentialCategory.humanityProofCards,
      CredentialCategory.socialMediaCards,
      CredentialCategory.walletIntegrity,
      CredentialCategory.polygonidCards,
      CredentialCategory.blockchainAccountsCards,
      CredentialCategory.othersCards,
      CredentialCategory.pendingCards,
      CredentialCategory.advantagesCards,
    ];

    expect(getCredentialCategorySorted, sortedCategories);
  });

  group('CredentialCategoryExtension', () {
    test('order should return correct order for each category', () {
      expect(CredentialCategory.advantagesCards.order, 8);
      expect(CredentialCategory.identityCards.order, 140);
      expect(CredentialCategory.professionalCards.order, 135);
      expect(CredentialCategory.contactInfoCredentials.order, 130);
      expect(CredentialCategory.blockchainAccountsCards.order, 70);
      expect(CredentialCategory.educationCards.order, 120);
      expect(CredentialCategory.othersCards.order, 10);
      expect(CredentialCategory.financeCards.order, 110);
      expect(CredentialCategory.humanityProofCards.order, 100);
      expect(CredentialCategory.socialMediaCards.order, 90);
      expect(CredentialCategory.walletIntegrity.order, 80);
      expect(CredentialCategory.polygonidCards.order, 75);
      expect(CredentialCategory.pendingCards.order, 9);
    });

    test('showInHomeIfListEmpty should return correct value for each category',
        () {
      expect(CredentialCategory.identityCards.showInHomeIfListEmpty, true);
      expect(CredentialCategory.professionalCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.advantagesCards.showInHomeIfListEmpty, false);
      expect(
        CredentialCategory.contactInfoCredentials.showInHomeIfListEmpty,
        false,
      );
      expect(
        CredentialCategory.blockchainAccountsCards.showInHomeIfListEmpty,
        false,
      );
      expect(CredentialCategory.educationCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.othersCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.financeCards.showInHomeIfListEmpty, false);
      expect(
        CredentialCategory.humanityProofCards.showInHomeIfListEmpty,
        false,
      );
      expect(CredentialCategory.socialMediaCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.walletIntegrity.showInHomeIfListEmpty, false);
      expect(CredentialCategory.polygonidCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.pendingCards.showInHomeIfListEmpty, false);
    });

    test('config should return correct configuration for each category', () {
      final localizations = MockAppLocalizations();

      expect(
        CredentialCategory.advantagesCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.identityCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.professionalCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A3',
        ),
      );
      expect(
        CredentialCategory.contactInfoCredentials.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.blockchainAccountsCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.educationCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.othersCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'My a1',
          homeSubTitle: 'A2',
          discoverTitle: 'Get a1',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.financeCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.humanityProofCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.socialMediaCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.walletIntegrity.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.polygonidCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: 'A3',
          discoverSubTitle: 'A4',
        ),
      );
      expect(
        CredentialCategory.pendingCards.config(localizations),
        const CredentialCategoryConfig(
          homeTitle: 'A1',
          homeSubTitle: 'A2',
          discoverTitle: '',
          discoverSubTitle: '',
        ),
      );
    });
  });
}
