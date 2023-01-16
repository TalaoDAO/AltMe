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
        '''https://widget.wert.io/01GPB3PAQ0KF3SCDMHRAN6AZ2B/redirect?theme=dark&lang=en''';

    final address = walletCubit.state.currentAccount!.walletAddress;

    switch (walletCubit.state.currentAccount!.blockchainType) {
      case BlockchainType.tezos:
        link = '$link&commodities=XTZ&commodity=XTZ';
        break;
      case BlockchainType.ethereum:
        link = '$link&commodities=ETH&commodity=ETH';
        break;
      case BlockchainType.polygon:
        link = '$link&commodities=MATIC&commodity=MATIC';
        break;
      case BlockchainType.fantom:
      case BlockchainType.binance:
        break;
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
