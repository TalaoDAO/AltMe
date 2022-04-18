import 'package:altme/app/app.dart';
import 'package:altme/theme/theme.dart';

import 'package:flutter/material.dart';

extension MessageTypeExtension on MessageType {
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
