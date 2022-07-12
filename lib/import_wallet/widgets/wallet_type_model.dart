import 'package:altme/app/shared/enum/type/import_wallet_types.dart';

class WalletTypeModel {
  WalletTypeModel({
    required this.title,
    required this.walletName,
    required this.type,
    required this.imagePath,
  });

  final String title;
  final String walletName;
  final ImportWalletTypes type;
  final String imagePath;
}
