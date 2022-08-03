import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:secure_storage/secure_storage.dart';

class CredentialsRepository {
  CredentialsRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    try {
      final data = await _secureStorageProvider.getAllValues();
      data.removeWhere(
        (key, value) => !key.startsWith(
          '${SecureStorageKeys.credentialKey}/',
        ),
      );
      final _credentialList = <CredentialModel>[];
      data.forEach((key, value) {
        _credentialList.add(
          CredentialModel.fromJson(json.decode(value) as Map<String, dynamic>),
        );
      });
      return _credentialList;
    } catch (e) {
      throw ResponseMessage(
        ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
      );
    }
  }

  Future<CredentialModel?> findById(String id) async {
    final String? data = await _secureStorageProvider
        .get('${SecureStorageKeys.credentialKey}/$id');
    if (data == null) {
      return null;
    }
    if (data.isEmpty) return null;

    return CredentialModel.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<int> deleteAll() async {
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere(
      (key, value) => !key.startsWith('${SecureStorageKeys.credentialKey}/'),
    );
    var numberOfDeletedCredentials = 0;
    data.forEach((key, value) {
      _secureStorageProvider.delete(key);
      numberOfDeletedCredentials++;
    });
    return numberOfDeletedCredentials;
  }

  Future<bool> deleteById(String id) async {
    await _secureStorageProvider
        .delete('${SecureStorageKeys.credentialKey}/$id');
    return true;
  }

  Future<int> insert(CredentialModel credential) async {
    await _secureStorageProvider.set(
      '${SecureStorageKeys.credentialKey}/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }

  Future<int> update(CredentialModel credential) async {
    await _secureStorageProvider.set(
      '${SecureStorageKeys.credentialKey}/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }
}
