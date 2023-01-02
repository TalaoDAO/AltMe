import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'blockchain_network.g.dart';

@JsonSerializable()
class BlockchainNetwork extends Equatable {
  const BlockchainNetwork({
    required this.networkname,
    required this.apiUrl,
    required this.rpcNodeUrl,
    required this.title,
    required this.subTitle,
    required this.type,
    this.apiKey = '',
  });

  factory BlockchainNetwork.fromJson(Map<String, dynamic> json) =>
      _$BlockchainNetworkFromJson(json);

  Map<String, dynamic> toJson() => _$BlockchainNetworkToJson(this);

  final String networkname;
  final String apiUrl;
  final String apiKey;
  final String rpcNodeUrl;
  final String? title;
  final String? subTitle;
  final BlockchainType type;

  @override
  List<Object?> get props => [
        networkname,
        apiUrl,
        apiKey,
        rpcNodeUrl,
        title,
        subTitle,
        type,
      ];

  @override
  String toString() {
    return 'BlockchainNetwork{networkName: $networkname,apiUrl: $apiUrl, '
        'rpcNodeUrl: $rpcNodeUrl, apiKey: $apiKey ,title:$title '
        ',subTitle:$subTitle, type: $type}';
  }
}
