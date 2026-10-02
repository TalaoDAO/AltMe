import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';
import 'package:oidc4vc/oidc4vc.dart';

dynamic getPayload(
  DioClient client,
  OIDC4VCIClient oidc4vc,
  String? requestUri,
  String? request, {
  String? requestUriMethod,
}) async {
  late dynamic encodedData;

  if (request != null) {
    encodedData = request;
  } else if (requestUri != null) {
    encodedData = await fetchRequestUriPayload(
      url: requestUri,
      client: client,
      oidc4vc: oidc4vc,
      requestUriMethod: requestUriMethod,
    );
  }
  return encodedData;
}
