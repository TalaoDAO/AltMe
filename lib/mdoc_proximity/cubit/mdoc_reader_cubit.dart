import 'dart:async';

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
    _subscription = _reader.states.listen(emit);
  }

  final MdocReader _reader;
  final BluetoothPermissionRequest _requestBluetoothPermissions;
  late final StreamSubscription<ReaderState> _subscription;

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

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _reader.dispose();
    return super.close();
  }
}
