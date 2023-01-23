import 'package:web3dart/web3dart.dart';

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
      return _validEtherumAddress(address);
    } else if (address.startsWith('tz')) {
      // TODO(all): validate tezos address
      return address.length > 8;
    } else {
      // The wallet not support other blockchains
      return false;
    }
  }
}
