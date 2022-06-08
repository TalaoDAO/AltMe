import 'package:json_path/json_path.dart';

List<String> getTextsFromCredential(
  String jsonPath,
  Map<String, dynamic> data,
) {
  final textList = <String>[];
  try {
    final fieldsPath = JsonPath(jsonPath);
    fieldsPath.read(data).forEach((a) {
      if (a.value is String) {
        textList.add(a.value as String);
      }
      if (a.value is List) {
        for (final value in a.value) {
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
