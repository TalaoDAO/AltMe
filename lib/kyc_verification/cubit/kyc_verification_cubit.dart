import 'package:altme/app/app.dart';
import 'package:altme/did/cubit/did_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_verification_state.dart';
part 'kyc_verification_cubit.g.dart';

class KycVerificationCubit extends Cubit<KycVerificationState> {
  KycVerificationCubit({
    required this.client,
    required this.didCubit,
  }) : super(const KycVerificationState());

  final DioClient client;
  final DIDCubit didCubit;
  final logger = getLogger('KycVerificationCubit');

  Future<String?> _getApiCode() async {
    try {
      await dotenv.load();
      final walletApiKey = dotenv.get('WALLET_API_KEY_ID360');
      final walletId = dotenv.get('CLIENT_ID_ID360');
      final response = await client.get(
        Urls.getCodeForId360,
        queryParameters: {
          'client_id': walletId,
          'did': didCubit.state.did ?? '',
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

  Future<void> getVcByKycVerification({
    required KycVcType vcType,
    required String link,
    dynamic Function()? onKycApproved,
  }) async {
    await startKycVerifcation(vcType: vcType);
  }

  Future<void> startKycVerifcation({
    KycVcType vcType = KycVcType.verifiableId,
  }) async {
    emit(state.copyWith(status: KycVerificationStatus.loading));
    final code = await _getApiCode();
    if (code == null) {
      emit(state.copyWith(status: KycVerificationStatus.unverified));
      return;
    }
    //emit(state.copyWith(status: KycVerificationStatus.pending));
    await dotenv.load();
    final walletId = dotenv.get('CLIENT_ID_ID360');
    final url = '${Urls.authenticateForId360}/$code?vc_type=${vcType.value}'
        '&client_id=$walletId&callback=${Urls.appDeepLink}';
    await LaunchUrl.launchUri(
      Uri.parse(
        url,
      ),
    );
    emit(state.copyWith(status: KycVerificationStatus.unkown));
  }
}
