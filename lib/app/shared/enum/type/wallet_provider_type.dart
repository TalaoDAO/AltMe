import 'package:altme/app/app.dart';

enum WalletProviderType { Talao, Test }

extension WalletProviderTypeX on WalletProviderType {
  String get url {
    switch (this) {
      case WalletProviderType.Talao:
        return Urls.walletProvider;
      case WalletProviderType.Test:
        return Urls.walletTestProvider;
    }
  }

  String get formattedString {
    switch (this) {
      case WalletProviderType.Talao:
        return 'Talao';
      case WalletProviderType.Test:
        return 'Test';
    }
  }
}
