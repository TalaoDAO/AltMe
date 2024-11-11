dynamic getDisplay(dynamic value, String languageCode) {
  if (value is! Map<String, dynamic>) return null;

  if (value.isEmpty) return null;

  if (value.containsKey('display')) {
    final displays = value['display'];
    if (displays is! List<dynamic>) return null;
    if (displays.isEmpty) return null;

    final display = displays.firstWhere(
      (element) =>
          element is Map<String, dynamic> &&
          element.containsKey('locale') &&
          element['locale'].toString().contains(languageCode),
      orElse: () => displays.firstWhere(
        (element) =>
            element is Map<String, dynamic> &&
            element.containsKey('locale') &&
            element['locale'].toString().contains('en'),
        orElse: () => displays.firstWhere(
          (element) =>
              element is Map<String, dynamic> && element.containsKey('locale'),
          orElse: () => displays.firstWhere(
            (element) =>
                element is Map<String, dynamic>, // if local is not provided
            orElse: () => null,
          ),
        ),
      ),
    );

    return display;
  } else {
    return null;
  }
}
