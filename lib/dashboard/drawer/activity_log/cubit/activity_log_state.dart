part of 'activity_log_cubit.dart';

@JsonSerializable()
class ActivityLogState extends Equatable {
  ActivityLogState({this.status = AppStatus.init, List<LogData>? logDatas})
    : logDatas = logDatas ?? [];

  factory ActivityLogState.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogStateFromJson(json);

  final AppStatus status;
  final List<LogData> logDatas;

  ActivityLogState loading() {
    return copyWith(status: AppStatus.loading);
  }

  ActivityLogState copyWith({AppStatus? status, List<LogData>? logDatas}) {
    return ActivityLogState(
      status: status ?? this.status,
      logDatas: logDatas ?? this.logDatas,
    );
  }

  Map<String, dynamic> toJson() => _$ActivityLogStateToJson(this);

  @override
  List<Object?> get props => [status, logDatas];
}
