part of 'message_type.dart';

extension MessageTypeX on MessageType {
  Color getColor(BuildContext context) {
    switch (this) {
      case MessageType.error:
        return Theme.of(context).colorScheme.alertErrorMessage;
      case MessageType.warning:
        return Theme.of(context).colorScheme.alertWarningMessage;
      case MessageType.info:
        return Theme.of(context).colorScheme.alertInfoMessage;
      case MessageType.success:
        return Theme.of(context).colorScheme.alertSuccessMessage;
    }
  }
}
