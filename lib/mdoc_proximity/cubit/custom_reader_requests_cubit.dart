import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:secure_storage/secure_storage.dart';

/// The reader requests the user defined.
class CustomReaderRequestsState extends Equatable {
  /// Creates the state.
  const CustomReaderRequestsState({this.requests = const []});

  /// The requests, in the order they were first saved.
  final List<ReaderRequest> requests;

  @override
  List<Object?> get props => [requests];
}

/// Keeps the requests the user defined for the wallet as a reader, next to
/// the profile's own. They stay on the device, whatever the profile.
class CustomReaderRequestsCubit extends Cubit<CustomReaderRequestsState> {
  /// Creates the cubit and loads the saved requests.
  CustomReaderRequestsCubit({required SecureStorageProvider secureStorage})
    : _secureStorage = secureStorage,
      super(const CustomReaderRequestsState()) {
    _loaded = _load();
  }

  final SecureStorageProvider _secureStorage;
  final _log = getLogger('CustomReaderRequestsCubit');
  late final Future<void> _loaded;

  /// Completes once the saved requests are in [state].
  Future<void> get loaded => _loaded;

  Future<void> _load() async {
    final stored = await _secureStorage.get(
      SecureStorageKeys.customReaderRequests,
    );
    if (stored == null || stored.isEmpty) return;

    final requests = <ReaderRequest>[];
    try {
      for (final entry in jsonDecode(stored) as List<dynamic>) {
        try {
          requests.add(ReaderRequest.fromJson(entry as Map<String, dynamic>));
        } on Object catch (e) {
          _log.e('dropped an unreadable request: $e');
        }
      }
    } on Object catch (e) {
      _log.e('unreadable requests: $e');
    }
    emit(CustomReaderRequestsState(requests: requests));
  }

  /// Adds [request], or replaces the one with its id.
  Future<void> save(ReaderRequest request) async {
    await _loaded;
    final requests = [...state.requests];
    final index = requests.indexWhere((saved) => saved.id == request.id);
    if (index == -1) {
      requests.add(request);
    } else {
      requests[index] = request;
    }
    await _store(requests);
  }

  /// Removes the request with [id].
  Future<void> delete(String id) async {
    await _loaded;
    await _store([
      for (final request in state.requests)
        if (request.id != id) request,
    ]);
  }

  Future<void> _store(List<ReaderRequest> requests) async {
    await _secureStorage.set(
      SecureStorageKeys.customReaderRequests,
      jsonEncode([for (final request in requests) request.toJson()]),
    );
    emit(CustomReaderRequestsState(requests: requests));
  }
}
