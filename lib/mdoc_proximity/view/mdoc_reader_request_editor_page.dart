import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/custom_reader_requests_cubit.dart';
import 'package:altme/mdoc_proximity/cubit/reader_request_editor_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/reader_document_presets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

/// Asks whether to delete [request] and, when the user agrees, deletes it.
/// Returns whether it did.
Future<bool> confirmDeleteReaderRequest(
  BuildContext context,
  ReaderRequest request,
) async {
  final l10n = context.l10n;
  final confirm =
      await showDialog<bool>(
        context: context,
        builder: (_) => ConfirmDialog(
          title: l10n.mdocReaderRequestDeleteTitle,
          subtitle: request.name,
          icon: IconStrings.warning,
          yes: l10n.delete,
          no: l10n.cancel,
        ),
      ) ??
      false;
  if (!confirm || !context.mounted) return false;
  await context.read<CustomReaderRequestsCubit>().delete(request.id);
  return true;
}

/// Writes a reader request of the user's own: its name, and for each document
/// its type, name space and claims. Saves it with [CustomReaderRequestsCubit].
class MdocReaderRequestEditorPage extends StatelessWidget {
  /// Creates the page; [request] is the saved request to change, `null` for a
  /// new one.
  const MdocReaderRequestEditorPage({super.key, this.request});

  /// The request to change.
  final ReaderRequest? request;

  /// The route to this page.
  static Route<void> route({ReaderRequest? request}) => MaterialPageRoute<void>(
    builder: (_) => MdocReaderRequestEditorPage(request: request),
    settings: const RouteSettings(name: '/MdocReaderRequestEditorPage'),
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReaderRequestEditorCubit(initial: request),
      child: MdocReaderRequestEditorView(saved: request),
    );
  }
}

/// The fields of [MdocReaderRequestEditorPage].
class MdocReaderRequestEditorView extends StatelessWidget {
  /// Creates the view.
  const MdocReaderRequestEditorView({super.key, this.saved});

  /// The saved request being changed, `null` for a new one.
  final ReaderRequest? saved;

  Future<void> _save(BuildContext context) async {
    final request = context.read<ReaderRequestEditorCubit>().submit();
    if (request == null) return;
    await context.read<CustomReaderRequestsCubit>().save(request);
    if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> _delete(BuildContext context, ReaderRequest request) async {
    if (await confirmDeleteReaderRequest(context, request) && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<ReaderRequestEditorCubit>();
    final saved = this.saved;
    return BasePage(
      title: saved == null
          ? l10n.mdocReaderRequestNewTitle
          : l10n.mdocReaderRequestEditTitle,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: true,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceSmall),
      body: BlocBuilder<ReaderRequestEditorCubit, ReaderRequestEditorState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Room for the floating label of the first field.
              const SizedBox(height: Sizes.spaceXSmall),
              _SyncedTextField(
                value: state.name,
                label: l10n.mdocReaderRequestName,
                error: state.showErrors && state.name.trim().isEmpty
                    ? l10n.mdocReaderRequestRequired
                    : null,
                onChanged: cubit.setName,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              for (final (index, document) in state.documents.indexed) ...[
                _DocumentCard(
                  key: ValueKey(document.uid),
                  index: index,
                  document: document,
                  showErrors: state.showErrors,
                  removable: state.documents.length > 1,
                ),
                const SizedBox(height: Sizes.spaceSmall),
              ],
              MyOutlinedButton(
                text: l10n.mdocReaderRequestAddDocument,
                onPressed: cubit.addDocument,
              ),
              const SizedBox(height: Sizes.spaceSmall),
              MyElevatedButton(
                text: l10n.save,
                onPressed: () => _save(context),
              ),
              if (saved != null) ...[
                const SizedBox(height: Sizes.spaceSmall),
                MyOutlinedButton(
                  text: l10n.delete,
                  onPressed: () => _delete(context, saved),
                ),
              ],
              const SizedBox(height: Sizes.spaceSmall),
            ],
          );
        },
      ),
    );
  }
}

/// One document type and name space, and the claims asked for in it.
class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    super.key,
    required this.index,
    required this.document,
    required this.showErrors,
    required this.removable,
  });

  final int index;
  final ReaderDocumentDraft document;
  final bool showErrors;
  final bool removable;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final cubit = context.read<ReaderRequestEditorCubit>();
    final preset = document.preset;
    final suggestions = [
      for (final claim in preset?.claims ?? const <String>[])
        if (!document.claims.any((c) => c.identifier == claim)) claim,
    ];
    final claimsMissing = showErrors && document.claims.isEmpty;

    return BackgroundCard(
      padding: const EdgeInsets.all(Sizes.spaceSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.mdocReaderRequestDocument(index + 1),
                  style: textTheme.titleMedium,
                ),
              ),
              if (removable)
                IconButton(
                  tooltip: l10n.delete,
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => cubit.removeDocument(index),
                ),
            ],
          ),
          Wrap(
            spacing: Sizes.spaceXSmall,
            children: [
              for (final candidate in readerDocumentPresets)
                ChoiceChip(
                  label: Text(candidate.name),
                  selected: preset == candidate,
                  onSelected: (_) => cubit.applyPreset(index, candidate),
                ),
            ],
          ),
          const SizedBox(height: Sizes.spaceSmall),
          _SyncedTextField(
            value: document.docType,
            label: l10n.mdocReaderRequestDocType,
            error: showErrors && document.docType.trim().isEmpty
                ? l10n.mdocReaderRequestRequired
                : null,
            onChanged: (value) => cubit.setDocType(index, value),
          ),
          const SizedBox(height: Sizes.spaceSmall),
          _SyncedTextField(
            value: document.nameSpace,
            label: l10n.mdocReaderRequestNameSpace,
            error: showErrors && document.nameSpace.trim().isEmpty
                ? l10n.mdocReaderRequestRequired
                : null,
            onChanged: (value) => cubit.setNameSpace(index, value),
          ),
          const SizedBox(height: Sizes.spaceSmall),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.mdocReaderRequestClaims,
                  style: textTheme.titleSmall,
                ),
              ),
              if (document.claims.isNotEmpty) ...[
                Text(l10n.mdocReaderRequestRetain, style: textTheme.bodySmall),
                // The width of the remove button of a claim.
                const SizedBox(width: 48),
              ],
            ],
          ),
          if (document.claims.isNotEmpty)
            Text(l10n.mdocReaderRequestRetainHint, style: textTheme.bodySmall)
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: Sizes.spaceXSmall),
              child: Text(
                claimsMissing
                    ? l10n.mdocReaderRequestClaimsRequired
                    : l10n.mdocReaderRequestNoClaims,
                style: textTheme.bodySmall?.copyWith(
                  color: claimsMissing
                      ? Theme.of(context).colorScheme.error
                      : null,
                ),
              ),
            ),
          for (final claim in document.claims)
            _ClaimRow(
              key: ValueKey(claim.identifier),
              claim: claim,
              onRetainChanged: (retain) =>
                  cubit.setRetain(index, claim.identifier, retain: retain),
              onRemove: () => cubit.removeClaim(index, claim.identifier),
            ),
          if (suggestions.isNotEmpty)
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              childrenPadding: EdgeInsets.zero,
              shape: const Border(),
              collapsedShape: const Border(),
              expandedAlignment: Alignment.centerLeft,
              title: Text(
                '${l10n.mdocReaderRequestSuggestedClaims} '
                '(${suggestions.length})',
                style: textTheme.bodyMedium,
              ),
              children: [
                Wrap(
                  spacing: Sizes.spaceXSmall,
                  children: [
                    for (final claim in suggestions)
                      ActionChip(
                        label: Text('+ $claim'),
                        onPressed: () => cubit.addClaim(index, claim),
                      ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: Sizes.spaceSmall),
          _AddClaimField(onAdd: (claim) => cubit.addClaim(index, claim)),
        ],
      ),
    );
  }
}

/// A claim asked for, with its intent to retain.
class _ClaimRow extends StatelessWidget {
  const _ClaimRow({
    super.key,
    required this.claim,
    required this.onRetainChanged,
    required this.onRemove,
  });

  final ReaderClaimDraft claim;
  final ValueChanged<bool> onRetainChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            claim.identifier,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Switch(value: claim.retain, onChanged: onRetainChanged),
        IconButton(
          tooltip: context.l10n.delete,
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ],
    );
  }
}

/// A field to type the identifier of a claim, e.g. `family_name`, and add it.
class _AddClaimField extends StatefulWidget {
  const _AddClaimField({required this.onAdd});

  /// Adds the claim; returns whether it did.
  final bool Function(String claim) onAdd;

  @override
  State<_AddClaimField> createState() => _AddClaimFieldState();
}

class _AddClaimFieldState extends State<_AddClaimField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    if (widget.onAdd(_controller.text)) _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: _controller,
      label: context.l10n.mdocReaderRequestAddClaim,
      hint: context.l10n.mdocReaderRequestClaimHint,
      suffixIcon: IconButton(
        tooltip: context.l10n.mdocReaderRequestAddClaim,
        icon: const Icon(Icons.add),
        onPressed: _add,
      ),
    );
  }
}

/// A [BaseTextField] showing [value], which the cubit owns: it changes
/// [value] when the user types, and the field follows when it changes by
/// another way, e.g. a preset.
class _SyncedTextField extends StatefulWidget {
  const _SyncedTextField({
    required this.value,
    required this.label,
    required this.onChanged,
    this.error,
  });

  final String value;
  final String label;
  final String? error;
  final ValueChanged<String> onChanged;

  @override
  State<_SyncedTextField> createState() => _SyncedTextFieldState();
}

class _SyncedTextFieldState extends State<_SyncedTextField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.value)
      ..addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (_controller.text != widget.value) widget.onChanged(_controller.text);
  }

  @override
  void didUpdateWidget(_SyncedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller.text != widget.value) _controller.text = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: _controller,
      label: widget.label,
      error: widget.error,
    );
  }
}
