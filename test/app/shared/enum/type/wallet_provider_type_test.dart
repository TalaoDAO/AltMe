import 'package:altme/app/app.dart';
import 'package:test/test.dart';

void main() {
  group('WalletProviderType Extension Tests', () {
    test('WalletProviderType url returns correct value', () {
      expect(WalletProviderType.Talao.url, equals(Urls.walletProvider));
      expect(WalletProviderType.Test.url, equals(Urls.walletTestProvider));
    });

    test('WalletProviderType formattedString returns correct value', () {
      expect(WalletProviderType.Talao.formattedString, equals('Talao'));
      expect(WalletProviderType.Test.formattedString, equals('Test'));
    });
  });
}
