/// Paths of the wallet_ui icons (Figma "Iconos" frame) bundled with the app.
///
/// The `…Inactive` icons are the Figma "-200" variants, used for the bottom
/// bar destinations that are not selected.
abstract class WalletIconStrings {
  static const String _base = 'assets/icon/wallet_ui';

  static const String wallet = '$_base/wallet.svg';
  static const String walletInactive = '$_base/wallet-200.svg';
  static const String explore = '$_base/explore.svg';
  static const String exploreInactive = '$_base/explore-200.svg';
  static const String sensors = '$_base/sensors.svg';
  static const String sensorsInactive = '$_base/sensors-200.svg';
  static const String search = '$_base/search.svg';
  static const String creditCard = '$_base/credit_card.svg';
  static const String creditCardInactive = '$_base/credit_card-200.svg';
  static const String eyeTracking = '$_base/eye_tracking.svg';
  static const String dehaze = '$_base/dehaze.svg';
}
