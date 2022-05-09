import 'package:url_launcher/url_launcher.dart';

class LaunchUrl {
  static Future<void> launch(String url) async {
    await canLaunchUrl(Uri.parse(url))
        ? await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)
        : throw Exception('Could not launch $url');
  }
}
