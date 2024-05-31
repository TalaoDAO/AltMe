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
  final connectivityResult = await Connectivity().checkConnectivity();
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  log.e('No Internet Connection');
  return false;
}
