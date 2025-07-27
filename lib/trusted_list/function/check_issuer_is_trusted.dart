import 'package:altme/trusted_list/model/trusted_entity.dart';
import 'package:altme/trusted_list/model/trusted_list.dart';
import 'package:oidc4vc/oidc4vc.dart';

TrustedEntity? getIssuerFromTrustedList({
  required OpenIdConfiguration issuerOpenIdConfiguration,
  required TrustedList trustedList,
}) {
  // Check if issuer is in the trusted list
  final issuerFromOpenIdConfiguration =
      issuerOpenIdConfiguration.credentialIssuer;
  return getEntityFromTrustedList(
    trustedList,
    issuerFromOpenIdConfiguration,
    TrustedEntityType.issuer,
  );
}

TrustedEntity? getEntityFromTrustedList(
  TrustedList trustedList,
  String? issuerFromOpenIdConfiguration,
  TrustedEntityType type,
) {
  final entities = List<TrustedEntity>.from(trustedList.entities);
  entities.removeWhere(
    (entity) =>
        entity.id != issuerFromOpenIdConfiguration || entity.type != type,
  );
  if (entities.isNotEmpty) {
    return entities.first;
  }
  return null;
}
