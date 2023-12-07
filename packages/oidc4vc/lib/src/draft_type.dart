enum DraftType { draft8, draft11, draft12 }

extension DraftTypeX on DraftType {
  String get formattedString {
    switch (this) {
      case DraftType.draft8:
        return 'Draft 8';
      case DraftType.draft11:
        return 'Draft 11';
      case DraftType.draft12:
        return 'Draft 12';
    }
  }
}
