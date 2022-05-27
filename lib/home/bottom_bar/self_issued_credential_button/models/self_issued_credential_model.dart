class SelfIssuedCredentialDataModel {
  SelfIssuedCredentialDataModel({
    this.givenName,
    this.familyName,
    this.telephone,
    this.email,
    this.address,
    this.companyName,
    this.companyWebsite,
    this.jobTitle,
  });

  final String? givenName;
  final String? familyName;
  final String? telephone;
  final String? email;
  final String? address;
  final String? companyName;
  final String? companyWebsite;
  final String? jobTitle;

  @override
  String toString() {
    return '''
    SelfIssuedCredentialDataModel {
                  givenName : $givenName,
                  familyName : $familyName,
                  telephone : $telephone,
                  email : $email,
                  address : $address,
                  companyName : $companyName,
                  companyWebsite : $companyWebsite,
                  jobTitle : $jobTitle,
    }
    ''';
  }
}
