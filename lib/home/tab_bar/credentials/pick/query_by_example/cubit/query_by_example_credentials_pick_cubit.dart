import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'query_by_example_credentials_pick_state.dart';

part 'query_by_example_credentials_pick_cubit.g.dart';

class QueryByExampleCredentialPickCubit
    extends Cubit<QueryByExampleCredentialPickState> {
  QueryByExampleCredentialPickCubit()
      : super(QueryByExampleCredentialPickState());

  void toggle(int index) {
    final List<int> selection;
    if (state.selection.contains(index)) {
      selection = List<int>.of(state.selection)
        ..removeWhere((int element) => element == index);
    } else {
      selection = List.of(state.selection)..add(index);
    }
    emit(state.copyWith(selection: selection));
  }
}
