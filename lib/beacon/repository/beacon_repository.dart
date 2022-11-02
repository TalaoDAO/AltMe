import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/beacon/beacon.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:secure_storage/secure_storage.dart';

class BeaconRepository {
  BeaconRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  final log = getLogger('BeaconRepository');

  Future<List<SavedPeerData>> findAll(/* dynamic filters */) async {
    log.i('fetching all ');
    try {
      final data = await _secureStorageProvider.getAllValues();
      data.removeWhere(
        (key, value) => !key.startsWith(
          '${SecureStorageKeys.beaconPeerKey}/',
        ),
      );
      final _savedPeerData = <SavedPeerData>[];
      data.forEach((key, value) {
        _savedPeerData.add(
          SavedPeerData.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      });
      return _savedPeerData;
    } catch (e) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<BeaconRequest?> findByPublicKey(String publicKey) async {
    log.i('findByPublicKey');
    final String? data = await _secureStorageProvider
        .get('${SecureStorageKeys.beaconPeerKey}/$publicKey');
    if (data == null) {
      return null;
    }
    if (data.isEmpty) return null;

    return BeaconRequest.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<int> deleteAll() async {
    log.i('deleting all beaconData');
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere(
      (key, value) => !key.startsWith('${SecureStorageKeys.beaconPeerKey}/'),
    );
    var numberOfDeletedCredentials = 0;
    data.forEach((key, value) {
      _secureStorageProvider.delete(key);
      numberOfDeletedCredentials++;
    });
    return numberOfDeletedCredentials;
  }

  Future<bool> deleteByPublicKey(String publicKey) async {
    log.i('deleteing beaconData');
    await _secureStorageProvider
        .delete('${SecureStorageKeys.beaconPeerKey}/$publicKey');
    return true;
  }

  Future<int> insert(SavedPeerData peerData) async {
    final List<SavedPeerData> savedPeerDatas = await findAll();

    final SavedPeerData? matchedData = savedPeerDatas.firstWhereOrNull(
      (SavedPeerData peer) =>
          peer.walletAddress == peerData.walletAddress &&
          peer.peer.name == peerData.peer.name,

      /// Note: Assumption - name is always unique
    );

    if (matchedData != null) {
      await deleteByPublicKey(matchedData.peer.publicKey);
    }

    log.i('saving beaconData');
    await _secureStorageProvider.set(
      '${SecureStorageKeys.beaconPeerKey}/${peerData.peer.publicKey}',
      json.encode(peerData.toJson()),
    );
    return 1;
  }

  Future<int> update(SavedPeerData savedPeerData) async {
    log.i('updating beaconData');
    await _secureStorageProvider.set(
      '${SecureStorageKeys.beaconPeerKey}/${savedPeerData.peer.publicKey}',
      json.encode(savedPeerData.toJson()),
    );
    return 1;
  }
}
