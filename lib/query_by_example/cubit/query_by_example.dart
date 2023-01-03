import 'package:altme/query_by_example/model/query.dart';
import 'package:bloc/bloc.dart';

class QueryByExampleCubit extends Cubit<Query> {
  QueryByExampleCubit() : super(Query(type: '', credentialQuery: []));

  void setQueryByExampleCubit(Query query) {
    emit(query);
  }

  void resetQueryByExampleCubit() {
    emit(Query(type: '', credentialQuery: []));
  }
}
