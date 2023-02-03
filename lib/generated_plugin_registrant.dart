//
// Generated file. Do not edit.
//

// ignore_for_file: directives_ordering
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: depend_on_referenced_packages

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_saver/file_saver_web.dart';
import 'package:flutter_native_timezone/flutter_native_timezone_web.dart';
import 'package:flutter_secure_storage_web/flutter_secure_storage_web.dart';
import 'package:mobile_scanner/mobile_scanner_web_plugin.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:share_plus_web/share_plus_web.dart';
import 'package:uni_links_web/uni_links_web.dart';
import 'package:url_launcher_web/url_launcher_web.dart';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

// ignore: public_member_api_docs
void registerPlugins(Registrar registrar) {
  FilePickerWeb.registerWith(registrar);
  FileSaverWeb.registerWith(registrar);
  FlutterNativeTimezonePlugin.registerWith(registrar);
  FlutterSecureStorageWeb.registerWith(registrar);
  MobileScannerWebPlugin.registerWith(registrar);
  PackageInfoPlugin.registerWith(registrar);
  SharePlusPlugin.registerWith(registrar);
  UniLinksPlugin.registerWith(registrar);
  UrlLauncherPlugin.registerWith(registrar);
  registrar.registerMessageHandler();
}
