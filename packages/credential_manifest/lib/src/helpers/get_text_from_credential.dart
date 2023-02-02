import 'package:json_path/json_path.dart';

List<String> getTextsFromCredential(
  String jsonPath,
  Map<String, dynamic> data,
) {
  final textList = <String>[];
  try {
    final fieldsPath = JsonPath(jsonPath);
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
