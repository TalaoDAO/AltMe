import 'package:altme/app/app.dart';
import 'package:altme/app/shared/issuer/models/organization_info.dart';

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
    uriToCheck.queryParameters.forEach((key, value) {
      if (key == 'issuer') {
        didToTest = value;
      }
    });
    if (checkIssuerServerUrl == Urls.checkIssuerEbsiUrl &&
        !didToTest.startsWith('did:ebsi')) {
      return Issuer.emptyIssuer();
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
            website: '',
          ),
        );
      }
      final issuer = Issuer.fromJson(response as Map<String, dynamic>);
      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }
      return Issuer.emptyIssuer();
    } catch (e) {
      if (e is NetworkException) {
        if (checkIssuerServerUrl == Urls.checkIssuerEbsiUrl &&
            e.message == NetworkError.NETWORK_ERROR_NOT_FOUND) {
          return Issuer.emptyIssuer();
        }
      }
      rethrow;
    }
  }
}
