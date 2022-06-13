enum AddressType { XTZ, ETH, EBSI, Unknown }

class DidKeyHelper {
  DidKeyHelper(this.did) {
    _validateDID(did);
  }

  final String did;

  void _validateDID(String did) {
    final splitDID = did.split(':');
    if (splitDID.length != 3) {
      throw Exception('Invalid DID key');
    }
  }

  String getPublicKey() {
    final splitDID = did.split(':');
    return splitDID.last;
  }

  String? getAddress() {
    final splitDID = did.split(':');
    final contractSymbol = splitDID[2];

    switch (contractSymbol) {
      case 'key':
        // TODO(all): implement get address of public key of "key ???"
        return '';
      case 'tz':
        // TODO(all): implement get address of public key of "tz"
        return '';
      case 'eth':
        // TODO(all): implement get address of public key of "eth"
        return '';
      case 'ebsi':
        // TODO(all): implement get address of public key of "ebsi"
        return '';
      default:
        Exception('Not Implemented Error');
    }
  }

  AddressType getAddressType() {
    final splitDID = did.split(':');
    final contractSymbol = splitDID[2];

    switch (contractSymbol) {
      case 'key':
        // TODO(all): how to detect the type of address???
        return AddressType.Unknown;
      case 'tz':
        return AddressType.XTZ;
      case 'eth':
        return AddressType.ETH;
      case 'ebsi':
        return AddressType.EBSI;
      default:
        return AddressType.Unknown;
    }
  }
}
