import 'package:altme/activity_log/log_enum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LogType Enum Tests', () {
    test('LogType values count', () {
      expect(LogType.values.length, 7);
    });

    test('LogType string representations', () {
      expect(LogType.walletInit.toString(), 'LogType.walletInit');
      expect(LogType.backupData.toString(), 'LogType.backupData');
      expect(LogType.restoreWallet.toString(), 'LogType.restoreWallet');
      expect(LogType.addVC.toString(), 'LogType.addVC');
      expect(LogType.deleteVC.toString(), 'LogType.deleteVC');
      expect(LogType.presentVC.toString(), 'LogType.presentVC');
      expect(LogType.importKey.toString(), 'LogType.importKey');
    });
  });
}
