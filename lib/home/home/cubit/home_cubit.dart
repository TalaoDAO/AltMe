import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';

class HomeCubit extends Cubit<HomeStatus> {
  HomeCubit({required this.client}) : super(HomeStatus.hasNoWallet);

  final DioClient client;

  void emitHasWallet() {
    emit(HomeStatus.hasWallet);
  }

  void emitHasNoWallet() {
    emit(HomeStatus.hasNoWallet);
  }

  Future<PassBaseStatus> getPassBaseStatus(String did) async {
    try {
      client.changeHeaders(
        <String, dynamic>{
          'Accept': 'application/json',
          'Authorization': 'Bearer mytoken',
        },
      );

      final dynamic response = await client.get('/passbase/check/$did');

      client.changeHeaders(
        <String, dynamic>{'Content-Type': 'application/json; charset=UTF-8'},
      );

      switch (response) {
        case 'approved':
          return PassBaseStatus.approved;
        case 'declined':
          return PassBaseStatus.declined;
        case 'pending':
          return PassBaseStatus.pending;
        case 'undone':
          return PassBaseStatus.undone;
        case 'notdone':
          return PassBaseStatus.undone;
        default:
          return PassBaseStatus.undone;
      }
    } catch (e) {
      return PassBaseStatus.undone;
    }
  }
}
