import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';

class WertCubit extends Cubit<String> {
  WertCubit({
    required this.credentialsRepository,
    required this.walletCubit,
  }) : super('') {
    getUrl();
  }

  final CredentialsRepository credentialsRepository;
  final WalletCubit walletCubit;

  Future<void> getUrl() async {
    final log = getLogger('WertCubit - getUrl');
    String link =
        '''https://widget.wert.io/01GPB3PAQ0KF3SCDMHRAN6AZ2B/widget/?theme=dark&lang=en''';

    final address = walletCubit.state.currentAccount!.walletAddress;

    final blockchainType = walletCubit.state.currentAccount!.blockchainType;

    if (blockchainType.supportWert) {
      final (commodity, network, commodityId) = blockchainType.commodityData;
      link = '$link'
          '&commodity=$commodity'
          '&network=$network'
          '&commodity_id=$commodityId';
    }

    link = '$link&address=$address';

    final List<CredentialModel> allCredentials =
        await credentialsRepository.findAll();

    for (final storedCredential in allCredentials) {
      final iteratedCredentialSubjectModel =
          storedCredential.credentialPreview.credentialSubjectModel;

      if (iteratedCredentialSubjectModel.credentialSubjectType ==
          CredentialSubjectType.emailPass) {
        final email = (iteratedCredentialSubjectModel as EmailPassModel).email;
        link = '$link&email=$email';
      }

      if (iteratedCredentialSubjectModel.credentialSubjectType ==
          CredentialSubjectType.phonePass) {
        final phone = (iteratedCredentialSubjectModel as PhonePassModel).phone;
        link = '$link&phone=$phone';
      }
    }

    log.i('link: $link');

    emit(link);
  }
}
