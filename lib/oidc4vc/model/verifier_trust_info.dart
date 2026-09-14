import 'package:equatable/equatable.dart';

/// Verifier display name and trust status resolved once, when the user
/// first connects to the verifier, and carried through to the
/// share-information confirmation screen so it isn't re-derived (and
/// re-fetched) a second time.
class VerifierTrustInfo extends Equatable {
  const VerifierTrustInfo({
    required this.name,
    required this.isTrusted,
    this.purpose,
  });

  final String name;
  final bool isTrusted;
  final String? purpose;

  @override
  List<Object?> get props => [name, isTrusted, purpose];
}
