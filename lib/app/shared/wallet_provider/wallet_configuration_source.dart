/// Where a wallet's configuration comes from, and how it is applied.
///
/// The configuration is a `ProfileSetting`-shaped JSON document: it decides
/// which credentials the wallet offers, how it authenticates to issuers, which
/// menus it shows and which blockchains it talks to. The enterprise wallet
/// provider serves it over an authenticated HTTP call; another wallet provider
/// may serve it as a signed token. The caller applies whatever it is handed and
/// does not know which.
///
/// Fetching and applying are separate because a user sits between them: the
/// wallet shows what it received and waits for approval before replacing the
/// configuration in force.
abstract class WalletConfigurationSource {
  /// Fetches the configuration, as `ProfileSetting`-shaped JSON.
  Future<String> fetchConfigurationJson();

  /// Persists [json] and puts it into force.
  ///
  /// [json] is a document [fetchConfigurationJson] returned. An implementation
  /// that verifies its configuration must do so before anything is persisted:
  /// a configuration that has been applied is one the wallet is already acting
  /// on.
  Future<void> applyConfiguration(String json);
}
