import 'package:altme/app/app.dart';
import 'package:altme/mdoc_proximity/helpers/reader_issuer.dart';
import 'package:altme/oidc4vc/helper_function/resolve_issuer_display.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

/// Who issued a document the reader received, and how they display it.
class ReaderIssuerState extends Equatable {
  /// Creates the state.
  const ReaderIssuerState({
    required this.isTrusted,
    this.name,
    this.logoUri,
    this.credentialDisplay,
    this.credentialSupported,
  });

  /// Whether the issuer is trusted: its chain passed the ISO/IEC 18013-5
  /// checks, or the trusted list vouches for it as in OIDC4VCI issuance (see
  /// `readerTrustedIssuer`).
  final bool isTrusted;

  /// The issuer's name, from its metadata.
  final String? name;

  /// The issuer's logo, from its metadata.
  final String? logoUri;

  /// The card of the document, from the credential configuration of its
  /// document type in the issuer's metadata, as an issued credential has it.
  final Display? credentialDisplay;

  /// That credential configuration, with the display names of the elements.
  final Map<String, dynamic>? credentialSupported;

  @override
  List<Object?> get props => [
    isTrusted,
    name,
    logoUri,
    credentialDisplay,
    credentialSupported,
  ];
}

/// Decides whether the issuer of one received document is trusted, then
/// looks up its name and logo in its OpenID4VCI metadata, as the
/// issuer-connect dialog shows them, and the card and element names of the
/// document, as issuance stores them.
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
      docType: document.docType,
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
    required String docType,
    required this.issuerUrls,
    required IssuerMetadataFetcher fetchIssuerMetadata,
    required String languageCode,
  }) : _docType = docType,
       _fetchIssuerMetadata = fetchIssuerMetadata,
       _languageCode = languageCode,
       super(ReaderIssuerState(isTrusted: isTrusted));

  /// Where the issuer's metadata is looked for, in order.
  final List<String> issuerUrls;

  final String _docType;
  final IssuerMetadataFetcher _fetchIssuerMetadata;
  final String _languageCode;
  final _log = getLogger('ReaderIssuerCubit');

  /// Looks up the issuer's display at the first of [issuerUrls] that serves
  /// metadata: its name and logo, and, when it has a credential configuration
  /// for the document type, the card and element names (see `fetchDisplay`).
  /// Without metadata, the state keeps no display.
  Future<void> resolveDisplay() async {
    for (final url in issuerUrls) {
      try {
        final metadata = await _fetchIssuerMetadata(url);
        final display = resolveIssuerDisplay(
          issuerOpenIdConfiguration: metadata,
          locale: _languageCode,
          fallbackHost: Uri.parse(url).host,
        );
        final configurationId = readerCredentialConfigurationId(
          metadata,
          _docType,
        );
        final (credentialDisplay, credentialSupported) = configurationId == null
            ? (null, null)
            : fetchDisplay(
                openIdConfiguration: metadata,
                credentialType: configurationId,
                languageCode: _languageCode,
              );
        if (isClosed) return;
        emit(
          ReaderIssuerState(
            isTrusted: state.isTrusted,
            name: display.name,
            logoUri: display.logoUri,
            credentialDisplay: credentialDisplay,
            credentialSupported: credentialSupported is Map<String, dynamic>
                ? credentialSupported
                : null,
          ),
        );
        return;
      } on Object catch (e) {
        _log.i('no issuer metadata at $url: $e');
      }
    }
  }
}
