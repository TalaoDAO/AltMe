import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:secure_storage/secure_storage.dart';

class CredentialsRepository {
  CredentialsRepository(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  Future<void> initializeRevocationStatus() async {
    final _credentialList = await findAll();
    for (final _credential in _credentialList) {
      if (_credential.revocationStatus == RevocationStatus.active) {
        _credential.setRevocationStatusToUnknown();
        await update(_credential);
      }
    }
  }

  Future<List<CredentialModel>> findAll(/* dynamic filters */) async {
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere((key, value) => !key.startsWith('credential/'));

    final _credentialList = <CredentialModel>[];
    data.forEach((key, value) {
      _credentialList.add(
        CredentialModel.fromJson(json.decode(value) as Map<String, dynamic>),
      );
    });

    return _credentialList;
  }

  Future<CredentialModel?> findById(String id) async {
    final String? data = await _secureStorageProvider.get('credential/$id');
    if (data == null) {
      return null;
    }
    if (data.isEmpty) return null;

    return CredentialModel.fromJson(json.decode(data) as Map<String, dynamic>);
  }

  Future<int> deleteAll() async {
    final data = await _secureStorageProvider.getAllValues();
    data.removeWhere((key, value) => !key.startsWith('credential/'));
    var numberOfDeletedCredentials = 0;
    data.forEach((key, value) {
      _secureStorageProvider.delete(key);
      numberOfDeletedCredentials++;
    });
    return numberOfDeletedCredentials;
  }

  Future<bool> deleteById(String id) async {
    await _secureStorageProvider.delete('credential/$id');
    return true;
  }

  Future<int> insert(CredentialModel credential) async {
    await _secureStorageProvider.set(
      'credential/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }

  Future<int> update(CredentialModel credential) async {
    await _secureStorageProvider.set(
      'credential/${credential.id}',
      json.encode(credential.toJson()),
    );
    return 1;
  }
}
