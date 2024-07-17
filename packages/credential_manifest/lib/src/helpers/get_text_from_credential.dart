import 'package:json_path/json_path.dart';

List<String> getTextsFromCredential(
  String jsonPath,
  Map<String, dynamic> data,
) {
  final textList = <String>[];
  try {
    /// finds all occurrences of a dot followed by one or more digits
    /// in the jsonPath string
    final numericStringFinderRegex = RegExp(r'\.(\d+)');

    var updatedJsonPath =
        jsonPath.replaceAllMapped(numericStringFinderRegex, (match) {
      final key = match.group(1);

      ///e.g. $.age_equal_or_over.18 becomes $.age_equal_or_over['18']
      return "['$key']";
    });

    /// matches the string .vc only if it is immediately followed by another dot
    /// matches: .vc. , ab.vc.
    /// doesnot match: .vca.asd
    final vcFinderRegex = RegExp(r'\.vc(?=\.)');
    updatedJsonPath = updatedJsonPath.replaceAll(vcFinderRegex, '');

    final fieldsPath = JsonPath(updatedJsonPath);

    fieldsPath.read(data).forEach((a) {
      final dynamic value = a.value;
      if (value is String) {
        textList.add(value);
      }
      if (value is bool) {
        textList.add(value.toString());
      }
      if (value is num) {
        textList.add(value.toString());
      }
      if (value is List) {
        for (final value in value) {
          if (value is String) {
            textList.add(value);
          }
        }
      }
    });
    return textList;
  } catch (e) {
    return textList;
  }
}
