import 'package:credential_manifest/credential_manifest.dart';

List<Field> getEbsiV3CompatibleFilterList(List<Field> filterList) {
  final List<Field> newList = [];
  for (int i = 0; i < filterList.length; i++) {
    final List<String> newPath = [];
    for (final element in filterList[i].path) {
      newPath.add(element.replaceAll('.vc', ''));
    }
    newList[i] = filterList[i].copyWith(path: newPath);
  }
  return newList;
}
