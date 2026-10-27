/// The wallet solution a profile belongs to.
///
/// `istec` is the solution name the Wallet Provider Protocol's reference
/// provider puts in `generalOptions.walletType` of its `/v1/configuration`
/// payload, and the same value it signs into a Wallet Instance Attestation as
/// `wallet_name` (§8).
enum WalletAppType { altme, talao, talao4eu, istec }
