import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_proximity_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:altme/mdoc_proximity/widgets/mdoc_request_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// Presents an mdoc to a reader in person (ISO/IEC 18013-5).
class MdocProximityPage extends StatelessWidget {
  /// Creates the page.
  const MdocProximityPage({super.key, required this.credentialModel});

  /// The mdoc to present. Must satisfy `canPresentInProximity`.
  final CredentialModel credentialModel;

  /// The route to this page.
  static Route<dynamic> route({required CredentialModel credentialModel}) =>
      MaterialPageRoute<void>(
        builder: (_) => MdocProximityPage(credentialModel: credentialModel),
        settings: const RouteSettings(name: '/MdocProximityPage'),
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MdocProximityCubit(proximity: MdocProximity())
        ..start(
          issuerSigned: credentialModel.mdocIssuerSigned!,
          keyAlias: credentialModel.keyId!,
        ),
      child: MdocProximityView(credentialModel: credentialModel),
    );
  }
}

/// The proximity session, one screen per state.
class MdocProximityView extends StatelessWidget {
  /// Creates the view.
  const MdocProximityView({super.key, required this.credentialModel});

  /// The mdoc being presented.
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BasePage(
      title: l10n.mdocProximityTitle,
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      scrollView: false,
      secureScreen: true,
      body: BlocBuilder<MdocProximityCubit, ProximityState>(
        builder: (context, state) {
          final cubit = context.read<MdocProximityCubit>();
          return switch (state) {
            ProximityPreparing() => _Waiting(l10n.mdocProximityPreparing),
            ProximityConnected() => _Waiting(l10n.mdocProximityConnected),
            ProximitySending() => _Waiting(l10n.mdocProximitySending),
            ProximityWaitingForTap() => _Message(
              icon: Icons.nfc,
              text: l10n.mdocProximityWaitingForTap,
            ),
            ProximityShowQrCode(:final uri) => _QrCode(uri: uri),
            ProximityBluetoothRequired(:final authorization) => _Message(
              icon: Icons.bluetooth_disabled,
              text: authorization
                  ? l10n.mdocProximityBluetoothPermission
                  : l10n.mdocProximityBluetoothOff,
              actions: [
                if (authorization)
                  MyOutlinedButton(
                    text: l10n.mdocProximityOpenSettings,
                    onPressed: openAppSettings,
                  ),
                MyElevatedButton(text: l10n.tryAgain, onPressed: cubit.restart),
              ],
            ),
            ProximityRequest(:final documents) => MdocRequestView(
              credentialModel: credentialModel,
              documents: documents,
              onShare: cubit.approve,
              onCancel: () => Navigator.of(context).pop(),
            ),
            ProximitySuccess() => _Message(
              icon: Icons.check_circle_outline,
              text: l10n.mdocProximitySuccess,
              actions: [
                MyElevatedButton(
                  text: l10n.done,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            ProximityFailure(:final reason, :final message) => _Message(
              icon: Icons.error_outline,
              text: switch (reason) {
                ProximityFailureReason.timeout => l10n.mdocProximityTimeout,
                ProximityFailureReason.readerDisconnected =>
                  l10n.mdocProximityReaderDisconnected,
                ProximityFailureReason.nfcUnavailable =>
                  l10n.mdocProximityNfcUnavailable,
                ProximityFailureReason.error => l10n.mdocProximityError,
              },
              detail: message,
              actions: [
                MyElevatedButton(
                  text: l10n.tryAgain,
                  onPressed: () => cubit.restart(
                    engagement: reason == ProximityFailureReason.nfcUnavailable
                        ? ProximityEngagement.qrCode
                        : null,
                  ),
                ),
                MyOutlinedButton(
                  text: l10n.close,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          };
        },
      ),
    );
  }
}

class _Waiting extends StatelessWidget {
  const _Waiting(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(text, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.text,
    this.detail,
    this.actions = const [],
  });

  final IconData icon;
  final String text;
  final String? detail;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(icon, size: 64),
        const SizedBox(height: 16),
        Text(text, textAlign: TextAlign.center),
        if (detail != null) ...[
          const SizedBox(height: 8),
          Text(
            detail!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
        for (final action in actions) ...[const SizedBox(height: 8), action],
      ],
    );
  }
}

class _QrCode extends StatelessWidget {
  const _QrCode({required this.uri});

  final String uri;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.mdocProximityScanQrCode, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        Center(
          child: QrImageView(
            data: uri,
            size: 260,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
