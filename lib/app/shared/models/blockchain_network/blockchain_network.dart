import 'package:equatable/equatable.dart';

abstract class BlockchainNetwork extends Equatable {
  const BlockchainNetwork({
    required this.networkname,
    required this.apiUrl,
    required this.rpcNodeUrl,
    required this.title,
    required this.subTitle,
    this.apiKey = '',
  });

  final String networkname;
  final String apiUrl;
  final String apiKey;
  final String rpcNodeUrl;
  final String? title;
  final String? subTitle;

  @override
  List<Object?> get props => [
        networkname,
        apiUrl,
        apiKey,
        rpcNodeUrl,
        title,
        subTitle,
      ];

  @override
  String toString() {
    return 'BlockchainNetwork{networkName: $networkname,apiUrl: $apiUrl, '
        'rpcNodeUrl: $rpcNodeUrl, apiKey: $apiKey ,title:$title '
        ',subTitle:$subTitle}';
  }
}
