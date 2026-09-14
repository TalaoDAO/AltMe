import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'kyc_verification_state.dart';
part 'kyc_verification_cubit.g.dart';

class KycVerificationCubit extends Cubit<KycVerificationState> {
  KycVerificationCubit({required this.client, required this.profileCubit})
    : super(const KycVerificationState());

  final DioClient client;
  final ProfileCubit profileCubit;

  final logger = getLogger('KycVerificationCubit');

  Future<void> getVcByKycVerification({
    required KycVcType vcType,
    required String link,
    dynamic Function()? onKycApproved,
  }) async {
    await startKycVerifcation(vcType: vcType, link: link);
  }

  Future<void> startKycVerifcation({
    String? link,
    KycVcType vcType = KycVcType.verifiableId,
  }) async {
    emit(state.copyWith(status: KycVerificationStatus.loading));
    const walletId = AltMeStrings.clientIdForID360;
    late String url;

    if (link == null) {
      url =
          '${Urls.authenticateForId360}?vc_type=${vcType.value}'
          '&client_id=$walletId&callback=${Parameters.redirectUri}';
    } else {
      url = link;
    }
    await LaunchUrl.launchUri(Uri.parse(url));
    emit(state.copyWith(status: KycVerificationStatus.unkown));
  }
}
