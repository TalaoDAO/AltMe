part of 'protocol_trace_logs_cubit.dart';

@JsonSerializable()
class ProtocolTraceLogsState extends Equatable {
  const ProtocolTraceLogsState({
    this.status = AppStatus.init,
    this.filePaths = const [],
  });

  factory ProtocolTraceLogsState.fromJson(Map<String, dynamic> json) =>
      _$ProtocolTraceLogsStateFromJson(json);

  final AppStatus status;

  /// Absolute paths of the recorded trace files, newest first.
  final List<String> filePaths;

  ProtocolTraceLogsState copyWith({
    AppStatus? status,
    List<String>? filePaths,
  }) {
    final state = ProtocolTraceLogsState(
      status: status ?? this.status,
      filePaths: filePaths ?? this.filePaths,
    );
    return state;
  }

  Map<String, dynamic> toJson() => _$ProtocolTraceLogsStateToJson(this);

  @override
  List<Object?> get props => [status, filePaths];
}
