part of 'scan_cubit.dart';

@JsonSerializable()
class ScanState extends Equatable {
  const ScanState({
    this.status = ScanStatus.init,
    this.message,
    this.preview,
    this.uri,
    this.keyId,
    this.challenge,
    this.domain,
    this.done,
  });

  factory ScanState.fromJson(Map<String, dynamic> json) =>
      _$ScanStateFromJson(json);

  final ScanStatus status;
  final StateMessage? message;
  final Map<String, dynamic>? preview;
  final Uri? uri;
  final String? keyId;
  final String? challenge;
  final String? domain;
  @JsonKey(ignore: true)
  final void Function(String)? done;

  ScanState loading() {
    return ScanState(
      status: ScanStatus.loading,
      preview: preview,
      uri: uri,
      keyId: keyId,
      challenge: challenge,
      domain: domain,
      done: done,
    );
  }

  ScanState scanPreview({required Map<String, dynamic> preview}) {
    return ScanState(status: ScanStatus.preview, preview: preview);
  }

  ScanState scanPermission({
    required Uri uri,
    required String keyId,
    String? challenge,
    String? domain,
    required void Function(String) done,
  }) {
    return ScanState(
      status: ScanStatus.askPermissionDidAuth,
      uri: uri,
      keyId: keyId,
      challenge: challenge,
      domain: domain,
      done: done,
    );
  }

  ScanState warning({required MessageHandler messageHandler}) {
    return ScanState(
      status: ScanStatus.warning,
      message: StateMessage.warning(messageHandler: messageHandler),
    );
  }

  ScanState error({required MessageHandler messageHandler}) {
    return ScanState(
      status: ScanStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  ScanState success({MessageHandler? messageHandler}) {
    return ScanState(
      status: ScanStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$ScanStateToJson(this);

  @override
  List<Object?> get props =>
      [status, message, preview, uri, keyId, challenge, domain, done];
}
