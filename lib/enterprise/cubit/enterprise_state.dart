part of 'enterprise_cubit.dart';

@JsonSerializable()
class EnterpriseState extends Equatable {
  const EnterpriseState({
    this.status = AppStatus.init,
    this.message,
  });

  factory EnterpriseState.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  EnterpriseState loading() {
    return copyWith(
      status: AppStatus.loading,
      message: null,
    );
  }

  EnterpriseState error({required StateMessage message}) {
    return copyWith(
      status: AppStatus.error,
      message: message,
    );
  }

  EnterpriseState copyWith({
    StateMessage? message,
    AppStatus? status,
  }) {
    return EnterpriseState(
      status: status ?? this.status,
      message: message,
    );
  }

  Map<String, dynamic> toJson() => _$EnterpriseStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
