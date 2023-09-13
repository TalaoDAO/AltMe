import 'package:flutter_bloc/flutter_bloc.dart';

class Oidc4vcCredentialPickCubit extends Cubit<List<int>> {
  Oidc4vcCredentialPickCubit() : super(<int>[]);

  void updateList(int index) {
    final newList = List<int>.from(state);
    if (newList.contains(index)) {
      newList.remove(index);
    } else {
      newList.add(index);
    }
    emit(newList);
  }
}
