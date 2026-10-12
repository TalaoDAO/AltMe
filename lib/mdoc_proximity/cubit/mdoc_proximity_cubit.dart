import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:permission_handler/permission_handler.dart';

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

/// Drives one ISO/IEC 18013-5 proximity presentation of an mdoc.
class MdocProximityCubit extends Cubit<ProximityState> {
  /// Creates the cubit.
  MdocProximityCubit({
    required MdocProximity proximity,
    BluetoothPermissionRequest requestBluetoothPermissions =
        requestProximityBluetoothPermissions,
  }) : _proximity = proximity,
       _requestBluetoothPermissions = requestBluetoothPermissions,
       super(const ProximityPreparing()) {
    _subscription = _proximity.states.listen(emit);
  }

  final MdocProximity _proximity;
  final BluetoothPermissionRequest _requestBluetoothPermissions;
  late final StreamSubscription<ProximityState> _subscription;

  String? _issuerSigned;
  String? _keyAlias;

  /// The engagement of the current (or last) session.
  ProximityEngagement engagement = ProximityEngagement.qrCode;

  /// Whether NFC engagement can be offered.
  Future<ProximityNfcAvailability> nfcAvailability() =>
      _proximity.nfcAvailability();

  /// Starts presenting the mdoc [issuerSigned] bound to [keyAlias].
  Future<void> start({
    required String issuerSigned,
    required String keyAlias,
    ProximityEngagement engagement = ProximityEngagement.qrCode,
  }) async {
    _issuerSigned = issuerSigned;
    _keyAlias = keyAlias;
    this.engagement = engagement;
    emit(const ProximityPreparing());

    if (!await _requestBluetoothPermissions()) {
      emit(const ProximityBluetoothRequired(authorization: true));
      return;
    }

    try {
      await _proximity.start(
        issuerSigned: issuerSigned,
        keyAlias: keyAlias,
        engagement: engagement,
      );
    } on MdocProximityException catch (e) {
      emit(ProximityFailure(ProximityFailureReason.error, e.message));
    } on PlatformException catch (e) {
      emit(ProximityFailure(ProximityFailureReason.error, e.message));
    }
  }

  /// Starts again, e.g. after a failure or to switch engagement.
  Future<void> restart({ProximityEngagement? engagement}) async {
    final issuerSigned = _issuerSigned;
    final keyAlias = _keyAlias;
    if (issuerSigned == null || keyAlias == null) return;
    await _proximity.cancel();
    await start(
      issuerSigned: issuerSigned,
      keyAlias: keyAlias,
      engagement: engagement ?? this.engagement,
    );
  }

  /// Shares the selected elements: docType → name space → elements.
  Future<void> approve(Map<String, Map<String, List<String>>> elements) async {
    emit(const ProximitySending());
    await _proximity.approve(elements);
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    await _proximity.dispose();
    return super.close();
  }
}
