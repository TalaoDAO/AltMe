import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:beacon_flutter/beacon_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'connected_dapps_cubit.g.dart';
part 'connected_dapps_state.dart';

class ConnectedDappsCubit extends Cubit<ConnectedDappsState> {
  ConnectedDappsCubit({
    required this.beacon,
    required this.networkCubit,
    required this.client,
    required this.connectedDappRepository,
  }) : super(ConnectedDappsState());

  final Beacon beacon;
  final ManageNetworkCubit networkCubit;
  final DioClient client;
  final ConnectedDappRepository connectedDappRepository;

  final log = getLogger('ConnectedDappsCubit');

  Future<void> init(String walletAddress) async {
    await getXtzData(walletAddress);
    await getPeers(walletAddress);
  }

  Future<void> getXtzData(String walletAddress) async {
    if (isClosed) return;
    try {
      log.i('fetching xtzData');
      emit(state.loading());

      final baseUrl = networkCubit.state.network.apiUrl;

      log.i('fetching balance');
      final int balance = await client
          .get('$baseUrl/v1/accounts/$walletAddress/balance') as int;

      final formattedBalance = balance / 1e6;

      log.i('fetching xtz USD price');
      final response = await client.get(Urls.xtzPrice) as Map<String, dynamic>;
      final XtzData xtzData = XtzData.fromJson(response);

      final xtzUSDPrice = xtzData.price!;

      final token = TokenModel(
        contractAddress: '',
        name: 'Tezos',
        symbol: 'XTZ',
        icon: 'https://s2.coinmarketcap.com/static/img/coins/64x64/2011.png',
        balance: balance.toString(),
        decimals: '6',
        standard: 'fa1.2',
        tokenUSDPrice: xtzUSDPrice,
        balanceInUSD: formattedBalance * xtzUSDPrice,
      );

      emit(
        state.copyWith(status: AppStatus.idle, xtzModel: token),
      );
    } catch (e) {
      log.e('xtzData fetching failure , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }

  Future<void> getPeers(String walletAddress) async {
    if (isClosed) return;
    try {
      emit(state.loading());

      log.i('fetching saved peers');
      final List<SavedDappData> savedDapps =
          await connectedDappRepository.findAll();

      log.i('savedPeerDatas - $savedDapps');

      final _peersListToShow = <SavedDappData>[];

      /// loop in saved permitted peer data
      for (final savedData in savedDapps) {
        /// display data for selected walletAddress only
        if (walletAddress == savedData.walletAddress) {
          _peersListToShow.add(savedData);
        }
      }

      emit(
        state.copyWith(status: AppStatus.idle, savedDapps: _peersListToShow),
      );
    } catch (e) {
      log.e('getPeers failure , e: $e');
      if (e is MessageHandler) {
        emit(state.error(messageHandler: e));
      } else {
        emit(
          state.error(
            messageHandler: ResponseMessage(
              ResponseString
                  .RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
            ),
          ),
        );
      }
    }
  }
}
