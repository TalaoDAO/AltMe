import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/app/shared/issuer/models/organization_info.dart';

class CheckIssuer {
  CheckIssuer(
    this.client,
    this.checkIssuerServerUrl,
    this.uriToCheck,
  );

  final DioClient client;
  final String checkIssuerServerUrl;
  final Uri uriToCheck;

  Future<Issuer> isIssuerInApprovedList() async {
    var didToTest = '';
    didToTest = getIssuerDid(uriToCheck: uriToCheck);
    if (checkIssuerServerUrl == Urls.checkIssuerEbsiUrl &&
        !didToTest.startsWith('did:ebsi')) {
      return Issuer.emptyIssuer(uriToCheck.host);
    }
    try {
      final dynamic response =
          await client.get('$checkIssuerServerUrl/$didToTest');
      if (checkIssuerServerUrl == Urls.checkIssuerEbsiUrl) {
        return Issuer(
          preferredName: '',
          did: [],
          organizationInfo: OrganizationInfo(
            legalName: 'sdf',
            currentAddress: '',
            id: '',
            issuerDomain: [],
            website: uriToCheck.host,
          ),
        );
      }

      final issuer =
          Issuer.fromJson(response['issuer'] as Map<String, dynamic>);

      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }

      return Issuer.emptyIssuer(uriToCheck.host);
    } catch (e) {
      if (e is NetworkException) {
        if (e.message == NetworkError.NETWORK_ERROR_NOT_FOUND) {
          return Issuer.emptyIssuer(uriToCheck.toString());
        }
      }
      rethrow;
    }
  }
}
