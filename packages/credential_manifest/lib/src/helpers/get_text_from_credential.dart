import 'package:json_path/json_path.dart';

/// get fields values from credential based on jsonPath instructions
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
    });
    return textList;
  } catch (e) {
    return textList;
  }
}
