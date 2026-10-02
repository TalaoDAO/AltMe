import 'package:wallet/wallet.dart';

mixin WalletAddressValidator {
  bool _validEtherumAddress(String ethereumAddress) {
    try {
      EthereumAddress.fromHex(ethereumAddress);
      return true;
    } catch (_) {
      return false;
    }
  }

  bool validateWalletAddress(String? address) {
    if (address == null || address.isEmpty) {
      return false;
    } else if (address.startsWith('0x')) {
      final isValid = _validEtherumAddress(address);
      return isValid;
    } else if (address.startsWith('tz')) {
      return address.length > 8;
    } else {
      // The wallet not support other blockchains
      return false;
    }
  }
}
