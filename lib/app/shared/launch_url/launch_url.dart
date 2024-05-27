import 'package:altme/app/app.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static Future<void> launch(
    String url, {
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url), mode: launchMode)
        : throw ResponseMessage(
            data: {
              'error': 'invalid_format',
              'error_description': 'Could not launch $url',
            },
          );
  }

  static Future<void> launchUri(
    Uri uri, {
    LaunchMode launchMode = LaunchMode.externalApplication,
  }) async {
    await canLaunchUrl(uri)
        ? await launchUrl(uri, mode: launchMode)
        : throw ResponseMessage(
            data: {
              'error': 'invalid_format',
              'error_description': 'Could not launch $uri',
            },
          );
  }
}
