//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links/app_links_plugin_c_api.h>
#include <connectivity_plus/connectivity_plus_windows_plugin.h>
#include <file_saver/file_saver_plugin.h>
#include <file_selector_windows/file_selector_windows.h>
#include <flutter_secure_storage_windows/flutter_secure_storage_windows_plugin.h>
#include <local_auth_windows/local_auth_plugin.h>
#include <permission_handler_windows/permission_handler_windows_plugin.h>
#include <secure_application/secure_application_plugin.h>
#include <share_plus/share_plus_windows_plugin_c_api.h>
#include <sodium_libs/sodium_libs_plugin_c_api.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  AppLinksPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("AppLinksPluginCApi"));
  ConnectivityPlusWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ConnectivityPlusWindowsPlugin"));
  FileSaverPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSaverPlugin"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  FlutterSecureStorageWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterSecureStorageWindowsPlugin"));
  LocalAuthPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("LocalAuthPlugin"));
  PermissionHandlerWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("PermissionHandlerWindowsPlugin"));
  SecureApplicationPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SecureApplicationPlugin"));
  SharePlusWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SharePlusWindowsPluginCApi"));
  SodiumLibsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SodiumLibsPluginCApi"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
