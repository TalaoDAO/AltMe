import 'package:altme/activity_log/activity_log.dart';
import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'activity_log_cubit.g.dart';
part 'activity_log_state.dart';

class ActivityLogCubit extends Cubit<ActivityLogState> {
  ActivityLogCubit({required this.activityLogManager})
    : super(ActivityLogState());

  final ActivityLogManager activityLogManager;

  final log = getLogger('ActivityLogCubit');

  Future<void> getAllLogs() async {
    final logs = await activityLogManager.readAllLogs();
    emit(state.copyWith(logDatas: logs, status: AppStatus.populate));
  }
}
