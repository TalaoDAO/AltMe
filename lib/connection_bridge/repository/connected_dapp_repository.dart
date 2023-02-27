import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:secure_storage/secure_storage.dart';

class ConnectedDappRepository {
  ConnectedDappRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  final log = getLogger('ConnectedDappRepository');

  Future<List<SavedDappData>> findAll(/* dynamic filters */) async {
    log.i('fetching all ');
    try {
      final data = await _secureStorageProvider.getAllValues();
      data.removeWhere(
        (key, value) => !key.startsWith(
          '${SecureStorageKeys.savedDaaps}/',
        ),
      );
      final savedPeerData = <SavedDappData>[];
      data.forEach((key, value) {
        savedPeerData.add(
          SavedDappData.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      });
      return savedPeerData;
    } catch (e) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<BeaconRequest?> findBeaconDappsByPublicKey(String publicKey) async {
    log.i('findByPublicKey');
    final String? data = await _secureStorageProvider
        .get('${SecureStorageKeys.savedDaaps}/$publicKey');
    if (data == null) {
      return null;
    }
    if (data.isEmpty) return null;

    return BeaconRequest.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<int> deleteAll() async {
    log.i('deleting all connected dapps');
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere(
      (key, value) => !key.startsWith('${SecureStorageKeys.savedDaaps}/'),
    );
    var numberOfDeletedCredentials = 0;
    data.forEach((key, value) {
      _secureStorageProvider.delete(key);
      numberOfDeletedCredentials++;
    });
    return numberOfDeletedCredentials;
  }

  Future<bool> delete(SavedDappData savedDappData) async {
    late String id;
    switch (savedDappData.blockchainType) {
      case BlockchainType.ethereum:
        id = savedDappData.wcSessionStore!.session.topic;
        break;
      case BlockchainType.tezos:
        id = savedDappData.peer!.publicKey;
        break;
      case BlockchainType.fantom:
        id = savedDappData.wcSessionStore!.session.topic;
        break;
      case BlockchainType.polygon:
        id = savedDappData.wcSessionStore!.session.topic;
        break;
      case BlockchainType.binance:
        id = savedDappData.wcSessionStore!.session.topic;
        break;
    }
    log.i('deleteing dapp data - ${SecureStorageKeys.savedDaaps}/$id');
    await _secureStorageProvider.delete('${SecureStorageKeys.savedDaaps}/$id');
    return true;
  }

  Future<int> insert(SavedDappData savedDappData) async {
    final List<SavedDappData> savedPeerDatas = await findAll();

    final SavedDappData? matchedData = savedPeerDatas.firstWhereOrNull(
      (SavedDappData savedData) {
        switch (savedDappData.blockchainType) {
          case BlockchainType.ethereum:
          case BlockchainType.fantom:
          case BlockchainType.polygon:
          case BlockchainType.binance:
            return savedData.walletAddress == savedDappData.walletAddress &&
                savedData.wcSessionStore!.remotePeerMeta.name ==
                    savedDappData.wcSessionStore!.remotePeerMeta.name;
          case BlockchainType.tezos:
            return savedData.walletAddress == savedDappData.walletAddress &&
                savedData.peer!.name == savedDappData.peer!.name;
        }
      },

      /// Note: Assumption - name is always unique
    );

    if (matchedData != null) {
      await delete(matchedData);
    }

    log.i('saving dapp Data');
    late String id;
    switch (savedDappData.blockchainType) {
      case BlockchainType.ethereum:
      case BlockchainType.fantom:
      case BlockchainType.polygon:
      case BlockchainType.binance:
        id = savedDappData.wcSessionStore!.session.topic;
        break;
      case BlockchainType.tezos:
        id = savedDappData.peer!.publicKey;
        break;
    }

    await _secureStorageProvider.set(
      '${SecureStorageKeys.savedDaaps}/$id',
      json.encode(savedDappData.toJson()),
    );
    return 1;
  }

  // Future<int> update(SavedDappData savedPeerData) async {
  //   log.i('updating data');
  //   await _secureStorageProvider.set(
  //     '${SecureStorageKeys.savedDaaps}/${savedPeerData.peer!.publicKey}',
  //     json.encode(savedPeerData.toJson()),
  //   );
  //   return 1;
  // }
}
