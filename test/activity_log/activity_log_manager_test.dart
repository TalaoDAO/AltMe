import 'dart:convert';

import 'package:altme/activity_log/activity_log.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

void main() {
  late ActivityLogManager activityLogManager;
  late MockSecureStorageProvider mockStorage;

  setUp(() {
    mockStorage = MockSecureStorageProvider();
    activityLogManager = ActivityLogManager(mockStorage);
  });

  test('save a log correctly', () async {
    final logData = LogData(type: LogType.addVC);
    when(() => mockStorage.get(any())).thenAnswer((_) async => null);
    when(() => mockStorage.set(any(), any())).thenAnswer((_) async {});

    await activityLogManager.saveLog(logData);

    verify(() => mockStorage.set('log_batch_0', any())).called(1);
  });

  test('readAllLogs should retrieve logs from all batches', () async {
    final logDataJson =
        jsonEncode(LogData(type: LogType.restoreWallet).toJson());

    when(() => mockStorage.get(any())).thenAnswer((_) async => logDataJson);
    when(() => mockStorage.get('currentBatchIndex'))
        .thenAnswer((_) async => '0');

    final logs = await activityLogManager.readAllLogs();

    expect(logs.length, 1);
    expect(logs.first.type, LogType.restoreWallet);
  });

  test('clearLogs should remove all stored logs', () async {
    when(() => mockStorage.get('currentBatchIndex'))
        .thenAnswer((_) async => '2');
    when(() => mockStorage.delete(any())).thenAnswer((_) async {});

    await activityLogManager.clearLogs();

    verify(() => mockStorage.delete('log_batch_0')).called(1);
    verify(() => mockStorage.delete('log_batch_1')).called(1);
    verify(() => mockStorage.delete('log_batch_2')).called(1);
    verify(() => mockStorage.delete('currentBatchIndex')).called(1);
  });
}
