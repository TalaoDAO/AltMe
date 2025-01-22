import 'package:altme/activity_log/log_class.dart';
import 'package:altme/activity_log/log_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogData Tests', () {
    test('LogData serialization and deserialization', () {
      final logData = LogData(
        type: LogType.addVC,
        timestamp: DateTime.parse('2024-01-22T10:00:00.000Z'),
      );

      final json = logData.toJson();
      final newLogData = LogData.fromJson(json);

      expect(newLogData, equals(logData));
    });

    test('LogData default timestamp', () {
      final logData = LogData(type: LogType.backupData);
      expect(logData.timestamp, isA<DateTime>());
    });
  });

  group('VCInfo Tests', () {
    test('VCInfo serialization and deserialization', () {
      const vcInfo = VCInfo(id: '456', name: 'Sample VC', domain: 'test.com');

      final json = vcInfo.toJson();
      final newVCInfo = VCInfo.fromJson(json);

      expect(newVCInfo, equals(vcInfo));
    });

    test('VCInfo equality', () {
      const vcInfo1 = VCInfo(id: '789', name: 'Equality Test');
      const vcInfo2 = VCInfo(id: '789', name: 'Equality Test');
      const vcInfo3 = VCInfo(id: '111', name: 'Different VC');

      expect(vcInfo1, equals(vcInfo2));
      expect(vcInfo1, isNot(equals(vcInfo3)));
    });
  });
}
