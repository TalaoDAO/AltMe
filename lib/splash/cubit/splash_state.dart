part of 'splash_cubit.dart';

@JsonSerializable()
class SplashState extends Equatable {
  const SplashState({
    this.status = SplashStatus.init,
    this.versionNumber = '',
    this.buildNumber = '',
    this.storeInfo = const StoreInfo(),
  });

  factory SplashState.fromJson(Map<String, dynamic> json) =>
      _$SplashStateFromJson(json);

  final SplashStatus status;
  final String versionNumber;
  final String buildNumber;
  final StoreInfo storeInfo;

  SplashState copyWith({
    SplashStatus? status,
    String? versionNumber,
    String? buildNumber,
    StoreInfo? storeInfo,
  }) {
    return SplashState(
      status: status ?? this.status,
      versionNumber: versionNumber ?? this.versionNumber,
      buildNumber: buildNumber ?? this.buildNumber,
      storeInfo: storeInfo ?? this.storeInfo,
    );
  }

  Map<String, dynamic> toJson() => _$SplashStateToJson(this);

  @override
  List<Object?> get props => [status, versionNumber, buildNumber];
}

@JsonSerializable()
class StoreInfo extends Equatable {
  const StoreInfo({
    this.localVersion = '',
    this.storeVersion = '',
    this.appStoreLink = '',
    this.releaseNotes = '',
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) =>
      _$StoreInfoFromJson(json);

  final String localVersion;
  final String storeVersion;
  final String appStoreLink;
  final String releaseNotes;

  StoreInfo copyWith({
    String? localVersion,
    String? storeVersion,
    String? appStoreLink,
    String? releaseNotes,
  }) {
    return StoreInfo(
      localVersion: localVersion ?? this.localVersion,
      storeVersion: storeVersion ?? this.storeVersion,
      appStoreLink: appStoreLink ?? this.appStoreLink,
      releaseNotes: releaseNotes ?? this.releaseNotes,
    );
  }

  Map<String, dynamic> toJson() => _$StoreInfoToJson(this);

  @override
  List<Object?> get props =>
      [localVersion, storeVersion, appStoreLink, releaseNotes];
}
