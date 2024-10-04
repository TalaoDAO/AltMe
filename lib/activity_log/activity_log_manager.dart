import 'dart:convert';

import 'package:altme/activity_log/activity_log.dart';
import 'package:secure_storage/secure_storage.dart';

class ActivityLogManager {
  ActivityLogManager(SecureStorageProvider secureStorageProvider)
      : _secureStorageProvider = secureStorageProvider;

  final SecureStorageProvider _secureStorageProvider;

  static const int maxLogsPerBatch = 100;

  /// Get logs from single batch
  Future<List<LogData>> _getLogsForCurrentBatch(int index) async {
    final logDataJson = await _secureStorageProvider.get('log_batch_$index');

    if (logDataJson != null) {
      final logStrings = logDataJson.split('\n');
      return logStrings
          .map(
            (logString) => LogData.fromJson(
              jsonDecode(logString) as Map<String, dynamic>,
            ),
          )
          .toList();
    }
    return [];
  }

  /// Set log entry
  Future<void> saveLog(LogData log) async {
    final currentBatchIndex = await _getCurrentBatchIndex();

    List<LogData> logs = await _getLogsForCurrentBatch(currentBatchIndex);

    // If the batch is full, increment the batch index and start a new batch
    if (logs.length >= maxLogsPerBatch) {
      await _incrementBatchIndex();
      logs = [];
    }

    logs.add(log);

    final logJsonList = logs.map((log) => jsonEncode(log.toJson())).toList();

    await _secureStorageProvider.set(
      'log_batch_$currentBatchIndex',
      logJsonList.join('\n'),
    );
  }

  /// Get logs from all batches
  Future<List<LogData>> readAllLogs() async {
    final currentBatchIndex = await _getCurrentBatchIndex();
    final allLogs = <LogData>[];

    for (int i = currentBatchIndex; i == 0; i--) {
      final logData = await _getLogsForCurrentBatch(i);
      allLogs.addAll(logData.reversed.toList());
    }
    return allLogs;
  }

  // /// Get paginated logs
  // Future<List<LogData>> readLogs(int limit, int offset) async {
  //   final allLogs = <LogData>[];

  //   final currentBatchIndex = await _getCurrentBatchIndex();
  //   // Retrieve logs from all batches
  //   for (int i = 0; i <= currentBatchIndex; i++) {
  //     final logData = await _secureStorageProvider.get('log_batch_$i');
  //     if (logData != null) {
  //       final logStrings = logData.split('\n');
  //       final logs = logStrings
  //           .map(
  //             (logString) => LogData.fromJson(
  //               jsonDecode(logString) as Map<String, dynamic>,
  //             ),
  //           )
  //           .toList();
  //       allLogs.addAll(logs);
  //     }
  //   }

  //   // Apply pagination logic (limit and offset)
  //   // but this logic needs to be improved.. it is paginating later..
  //   // we need to consider while fetching
  //   return allLogs.skip(offset).take(limit).toList();
  // }

  /// Clear all logs
  Future<void> clearLogs() async {
    final currentBatchIndex = await _getCurrentBatchIndex();
    for (int i = 0; i <= currentBatchIndex; i++) {
      await _secureStorageProvider.delete('log_batch_$i');
    }
    await _secureStorageProvider.delete('currentBatchIndex');
  }

  /// get Current Batch
  Future<int> _getCurrentBatchIndex() async {
    final index = await _secureStorageProvider.get('currentBatchIndex');
    if (index != null) {
      return int.parse(index);
    }

    return 0;
  }

  Future<void> _incrementBatchIndex() async {
    final currentBatchIndex = await _getCurrentBatchIndex();
    final newBatchIndex = currentBatchIndex + 1;
    await _secureStorageProvider.set(
      'currentBatchIndex',
      newBatchIndex.toString(),
    );
  }
}
