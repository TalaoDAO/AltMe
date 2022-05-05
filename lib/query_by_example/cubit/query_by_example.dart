import 'package:altme/query_by_example/model/query.dart';
import 'package:bloc/bloc.dart';

class QueryByExampleCubit extends Cubit<Query> {
  QueryByExampleCubit() : super(Query(type: '', credentialQuery: []));

  void setQueryByExampleCubit(Map<String, dynamic> queryByExample) {
    final _query = Query.fromJson(queryByExample);
    emit(_query);
  }

  void resetQueryByExampleCubit() {
    emit(Query(type: '', credentialQuery: []));
  }
}
