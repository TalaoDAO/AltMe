/// How far a wallet has got through whatever its wallet provider requires
/// before the wallet may be used.
enum WalletOnboardingStatus {
  /// Onboarding has not begun.
  notStarted,

  /// Onboarding is under way.
  inProgress,

  /// Everything the wallet provider requires has succeeded.
  ready,

  /// Onboarding failed and the wallet cannot be used until it is retried.
  failed,
}

/// What must succeed before the wallet is usable.
///
/// A wallet whose provider asks nothing of it is ready the moment it is
/// installed. A wallet whose provider requires the device to be registered
/// before it will issue anything is not, and the difference has to be visible
/// to whatever decides when to let the user in.
///
/// Deliberately minimal — a status and one method — because the steps
/// themselves differ completely between providers and nothing outside an
/// implementation should depend on what they are.
abstract class WalletOnboardingGate {
  /// How far onboarding has got.
  WalletOnboardingStatus get status;

  /// Completes once the wallet is usable, doing whatever that takes.
  ///
  /// Idempotent: a wallet that is already [WalletOnboardingStatus.ready]
  /// returns immediately rather than repeating the work. Throws when onboarding
  /// cannot be completed, leaving [status] at [WalletOnboardingStatus.failed].
  Future<void> ensureReady();
}

/// A gate for a wallet provider that requires nothing before use.
///
/// The wallet is usable as soon as it is installed: there is no registration to
/// complete and no token to obtain, so [ensureReady] has nothing to do and
/// [status] is always [WalletOnboardingStatus.ready].
class LegacyWalletOnboardingGate implements WalletOnboardingGate {
  /// Creates a gate that is always open.
  const LegacyWalletOnboardingGate();

  @override
  WalletOnboardingStatus get status => WalletOnboardingStatus.ready;

  @override
  Future<void> ensureReady() async {}
}
