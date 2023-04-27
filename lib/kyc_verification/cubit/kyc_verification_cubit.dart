import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_verification_state.dart';
part 'kyc_verification_cubit.g.dart';

class KycVerificationCubit extends Cubit<KycVerificationState> {
  KycVerificationCubit({
    required this.client,
  }) : super(const KycVerificationState());

  final DioClient client;
  final logger = getLogger('KycVerificationCubit');
  final walletId = 111;
  final walletCallback = 'https://app.altme.io/app/download';

  Future<String?> _getApiCode() async {
    try {
      await dotenv.load();
      final walletApiKey = dotenv.get('WALLET_API_KEY_ID360');
      final response = await client.get(
        Urls.getCodeForId360,
        queryParameters: {
          'client_id': walletId,
        },
        headers: {
          'api-key': walletApiKey,
        },
      );
      return response?['code']?.toString();
    } catch (e, s) {
      logger.e('error: $e, stack: $s');
      return null;
    }
  }

  Future<void> startKycVerifcation({
    KycVcType vcType = KycVcType.verifiableId,
  }) async {
    final code = await _getApiCode();
    if (code == null) {
      emit(state.copyWith(status: KycVerificationStatus.unverified));
      return;
    }
    emit(state.copyWith(status: KycVerificationStatus.pending));
    await LaunchUrl.launchUri(
      Uri.parse(
        '${Urls.authenticateForId360}?code=$code&vc_type=${vcType.value}'
        '&client_id=$walletId&callback=$walletCallback',
      ),
    );
    // TODO(all): don't forget update verfication
    // status with deeplink callback
  }
}
