import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:polygonid/polygonid.dart';

import 'package:secure_storage/secure_storage.dart';

class PolygonIdCubit extends Cubit<bool> {
  PolygonIdCubit({
    required this.polygonId,
    required this.secureStorageProvider,
  }) : super(false);

  final SecureStorageProvider secureStorageProvider;
  final PolygonId polygonId;

  Future<void> initialise() async {
    try {
      if (PolygonId().isInitialized) {
        emit(true);
        return;
      }

      /// PolygonId SDK initialization
      await dotenv.load();

      await PolygonId().init(
        web3Url: dotenv.get('INFURA_URL'),
        web3RdpUrl: dotenv.get('INFURA_RDP_URL'),
        web3ApiKey: dotenv.get('INFURA_MUMBAI_API_KEY'),
        idStateContract: dotenv.get('ID_STATE_CONTRACT_ADDR'),
        pushUrl: dotenv.get('PUSH_URL'),
      );

      final mnemonic =
          await secureStorageProvider.get(SecureStorageKeys.ssiMnemonic);

      //addIdentity
      await polygonId.addIdentity(mnemonic: mnemonic!);
      emit(true);
    } catch (e) {
      emit(false);
      throw Exception('INIT_ISSUE');
    }
  }
}
