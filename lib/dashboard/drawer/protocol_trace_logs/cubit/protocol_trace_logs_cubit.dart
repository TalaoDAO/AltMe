import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:altme/app/app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:protocol_trace/protocol_trace.dart';

part 'protocol_trace_logs_cubit.g.dart';
part 'protocol_trace_logs_state.dart';

class ProtocolTraceLogsCubit extends Cubit<ProtocolTraceLogsState> {
  ProtocolTraceLogsCubit() : super(const ProtocolTraceLogsState());

  final log = getLogger('ProtocolTraceLogsCubit');

  /// The folder the active [ProtocolTrace] is writing to, `null` if tracing
  /// is off.
  Directory? get _directory => ProtocolTrace.current?.directory;

  Future<void> getAllLogs() async {
    emit(state.copyWith(status: AppStatus.loading));
    try {
      final directory = _directory;
      final files = directory != null && directory.existsSync()
          ? directory
                .listSync()
                .whereType<File>()
                .where((file) => file.path.endsWith('.log'))
                .toList()
          : <File>[];
      // File names start with the trace timestamp, so this also sorts by
      // recency, newest first.
      files.sort((a, b) => b.path.compareTo(a.path));
      emit(
        state.copyWith(
          status: AppStatus.populate,
          filePaths: [for (final file in files) file.path],
        ),
      );
    } catch (e, s) {
      log.e('Failed to list protocol trace logs: $e', stackTrace: s);
      emit(state.copyWith(status: AppStatus.error, filePaths: const []));
    }
  }

  Future<void> deleteAll() async {
    for (final path in state.filePaths) {
      try {
        final file = File(path);
        if (file.existsSync()) {
          file.deleteSync();
        }
      } catch (e, s) {
        log.e('Failed to delete protocol trace log $path: $e', stackTrace: s);
      }
    }
    emit(state.copyWith(status: AppStatus.populate, filePaths: const []));
  }
}
