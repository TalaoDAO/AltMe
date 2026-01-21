/// Decodes an ERC-20 transfer transaction input (0xa9059cbb...)
/// and prints the recipient + amount.
BigInt decodeErc20Transfer({required String txData}) {
  // Sanity check
  if (!txData.startsWith('0xa9059cbb')) {
    throw ArgumentError('Not an ERC20 transfer() call');
  }

  // Remove the selector (first 4 bytes = 8 hex chars + "0x")
  final data = txData.substring(10);

  // Each parameter is 32 bytes = 64 hex chars
  final amountHex = data.substring(64, 128);

  // Decode amount
  final amount = BigInt.parse(amountHex, radix: 16);
  return amount;
}
