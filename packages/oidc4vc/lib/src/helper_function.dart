String listToString(List<dynamic> inputList) {
  final resultList = <dynamic>[];

  for (var i = 0; i < inputList.length; i++) {
    resultList.add(inputList[i]);

    if (i < inputList.length - 1) {
      resultList.add(' ');
    }
  }

  return resultList.join();
}
