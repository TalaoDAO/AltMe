import 'dart:ui';

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

  Color get color {
    switch (this) {
      case MnemonicStatus.unselected:
        return const Color(0xff86809D);
      case MnemonicStatus.wrongSelection:
        return const Color(0xffFF0045);
      case MnemonicStatus.selected:
        return const Color(0xff6600FF);
    }
  }
}
