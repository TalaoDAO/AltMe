//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links_linux/app_links_plugin_linux.h>
#include <bluetooth_low_energy_linux/bluetooth_low_energy_linux_plugin.h>
#include <devicelocale/devicelocale_plugin.h>
#include <file_saver/file_saver_plugin.h>
#include <file_selector_linux/file_selector_plugin.h>
#include <flutter_secure_storage_linux/flutter_secure_storage_linux_plugin.h>
#include <open_file_linux/open_file_linux_plugin.h>
#include <url_launcher_linux/url_launcher_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) app_links_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AppLinksPluginLinux");
  app_links_plugin_linux_register_with_registrar(app_links_linux_registrar);
  g_autoptr(FlPluginRegistrar) bluetooth_low_energy_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "BluetoothLowEnergyLinuxPlugin");
  bluetooth_low_energy_linux_plugin_register_with_registrar(bluetooth_low_energy_linux_registrar);
  g_autoptr(FlPluginRegistrar) devicelocale_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DevicelocalePlugin");
  devicelocale_plugin_register_with_registrar(devicelocale_registrar);
  g_autoptr(FlPluginRegistrar) file_saver_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSaverPlugin");
  file_saver_plugin_register_with_registrar(file_saver_registrar);
  g_autoptr(FlPluginRegistrar) file_selector_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FileSelectorPlugin");
  file_selector_plugin_register_with_registrar(file_selector_linux_registrar);
  g_autoptr(FlPluginRegistrar) flutter_secure_storage_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "FlutterSecureStorageLinuxPlugin");
  flutter_secure_storage_linux_plugin_register_with_registrar(flutter_secure_storage_linux_registrar);
  g_autoptr(FlPluginRegistrar) open_file_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "OpenFileLinuxPlugin");
  open_file_linux_plugin_register_with_registrar(open_file_linux_registrar);
  g_autoptr(FlPluginRegistrar) url_launcher_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "UrlLauncherPlugin");
  url_launcher_plugin_register_with_registrar(url_launcher_linux_registrar);
}
