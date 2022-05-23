import 'package:altme/nft/models/index.dart';

enum NftStateEnum { loading, loaded, error }

class NftState {
  const NftState({
    this.state = NftStateEnum.loading,
    this.data = const [],
    this.error = '',
  });

  factory NftState.loading() => const NftState(state: NftStateEnum.loading);

  factory NftState.loaded(List<NftModel> data) =>
      NftState(state: NftStateEnum.loaded, data: data, error: '');

  factory NftState.error(String message) =>
      NftState(state: NftStateEnum.error, error: message);

  final NftStateEnum state;
  final List<NftModel> data;
  final String error;
}
