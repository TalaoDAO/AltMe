/// The portrait claim shown on the card of an SD-JWT or mdoc credential.
///
/// [key] and [parentKeyId] locate the claim the way the selective disclosure
/// display map does (for an mdoc, [parentKeyId] is the name space), so the
/// claim can be left out of the attribute list below the card.
class PortraitClaim {
  const PortraitClaim({
    required this.key,
    required this.parentKeyId,
    required this.data,
  });

  final String key;
  final String? parentKeyId;

  /// The image, as a `data:` URI or as base64.
  final String data;
}
