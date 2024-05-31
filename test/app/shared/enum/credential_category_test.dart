import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  final my = 'My';
  final get = 'Get';

  final advantagesCards = 'A1';
  final advantagesCredentialHomeSubtitle = 'A2';
  final advantagesDiscoverCards = 'A3';
  final advantagesCredentialDiscoverSubtitle = 'A4';

  final identityCards = 'A1';
  final identityCredentialHomeSubtitle = 'A2';
  final identityDiscoverCards = 'A3';
  final identityCredentialDiscoverSubtitle = 'A4';

  final myProfessionalCards = 'A1';
  final myProfessionalrCardsSubtitle = 'A2';
  final myProfessionalCredentialDiscoverSubtitle = 'A3';

  final contactInfoCredentials = 'A1';
  final contactInfoCredentialHomeSubtitle = 'A2';
  final contactInfoDiscoverCredentials = 'A3';
  final contactInfoCredentialDiscoverSubtitle = 'A4';

  final blockchainAccounts = 'A1';
  final blockchainAccountsCredentialHomeSubtitle = 'A2';
  final blockchainCardsDiscoverTitle = 'A3';
  final blockchainCardsDiscoverSubtitle = 'A4';

  final educationCredentials = 'A1';
  final educationCredentialHomeSubtitle = 'A2';
  final educationDiscoverCredentials = 'A3';
  final educationCredentialsDiscoverSubtitle = 'A4';

  final otherCards = 'A1';
  final otherCredentialHomeSubtitle = 'A2';
  final otherCredentialDiscoverSubtitle = 'A4';

  final financeCredentialsHomeTitle = 'A1';
  final financeCredentialsHomeSubtitle = 'A2';
  final financeCredentialsDiscoverTitle = 'A3';
  final financeCredentialsDiscoverSubtitle = 'A4';

  final hummanityProofCredentialsHomeTitle = 'A1';
  final hummanityProofCredentialsHomeSubtitle = 'A2';
  final hummanityProofCredentialsDiscoverTitle = 'A3';
  final hummanityProofCredentialsDiscoverSubtitle = 'A4';

  final socialMediaCredentialsHomeTitle = 'A1';
  final socialMediaCredentialsHomeSubtitle = 'A2';
  final socialMediaCredentialsDiscoverTitle = 'A3';
  final socialMediaCredentialsDiscoverSubtitle = 'A4';

  final walletIntegrityCredentialsHomeTitle = 'A1';
  final walletIntegrityCredentialsHomeSubtitle = 'A2';
  final walletIntegrityCredentialsDiscoverTitle = 'A3';
  final walletIntegrityCredentialsDiscoverSubtitle = 'A4';

  final polygonCredentialsHomeTitle = 'A1';
  final polygonCredentialsHomeSubtitle = 'A2';
  final polygonCredentialsDiscoverTitle = 'A3';
  final polygonCredentialsDiscoverSubtitle = 'A4';

  final pendingCredentialsHomeTitle = 'A1';
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
      expect(CredentialCategory.contactInfoCredentials.showInHomeIfListEmpty,
          false);
      expect(CredentialCategory.blockchainAccountsCards.showInHomeIfListEmpty,
          false);
      expect(CredentialCategory.educationCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.othersCards.showInHomeIfListEmpty, false);
      expect(CredentialCategory.financeCards.showInHomeIfListEmpty, false);
      expect(
          CredentialCategory.humanityProofCards.showInHomeIfListEmpty, false);
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
