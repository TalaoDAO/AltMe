part of 'did_cubit.dart';

@JsonSerializable()
class DIDState extends Equatable {
  const DIDState({
    this.did = '',
    this.didMethod = '',
    this.didMethodName = '',
    this.verificationMethod = '',
    this.status = AppStatus.init,
    this.message,
  });

  factory DIDState.fromJson(Map<String, dynamic> json) =>
      _$DIDStateFromJson(json);

  final String? did;
  final String? didMethod;
  final String? didMethodName;
  final String verificationMethod;
  final AppStatus? status;
  final StateMessage? message;

  Map<String, dynamic> toJson() => _$DIDStateToJson(this);

  DIDState loading() {
    return DIDState(
      status: AppStatus.loading,
      did: did,
      didMethod: didMethod,
      didMethodName: didMethodName,
      verificationMethod: verificationMethod,
    );
  }

  DIDState success({
    String? did,
    String? didMethod,
    String? didMethodName,
    String? verificationMethod,
  }) {
    return DIDState(
      did: did ?? this.did,
      didMethod: didMethod ?? this.didMethod,
      didMethodName: didMethodName ?? this.didMethodName,
      verificationMethod: verificationMethod ?? this.verificationMethod,
      status: AppStatus.success,
    );
  }

  @override
  List<Object?> get props =>
      [did, didMethod, didMethodName, status, message, verificationMethod];
}
