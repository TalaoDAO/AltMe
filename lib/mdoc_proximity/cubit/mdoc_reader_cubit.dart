import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_proximity_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// Drives one ISO/IEC 18013-5 reading of an mdoc from a holder's QR code.
class MdocReaderCubit extends Cubit<ReaderState> {
  /// Creates the cubit.
  MdocReaderCubit({
    required MdocReader reader,
    required this.qrUri,
    this.query = mdlReaderQuery,
    this.trustedRoots = const [],
    BluetoothPermissionRequest requestBluetoothPermissions =
        requestProximityBluetoothPermissions,
  }) : _reader = reader,
       _requestBluetoothPermissions = requestBluetoothPermissions,
       super(const ReaderConnecting()) {
    _subscription = _reader.states.listen(_onReaderState);
  }

  final MdocReader _reader;
  final BluetoothPermissionRequest _requestBluetoothPermissions;
  late final StreamSubscription<ReaderState> _subscription;
  final _log = getLogger('MdocReaderCubit');

  /// The holder's `mdoc:` device engagement.
  final String qrUri;

  /// What is asked for.
  final ReaderQuery query;

  /// PEM IACA certificates the issuers must chain to.
  final List<String> trustedRoots;

  /// Starts reading; also what "try again" calls.
  Future<void> start() async {
    await _reader.cancel();
    emit(const ReaderConnecting());

    if (!await _requestBluetoothPermissions()) {
      emit(const ReaderBluetoothRequired(authorization: true));
      return;
    }

    try {
      await _reader.start(
        qrUri: qrUri,
        query: query,
        trustedRoots: trustedRoots,
      );
    } on PlatformException catch (e) {
      emit(ReaderFailure(e.message));
    }
  }

  void _onReaderState(ReaderState state) {
    switch (state) {
      case ReaderSuccess(:final result):
        _log.i(
          'reader: success, verified: ${result.documents.map(_describe)}, '
          'failed: ${result.failedDocTypes}, '
          'documentErrors: ${result.documentErrors}, '
          'responseErrors: ${result.responseErrors}, '
          'unrequested: ${result.unrequestedDocTypes}',
        );
      case ReaderFailure(:final message):
        _log.e('reader: failure: $message');
      default:
        _log.i('reader: $state');
    }
    emit(state);
  }

  /// The document type, its element identifiers and whether its issuer is
  /// trusted, for the log.
  static String _describe(ReaderDocument document) {
    final elements = [
      for (final nameSpace in document.nameSpaces.values) ...nameSpace.keys,
    ];
    return '${document.docType} $elements, issuer trusted: '
        '${document.isIssuerTrusted} ${document.issuerTrustErrors}';
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _reader.dispose();
    return super.close();
  }
}
