import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/mdoc_proximity/cubit/mdoc_proximity_cubit.dart';
import 'package:altme/mdoc_proximity/helpers/mdoc_credential_model.dart';
import 'package:altme/mdoc_proximity/widgets/mdoc_request_view.dart';
import 'package:altme/mdoc_proximity/widgets/proximity_message.dart';
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
      body: BlocConsumer<MdocProximityCubit, ProximityState>(
        // Like an OIDC4VP presentation, success is a snackbar on the
        // dashboard rather than a screen of its own.
        listenWhen: (previous, current) =>
            current is ProximitySuccess && previous is! ProximitySuccess,
        listener: (context, state) {
          AlertMessage.showStateMessage(
            context: context,
            stateMessage: StateMessage.success(
              messageHandler: ResponseMessage(
                message: ResponseString
                    .RESPONSE_STRING_SUCCESSFULLY_PRESENTED_YOUR_CREDENTIAL,
              ),
            ),
          );
          Navigator.popUntil(
            context,
            (route) => route.settings.name == AltMeStrings.dashBoardPage,
          );
        },
        builder: (context, state) {
          final cubit = context.read<MdocProximityCubit>();
          return switch (state) {
            ProximityPreparing() => ProximityWaiting(
              l10n.mdocProximityPreparing,
            ),
            ProximityConnected() => ProximityWaiting(
              l10n.mdocProximityConnected,
            ),
            ProximitySending() => ProximityWaiting(l10n.mdocProximitySending),
            ProximityWaitingForTap() => ProximityMessage(
              icon: Icons.nfc,
              text: l10n.mdocProximityWaitingForTap,
              actions: [
                MyOutlinedButton(
                  text: l10n.mdocProximityQrCodeInstead,
                  onPressed: () =>
                      cubit.restart(engagement: ProximityEngagement.qrCode),
                ),
              ],
            ),
            ProximityShowQrCode(:final uri) => _QrCode(uri: uri),
            ProximityBluetoothRequired(:final authorization) =>
              ProximityMessage(
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
                  MyElevatedButton(
                    text: l10n.tryAgain,
                    onPressed: cubit.restart,
                  ),
                ],
              ),
            ProximityRequest(:final documents) => MdocRequestView(
              credentialModel: credentialModel,
              documents: documents,
              onShare: cubit.approve,
              onCancel: () => Navigator.of(context).pop(),
            ),
            // The listener pops back to the dashboard.
            ProximitySuccess() => const SizedBox.shrink(),
            ProximityFailure(:final reason, :final message) => ProximityMessage(
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

class _QrCode extends StatefulWidget {
  const _QrCode({required this.uri});

  final String uri;

  @override
  State<_QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<_QrCode> {
  late final Future<ProximityNfcAvailability> _nfcAvailability = context
      .read<MdocProximityCubit>()
      .nfcAvailability();

  String get uri => widget.uri;

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
        const SizedBox(height: 20),
        // NFC engagement is Android only; the plugin reports it unsupported
        // on iOS and on phones without host card emulation.
        FutureBuilder<ProximityNfcAvailability>(
          future: _nfcAvailability,
          builder: (context, snapshot) =>
              snapshot.data == ProximityNfcAvailability.available
              ? MyOutlinedButton(
                  text: l10n.mdocProximityTapInstead,
                  onPressed: () => context.read<MdocProximityCubit>().restart(
                    engagement: ProximityEngagement.nfc,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
