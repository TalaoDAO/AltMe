import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/widgets/white_close_button.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

/// Loads the content of a document a QES approval request names.
typedef QesDocumentLoader =
    Future<QesDocumentContent?> Function(QesDocumentInfo document);

/// The documents a QES approval request asks to sign, shown before the
/// consent so the user can read what they sign (CSC data model bindings,
/// §6.4). A document whose content doesn't match its checksum stops the
/// approval (§6.3).
class QesDocumentsReview extends StatefulWidget {
  const QesDocumentsReview({
    super.key,
    required this.request,
    required this.onContinue,
    this.loadDocument,
  });

  final QesApprovalRequest request;

  final VoidCallback onContinue;

  /// Loads a document from its `href`; [loadQesDocument] by default.
  final QesDocumentLoader? loadDocument;

  @override
  State<QesDocumentsReview> createState() => _QesDocumentsReviewState();
}

class _QesDocumentsReviewState extends State<QesDocumentsReview> {
  late final Future<List<_LoadedDocument>> _documents = Future.wait(
    widget.request.documentInfos.map(_load),
  );

  Future<_LoadedDocument> _load(QesDocumentInfo document) async {
    final loadDocument =
        widget.loadDocument ??
        (document) => loadQesDocument(document, dio: Dio());
    try {
      return _LoadedDocument(document, content: await loadDocument(document));
    } on TransactionDataException {
      return _LoadedDocument(document, integrityFailed: true);
    } catch (_) {
      return _LoadedDocument(document, loadFailed: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return FutureBuilder<List<_LoadedDocument>>(
      future: _documents,
      builder: (context, snapshot) {
        final documents = snapshot.data;
        final canContinue =
            documents != null &&
            !documents.any((document) => document.integrityFailed);
        return BasePage(
          title: l10n.qesApprovalDocuments,
          titleAlignment: Alignment.topCenter,
          titleTrailing: const WhiteCloseButton(),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          body: documents == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final document in documents)
                      _DocumentCard(document: document),
                  ],
                ),
          navigation: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: MyElevatedButton(
                onPressed: canContinue ? widget.onContinue : null,
                text: l10n.continueString,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoadedDocument {
  const _LoadedDocument(
    this.info, {
    this.content,
    this.integrityFailed = false,
    this.loadFailed = false,
  });

  final QesDocumentInfo info;

  /// Null when the request gave no `href`, or the document didn't load.
  final QesDocumentContent? content;

  final bool integrityFailed;

  final bool loadFailed;
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({required this.document});

  final _LoadedDocument document;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final content = document.content;
    final text = content?.text;
    final oneTimePassword = document.info.oneTimePassword;

    final String? note;
    if (document.integrityFailed) {
      note = l10n.qesDocumentIntegrityFailed;
    } else if (document.loadFailed) {
      note = l10n.qesDocumentLoadFailed;
    } else if (content == null) {
      note = l10n.qesDocumentNoContent;
    } else if (text == null) {
      note = l10n.qesDocumentNotText;
    } else {
      note = null;
    }

    return BackgroundCard(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(document.info.label, style: theme.textTheme.titleLarge),
          ),
          if (text != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: SelectableText(text, style: theme.textTheme.bodyMedium),
            ),
          if (note != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                note,
                style: theme.textTheme.bodyMedium!.copyWith(
                  color: document.integrityFailed
                      ? theme.colorScheme.error
                      : null,
                ),
              ),
            ),
          if (oneTimePassword != null)
            CredentialField(
              title: l10n.qesDocumentOneTimePassword,
              value: oneTimePassword,
              titleColor: onSurface,
              valueColor: onSurface,
              showVertically: true,
            ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                content.integrityVerified
                    ? l10n.qesDocumentIntegrityVerified
                    : l10n.qesDocumentIntegrityNotVerified,
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
