import 'package:test/test.dart';
import 'package:altme/app/app.dart';

void main() {
  group('StateMessage', () {
    test('fromJson should create a StateMessage instance from JSON', () {
      final json = {
        'type': 'error',
        'stringMessage': 'Error message',
        'showDialog': true,
        'duration': 1600,
      };

      final stateMessage = StateMessage.fromJson(json);

      expect(stateMessage.type, MessageType.error);
      expect(stateMessage.stringMessage, 'Error message');
      expect(stateMessage.showDialog, isTrue);
      expect(stateMessage.duration, const Duration(microseconds: 1600));
    });

    test('toJson should convert a StateMessage instance to JSON', () {
      const stateMessage = StateMessage(
        type: MessageType.warning,
        stringMessage: 'Warning message',
        showDialog: false,
        duration: Duration(microseconds: 2000),
      );

      final json = stateMessage.toJson();

      expect(json['type'], 'warning');
      expect(json['stringMessage'], 'Warning message');
      expect(json['showDialog'], isFalse);
      expect(json['duration'], 2000);
    });

    test('equality should compare StateMessage instances correctly', () {
      const stateMessage1 = StateMessage(
        type: MessageType.info,
        stringMessage: 'Info message',
      );
      const stateMessage2 = StateMessage(
        type: MessageType.info,
        stringMessage: 'Info message',
      );
      const stateMessage3 = StateMessage(
        type: MessageType.warning,
        stringMessage: 'Warning message',
      );

      expect(stateMessage1, equals(stateMessage2));
      expect(stateMessage1, isNot(equals(stateMessage3)));
    });

    test('message types should have correct values', () {
      expect(const StateMessage.error().type, MessageType.error);
      expect(const StateMessage.warning().type, MessageType.warning);
      expect(const StateMessage.info().type, MessageType.info);
      expect(const StateMessage.success().type, MessageType.success);
    });
  });
}
