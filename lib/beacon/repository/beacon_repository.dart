import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:secure_storage/secure_storage.dart';

class BeaconRepository {
  BeaconRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  final log = getLogger('BeaconRepository');

  Future<List<BeaconRequest>> findAll(/* dynamic filters */) async {
    log.i('fetching all data');
    try {
      final data = await _secureStorageProvider.getAllValues();
      data.removeWhere(
        (key, value) => !key.startsWith(
          '${SecureStorageKeys.beaconPeerKey}/',
        ),
      );
      final _credentialList = <BeaconRequest>[];
      data.forEach((key, value) {
        _credentialList.add(
          BeaconRequest.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      });
      return _credentialList;
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

  Future<int> insert(BeaconRequest beaconRequest) async {
    log.i('saving beaconData');
    await _secureStorageProvider.set(
      '${SecureStorageKeys.beaconPeerKey}/${beaconRequest.peer!.publicKey}',
      json.encode(beaconRequest.toJson()),
    );
    return 1;
  }

  Future<int> update(BeaconRequest beaconRequest) async {
    log.i('updating beaconData');
    await _secureStorageProvider.set(
      '${SecureStorageKeys.beaconPeerKey}/${beaconRequest.peer!.publicKey}',
      json.encode(beaconRequest.toJson()),
    );
    return 1;
  }
}
