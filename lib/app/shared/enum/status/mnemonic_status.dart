
import 'package:flutter/material.dart';

enum MnemonicStatus {
  unselected,
  selected,
  wrongSelection,
}

extension MnemonicStatusX on MnemonicStatus {
  bool get showOrder {
    switch (this) {
      case MnemonicStatus.unselected:
      case MnemonicStatus.wrongSelection:
        return false;
      case MnemonicStatus.selected:
        return true;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case MnemonicStatus.unselected:
        return Theme.of(context).colorScheme.secondaryContainer;
      case MnemonicStatus.wrongSelection:
        return Theme.of(context).colorScheme.error;
      case MnemonicStatus.selected:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
