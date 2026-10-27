import 'package:altme/app/app.dart';
import 'package:altme/mdoc_proximity/helpers/reader_issuer.dart';
import 'package:altme/oidc4vc/helper_function/resolve_issuer_display.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:trusted_list/trusted_list.dart';

/// Who issued a document the reader received.
class ReaderIssuerState extends Equatable {
  /// Creates the state.
  const ReaderIssuerState({required this.isTrusted, this.name, this.logoUri});

  /// Whether the issuer is trusted: its chain passed the ISO/IEC 18013-5
  /// checks, or the trusted list vouches for it as in OIDC4VCI issuance (see
  /// `readerTrustedIssuer`).
  final bool isTrusted;

  /// The issuer's name, from its metadata.
  final String? name;

  /// The issuer's logo, from its metadata.
  final String? logoUri;

  @override
  List<Object?> get props => [isTrusted, name, logoUri];
}

/// Decides whether the issuer of one received document is trusted, then
/// looks up its name and logo in its OpenID4VCI metadata, as the
/// issuer-connect dialog shows them.
class ReaderIssuerCubit extends Cubit<ReaderIssuerState> {
  /// Creates the cubit; the trust verdict is in the first state.
  factory ReaderIssuerCubit({
    required ReaderDocument document,
    required TrustedList? trustedList,
    required IssuerMetadataFetcher fetchIssuerMetadata,
    required String languageCode,
  }) {
    final trustedIssuer = readerTrustedIssuer(
      trustedList: trustedList,
      document: document,
    );
    return ReaderIssuerCubit._(
      isTrusted: document.isIssuerTrusted || trustedIssuer != null,
      issuerUrls: readerIssuerUrls(
        document: document,
        trustedIssuer: trustedIssuer,
      ),
      fetchIssuerMetadata: fetchIssuerMetadata,
      languageCode: languageCode,
    );
  }

  ReaderIssuerCubit._({
    required bool isTrusted,
    required this.issuerUrls,
    required IssuerMetadataFetcher fetchIssuerMetadata,
    required String languageCode,
  }) : _fetchIssuerMetadata = fetchIssuerMetadata,
       _languageCode = languageCode,
       super(ReaderIssuerState(isTrusted: isTrusted));

  /// Where the issuer's metadata is looked for, in order.
  final List<String> issuerUrls;

  final IssuerMetadataFetcher _fetchIssuerMetadata;
  final String _languageCode;
  final _log = getLogger('ReaderIssuerCubit');

  /// Looks up the issuer's name and logo at the first of [issuerUrls] that
  /// serves metadata. Without one, the state keeps no name and no logo.
  Future<void> resolveDisplay() async {
    for (final url in issuerUrls) {
      try {
        final metadata = await _fetchIssuerMetadata(url);
        final display = resolveIssuerDisplay(
          issuerOpenIdConfiguration: metadata,
          locale: _languageCode,
          fallbackHost: Uri.parse(url).host,
        );
        if (isClosed) return;
        emit(
          ReaderIssuerState(
            isTrusted: state.isTrusted,
            name: display.name,
            logoUri: display.logoUri,
          ),
        );
        return;
      } on Object catch (e) {
        _log.i('no issuer metadata at $url: $e');
      }
    }
  }
}
