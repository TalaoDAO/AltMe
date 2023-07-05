enum WCV2SignType {
  message,
  personalMessage,
  typedMessageV2,
  typedMessageV3,
  typedMessageV4,
}

class EthereumSignMessage {
  const EthereumSignMessage({
    required this.data,
    required this.address,
    required this.type,
  });

  final String data;
  final String address;
  final WCV2SignType type;
}
