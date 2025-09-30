import 'package:altme/app/logger/get_logger.dart';
import 'package:altme/app/shared/helper_functions/test_platform.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<bool> isConnectedToInternet() async {
  final log = getLogger('Check Internet Connection');

  if (!isAndroid) {
    if (!(await DeviceInfoPlugin().iosInfo).isPhysicalDevice) {
      return true;
    }
  }

  final List<ConnectivityResult> connectivityResult = await Connectivity()
      .checkConnectivity();

  if (connectivityResult.contains(ConnectivityResult.mobile)) {
    // Mobile network available.
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    // Wi-fi is available.

    // Note for Android:

    // When both mobile and Wi-Fi are turned on system will return
    // Wi-Fi only as active network type
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
    // Ethernet connection available.
    return true;
  } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
    // Vpn connection active.
    // Note for iOS and macOS:
    // There is no separate network interface type for [vpn].
    // It returns [other] on any device (also simulator)
    return true;
  }

  log.e('No Internet Connection');
  return false;
}
