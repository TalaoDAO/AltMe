import 'dart:async';
import 'dart:io';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

/// Asks for the runtime permissions a BLE proximity session needs.
typedef BluetoothPermissionRequest = Future<bool> Function();

/// Android 12+ runtime Bluetooth permissions. On iOS, CoreBluetooth prompts
/// by itself when the session starts, and a refusal comes back as
/// [ProximityBluetoothRequired].
Future<bool> requestProximityBluetoothPermissions() async {
  if (!Platform.isAndroid) return true;
  final statuses = await [
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
    Permission.bluetoothAdvertise,
  ].request();
  return statuses.values.every((status) => status.isGranted);
}

/// A proximity session and, while the reader's request waits for an answer,
/// the wallet's credentials that can answer each requested document.
class MdocProximityState extends Equatable {
  /// Creates the state.
  const MdocProximityState(this.session, {this.candidates = const {}});

  /// Where the session is.
  final ProximityState session;

  /// For a [ProximityRequest]: docType → the credentials that can answer it,
  /// empty when the wallet holds none.
  final Map<String, List<CredentialModel>> candidates;

  @override
  List<Object?> get props => [session, candidates];
}

/// Drives one ISO/IEC 18013-5 proximity presentation of the wallet's mdocs.
///
/// The session starts with no document: the reader's request says which
/// document types it wants, and the cubit then finds, among the wallet's
/// credentials, those that can answer each of them.
class MdocProximityCubit extends Cubit<MdocProximityState> {
  /// Creates the cubit. [credentials] is read when a request arrives, so the
  /// session follows the wallet's credentials without restarting.
  MdocProximityCubit({
    required MdocProximity proximity,
    required List<CredentialModel> Function() credentials,
    PlatformP256Keys platformKeys = const PlatformP256Keys(),
    BluetoothPermissionRequest requestBluetoothPermissions =
        requestProximityBluetoothPermissions,
  }) : _proximity = proximity,
       _credentials = credentials,
       _platformKeys = platformKeys,
       _requestBluetoothPermissions = requestBluetoothPermissions,
       super(const MdocProximityState(ProximityPreparing())) {
    _subscription = _proximity.states.listen(_onSessionState);
  }

  final MdocProximity _proximity;
  final List<CredentialModel> Function() _credentials;
  final PlatformP256Keys _platformKeys;
  final BluetoothPermissionRequest _requestBluetoothPermissions;
  late final StreamSubscription<ProximityState> _subscription;

  /// Whether the user declined: the reader's termination that follows is not
  /// a success.
  bool _declined = false;

  /// Starts a session.
  Future<void> start() async {
    _declined = false;
    emit(const MdocProximityState(ProximityPreparing()));

    if (!await _requestBluetoothPermissions()) {
      emit(
        const MdocProximityState(
          ProximityBluetoothRequired(authorization: true),
        ),
      );
      return;
    }

    try {
      await _proximity.start();
    } on MdocProximityException catch (e) {
      _fail(e.message);
    } on PlatformException catch (e) {
      _fail(e.message);
    }
  }

  /// Starts again, e.g. after a failure.
  Future<void> restart() async {
    await _proximity.cancel();
    await start();
  }

  /// Answers the request with [disclosures], one per document.
  Future<void> approve(List<ProximityDisclosure> disclosures) async {
    try {
      await _proximity.approve(disclosures);
    } on MdocProximityException catch (e) {
      _fail(e.message);
    }
  }

  /// Answers the request with no document and ends the session.
  Future<void> decline() async {
    _declined = true;
    try {
      await _proximity.decline();
    } on MdocProximityException catch (e) {
      _declined = false;
      _fail(e.message);
    }
  }

  void _fail(String? message) => emit(
    MdocProximityState(ProximityFailure(ProximityFailureReason.error, message)),
  );

  Future<void> _onSessionState(ProximityState session) async {
    switch (session) {
      case ProximityRequest(:final documents):
        final candidates = await _candidates(documents);
        if (!isClosed) {
          emit(MdocProximityState(session, candidates: candidates));
        }
      case ProximitySuccess() when _declined:
        // The view leaves the page once the decline is sent.
        return;
      default:
        emit(MdocProximityState(session));
    }
  }

  /// For each requested docType, the credentials that can answer it: the
  /// mdocs of that type, bound to a platform key that still exists.
  Future<Map<String, List<CredentialModel>>> _candidates(
    List<ProximityDocumentRequest> documents,
  ) async {
    final hasKey = <String, bool>{};
    Future<bool> keyExists(String alias) async =>
        hasKey[alias] ??= await _platformKeys.find(alias) != null;

    final candidates = <String, List<CredentialModel>>{};
    for (final document in documents) {
      if (candidates.containsKey(document.docType)) continue;
      candidates[document.docType] = [
        for (final credential in _credentials())
          if (credential.canPresentInProximity &&
              credential.mdocDocType == document.docType &&
              await keyExists(credential.keyId!))
            credential,
      ];
    }
    return candidates;
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _proximity.dispose();
    return super.close();
  }
}
