import 'package:altme/onboarding/recovery/widgets/import_wallet_types.dart';

class WalletTypeModel {
  WalletTypeModel({
    required this.name,
    required this.type,
    required this.imagePath,
  });

  final String name;
  final ImportWalletTypes type;
  final String imagePath;
}
