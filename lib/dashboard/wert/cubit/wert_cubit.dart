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
        '''https://sandbox.wert.io/01GMWDYDRESASBVVV7SB6FHYZE/redirect?theme=dark&lang=en''';

    final symbol = walletCubit.state.currentAccount.blockchainType.symbol;
    final address = walletCubit.state.currentAccount.walletAddress;

    link = '$link&commodity=$symbol';
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
