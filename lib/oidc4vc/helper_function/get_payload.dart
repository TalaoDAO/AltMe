import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/helper_functions/helper_functions.dart';

dynamic getPayload(
  DioClient client,
  String? requestUri,
  String? request,
) async {
  late dynamic encodedData;

  if (request != null) {
    encodedData = request;
  } else if (requestUri != null) {
    encodedData = await fetchRequestUriPayload(url: requestUri, client: client);
  }
  return encodedData;
}
