import 'package:flutter/material.dart';

enum MnemonicStatus {
  unselected,
  selected,
}

extension MnemonicStatusX on MnemonicStatus {
  Color color(BuildContext context) {
    switch (this) {
      case MnemonicStatus.unselected:
        return Theme.of(context).colorScheme.secondaryContainer;

      case MnemonicStatus.selected:
        return Theme.of(context).colorScheme.primary;
    }
  }
}
