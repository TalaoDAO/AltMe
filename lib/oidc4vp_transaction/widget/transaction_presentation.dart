import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/oidc4vp_transaction/helper/decode_erc20_transfert.dart';
import 'package:altme/oidc4vp_transaction/helper/get_decoded_transaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:secure_storage/secure_storage.dart';

class TransactionPresentation extends StatelessWidget {
  const TransactionPresentation({super.key});

  @override
  Widget build(BuildContext context) {
    final List<dynamic> decodedTransactions = getDecodedTransactions(context);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: decodedTransactions.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final tx = decodedTransactions[index] as Map<String, dynamic>;
        final uiHints = tx['ui_hints'] ?? <String, dynamic>{};
        final purpose = uiHints['purpose'] as String? ?? '';
        final image = uiHints['icon_uri'] as String? ?? '';
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.network(
                image,
                height: 80,
                width: 80,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox.shrink();
                },
              ),
            ),
            Center(
              child: Text(
                purpose,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TokenInfoWidget(transaction: tx),
            ),
          ],
        );
      },
    );
  }
}

class TokenInfoWidget extends StatelessWidget {
  const TokenInfoWidget({super.key, required this.transaction});
  final Map<String, dynamic> transaction;

  Future<Map<String, dynamic>> fetchTokenMetadata() async {
    final chainId = transaction['chain_id'] as int? ?? 1;
    final contractAddress =
        transaction['rpc']['params'][0]['to'] as String? ?? '';
    if (chainId == 11155111) {
      if (contractAddress == '0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238') {
        // Sepolia USDC contract address
        return {'symbol': 'USDC', 'decimals': 6};
      }
      if (contractAddress == '0x08210F9170F89Ab7658F0B5E3fF39b0E03C594D4') {
        // Sepolia EURC contract address
        return {'symbol': 'EURC', 'decimals': 6};
      }
      throw Exception('Sepolia network is not supported for those coins.');
    }
    try {
      await dotenv.load();
      final apiKey = dotenv.get('MORALIS_API_KEY');
      final secureStorageProvider = getSecureStorage;

      final DioClient client = DioClient(
        secureStorageProvider: secureStorageProvider,
        dio: Dio(),
      );

      final chainHex = '0x${chainId.toRadixString(16)}';
      final url =
          '${Urls.moralisBaseUrl}/erc20/metadata?chain=$chainHex&addresses%5B0%5D=$contractAddress';

      final response = await client.get(
        url,
        headers: {'X-API-KEY': apiKey, 'accept': 'application/json'},
      );

      if (response is List) {
        if (response.isNotEmpty) {
          final token = response.first;
          return {'symbol': token['symbol'], 'decimals': token['decimals']};
        } else {
          throw Exception('Token not found');
        }
      } else {
        throw Exception('Failed to load token metadata: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error fetching token metadata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchTokenMetadata(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data found');
        }

        final token = snapshot.data!;
        final params = transaction['rpc']['params'] as List<dynamic>;
        final param = params[0];
        final data = param['data']?.toString() ?? '';
        final amount = decodeErc20Transfer(txData: data);

        final humanAmount =
            amount /
            BigInt.from(10).pow(int.parse(token['decimals'].toString()));

        /// display amount with decimal
        return Center(
          child: Text(
            '$humanAmount ${token["symbol"]}',
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(),
          ),
        );
      },
    );
  }
}
