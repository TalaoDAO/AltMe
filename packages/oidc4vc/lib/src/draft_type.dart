enum DraftType { draft8, draft10, draft11 }

extension DraftTypeX on DraftType {
  String get formattedString {
    switch (this) {
      case DraftType.draft8:
        return 'Draft 8';
      case DraftType.draft10:
        return 'Draft 10';
      case DraftType.draft11:
        return 'Draft 11';
    }
  }
}
