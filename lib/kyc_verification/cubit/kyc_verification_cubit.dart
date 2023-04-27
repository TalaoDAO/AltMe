import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_verification_state.dart';
part 'kyc_verification_cubit.g.dart';

class KycVerificationCubit extends Cubit<KycVerificationState> {
  KycVerificationCubit({
    required this.client,
  }) : super(const KycVerificationState());

  final DioClient client;
  final logger = getLogger('KycVerificationCubit');
  final walletId = 111; // TODO(all): change the value
  final walletApiKey = '123456789'; // TODO(all): change the value
  final walletCallback = ''; // TODO(all): deeplink need to be defined

  Future<String?> _getApiCode() async {
    try {
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
  }
}
