import 'package:altme/app/app.dart';

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
    try {
      final dynamic response =
          await client.get('$checkIssuerServerUrl/$didToTest');
      final issuer = Issuer.fromJson(response as Map<String, dynamic>);
      if (issuer.organizationInfo.issuerDomain.contains(uriToCheck.host)) {
        return issuer;
      }
      return Issuer.emptyIssuer();
    } catch (e) {
      rethrow;
    }
  }
}
