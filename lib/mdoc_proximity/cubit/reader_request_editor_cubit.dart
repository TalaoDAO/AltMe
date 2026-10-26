import 'package:altme/mdoc_proximity/helpers/reader_document_presets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:uuid/uuid.dart';

/// A data element the reader asks for.
class ReaderClaimDraft extends Equatable {
  /// Creates a claim.
  const ReaderClaimDraft(this.identifier, {this.retain = false});

  /// The data element identifier, e.g. `family_name`.
  final String identifier;

  /// Whether the reader says it keeps the value (intent to retain).
  final bool retain;

  @override
  List<Object?> get props => [identifier, retain];
}

/// One document type and name space of the request, with its claims.
class ReaderDocumentDraft extends Equatable {
  /// Creates a document.
  const ReaderDocumentDraft({
    this.docType = '',
    this.nameSpace = '',
    this.claims = const [],
    this.uid = 0,
  });

  /// Tells the document from the others in the editor while it changes place.
  final int uid;

  /// The mdoc document type.
  final String docType;

  /// The name space the [claims] belong to.
  final String nameSpace;

  /// What is asked for in [nameSpace].
  final List<ReaderClaimDraft> claims;

  /// The preset this document is, if it is one.
  ReaderDocumentPreset? get preset => readerDocumentPresets
      .where(
        (preset) =>
            preset.docType == docType.trim() &&
            preset.nameSpace == nameSpace.trim(),
      )
      .firstOrNull;

  /// What can be filled in.
  bool get isComplete =>
      docType.trim().isNotEmpty &&
      nameSpace.trim().isNotEmpty &&
      claims.isNotEmpty;

  /// A copy with some fields replaced.
  ReaderDocumentDraft copyWith({
    String? docType,
    String? nameSpace,
    List<ReaderClaimDraft>? claims,
  }) => ReaderDocumentDraft(
    docType: docType ?? this.docType,
    nameSpace: nameSpace ?? this.nameSpace,
    claims: claims ?? this.claims,
    uid: uid,
  );

  @override
  List<Object?> get props => [docType, nameSpace, claims, uid];
}

/// The request being written.
class ReaderRequestEditorState extends Equatable {
  /// Creates the state.
  const ReaderRequestEditorState({
    this.name = '',
    this.documents = const [ReaderDocumentDraft()],
    this.showErrors = false,
  });

  /// What the user picks in the list.
  final String name;

  /// One entry per document type and name space.
  final List<ReaderDocumentDraft> documents;

  /// Whether the fields that cannot be saved are marked. Set by a first try
  /// to save.
  final bool showErrors;

  /// Whether the request can be saved.
  bool get isValid =>
      name.trim().isNotEmpty &&
      documents.isNotEmpty &&
      documents.every((document) => document.isComplete);

  /// A copy with some fields replaced.
  ReaderRequestEditorState copyWith({
    String? name,
    List<ReaderDocumentDraft>? documents,
    bool? showErrors,
  }) => ReaderRequestEditorState(
    name: name ?? this.name,
    documents: documents ?? this.documents,
    showErrors: showErrors ?? this.showErrors,
  );

  @override
  List<Object?> get props => [name, documents, showErrors];
}

/// Writes a [ReaderRequest]: a new one, or a change to a saved one.
class ReaderRequestEditorCubit extends Cubit<ReaderRequestEditorState> {
  /// Creates the cubit; [initial] is the request to change.
  ReaderRequestEditorCubit({ReaderRequest? initial})
    : id = initial?.id ?? const Uuid().v4(),
      super(_stateOf(initial));

  /// The id the request is saved under.
  final String id;

  static ReaderRequestEditorState _stateOf(ReaderRequest? request) {
    if (request == null) return const ReaderRequestEditorState();
    final documents = [
      for (final MapEntry(key: docType, value: nameSpaces)
          in request.query.entries)
        for (final MapEntry(key: nameSpace, value: elements)
            in nameSpaces.entries)
          (docType, nameSpace, elements),
    ];
    return ReaderRequestEditorState(
      name: request.name,
      documents: documents.isEmpty
          ? const [ReaderDocumentDraft()]
          : [
              for (final (uid, (docType, nameSpace, elements))
                  in documents.indexed)
                ReaderDocumentDraft(
                  docType: docType,
                  nameSpace: nameSpace,
                  claims: [
                    for (final MapEntry(key: element, value: retain)
                        in elements.entries)
                      ReaderClaimDraft(element, retain: retain),
                  ],
                  uid: uid,
                ),
            ],
    );
  }

  late var _nextUid = state.documents.length;

  /// Sets the name.
  void setName(String name) => emit(state.copyWith(name: name));

  /// Adds an empty document.
  void addDocument() => emit(
    state.copyWith(
      documents: [
        ...state.documents,
        ReaderDocumentDraft(uid: _nextUid++),
      ],
    ),
  );

  /// Removes the document at [index]; the last one stays.
  void removeDocument(int index) {
    if (state.documents.length < 2) return;
    emit(state.copyWith(documents: [...state.documents]..removeAt(index)));
  }

  /// Sets the document type of the document at [index].
  void setDocType(int index, String docType) =>
      _update(index, (document) => document.copyWith(docType: docType));

  /// Sets the name space of the document at [index].
  void setNameSpace(int index, String nameSpace) =>
      _update(index, (document) => document.copyWith(nameSpace: nameSpace));

  /// Makes the document at [index] a [preset]. Its claims stay when it already
  /// was that preset, else they are cleared: they belong to another document.
  void applyPreset(int index, ReaderDocumentPreset preset) => _update(
    index,
    (document) => ReaderDocumentDraft(
      docType: preset.docType,
      nameSpace: preset.nameSpace,
      claims: document.preset == preset ? document.claims : const [],
      uid: document.uid,
    ),
  );

  /// Asks for [identifier] in the document at [index]. Returns `false`, and
  /// changes nothing, when it is blank or already asked for.
  bool addClaim(int index, String identifier) {
    final claim = identifier.trim();
    final claims = state.documents[index].claims;
    if (claim.isEmpty || claims.any((c) => c.identifier == claim)) {
      return false;
    }
    _update(
      index,
      (document) =>
          document.copyWith(claims: [...claims, ReaderClaimDraft(claim)]),
    );
    return true;
  }

  /// Stops asking for [identifier] in the document at [index].
  void removeClaim(int index, String identifier) => _update(
    index,
    (document) => document.copyWith(
      claims: [
        for (final claim in document.claims)
          if (claim.identifier != identifier) claim,
      ],
    ),
  );

  /// Sets the intent to retain of [identifier] in the document at [index].
  void setRetain(int index, String identifier, {required bool retain}) =>
      _update(
        index,
        (document) => document.copyWith(
          claims: [
            for (final claim in document.claims)
              if (claim.identifier == identifier)
                ReaderClaimDraft(identifier, retain: retain)
              else
                claim,
          ],
        ),
      );

  /// The request to save, or `null` while a field is missing, which then shows.
  ReaderRequest? submit() {
    if (!state.isValid) {
      emit(state.copyWith(showErrors: true));
      return null;
    }
    // Documents with the same type and name space become one.
    final query = <String, Map<String, Map<String, bool>>>{};
    for (final document in state.documents) {
      final elements = query
          .putIfAbsent(document.docType.trim(), () => {})
          .putIfAbsent(document.nameSpace.trim(), () => {});
      for (final claim in document.claims) {
        elements.putIfAbsent(claim.identifier, () => claim.retain);
      }
    }
    return ReaderRequest(id: id, name: state.name.trim(), query: query);
  }

  void _update(
    int index,
    ReaderDocumentDraft Function(ReaderDocumentDraft document) change,
  ) => emit(
    state.copyWith(
      documents: [
        for (final (i, document) in state.documents.indexed)
          if (i == index) change(document) else document,
      ],
    ),
  );
}
