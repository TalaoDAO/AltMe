import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// wert session creation is explained at
/// https://docs.wert.io/docs/fiat-onramp
class WertCubit extends Cubit<String> {
  WertCubit({
    required this.credentialsRepository,
    required this.walletCubit,
    required this.dioClient,
  }) : super('') {
    getUrl();
  }

  final CredentialsRepository credentialsRepository;
  final WalletCubit walletCubit;
  final DioClient dioClient;

  Future<void> getUrl() async {
    final log = getLogger('WertCubit - getUrl');

    // Get Wert ID from environment variables
    final wertId = dotenv.env['WERT_ID'];
    final wertPartnerId = dotenv.env['WERT_PARTNER_ID'];
    if (wertId == null || wertPartnerId == null) {
      throw Exception('WERT_ID or WERT_PARTNER_ID is not set in .env file');
    }

    // Base URL for Wert widget with dynamic values
    final linkWidget =
        'https://widget.wert.io/$wertPartnerId/widget/?theme=dark&lang=en';
    const linkInitialization =
        'https://partner.wert.io/api/external/hpp/create-session';

    final address = walletCubit.state.currentAccount!.walletAddress;

    final blockchainType = walletCubit.state.currentAccount!.blockchainType;

    if (blockchainType.supportWert) {
      final (commodity, network, commodityId) = blockchainType.commodityData;
      final data = <String, dynamic>{
        'flow_type': 'simple',
        'commodity': commodity,
        'network': network,
        'wallet_address': address,
      };
      final response = await dioClient.post(
        linkInitialization,
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'X-Api-Key': wertId,
        },
        data: data,
      );
      if (response['sessionId'] == null) {
        log.e('Failed to get Wert URL: ${response.statusMessage}');
        throw Exception('Failed to get Wert URL');
      } else {
        log.i('Wert URL fetched successfully');
        final link = '$linkWidget&session_id=${response['sessionId']}';
        emit(link);
      }
    } else {
      log.e(
        'Wert is not supporting this blockchain type',
      );
      throw Exception(
        'Wert is not supporting this blockchain type',
      );
    }
  }
}
