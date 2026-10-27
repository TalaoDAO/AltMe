import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/profile/profile.dart';
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

/// Presents the wallet's mdocs to a reader in person (ISO/IEC 18013-5): the
/// device engagement QR code, then the reader's request.
///
/// The QR code names no document: the request, once it arrives, says which
/// ones the reader wants, and the wallet's mdocs that can answer are matched
/// to it then.
class MdocPresentView extends StatelessWidget {
  /// Creates the view.
  const MdocPresentView({super.key});

  @override
  Widget build(BuildContext context) {
    final canPresent = context.select<CredentialsCubit, bool>(
      (cubit) => cubit.state.credentials.any(
        (credential) => credential.canPresentInProximity,
      ),
    );
    if (!canPresent) {
      return ProximityMessage(
        icon: Icons.contactless_outlined,
        text: context.l10n.mdocPresentNoAttestation,
      );
    }
    return BlocProvider(
      create: (context) => MdocProximityCubit(
        proximity: MdocProximity(),
        credentials: () => context.read<CredentialsCubit>().state.credentials,
        trustedList: () {
          final profile = context.read<ProfileCubit>().state.model;
          return profile.profileSetting.walletSecurityOptions.trustedList
              ? profile.trustedList
              : null;
        },
        bleModes: () => context
            .read<ProfileCubit>()
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .proximityBleModes,
      )..start(),
      child: const MdocProximityView(),
    );
  }
}

/// The proximity session, one screen per state.
class MdocProximityView extends StatelessWidget {
  /// Creates the view.
  const MdocProximityView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocConsumer<MdocProximityCubit, MdocProximityState>(
      // Like an OIDC4VP presentation, success is a snackbar on the
      // dashboard rather than a screen of its own.
      listenWhen: (previous, current) =>
          current.session is ProximitySuccess &&
          previous.session is! ProximitySuccess,
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
        return switch (state.session) {
          ProximityPreparing() => ProximityWaiting(l10n.mdocProximityPreparing),
          ProximityConnected() => ProximityWaiting(l10n.mdocProximityConnected),
          ProximitySending() => ProximityWaiting(l10n.mdocProximitySending),
          ProximityShowQrCode(:final uri) => _QrCode(uri: uri),
          ProximityBluetoothRequired(:final authorization) => ProximityMessage(
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
            documents: documents,
            candidates: state.candidates,
            reader: state.reader,
            onShare: cubit.approve,
            onDecline: () async {
              await cubit.decline();
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          // The listener pops back to the dashboard.
          ProximitySuccess() => const SizedBox.shrink(),
          ProximityFailure(:final reason, :final message) => ProximityMessage(
            icon: Icons.error_outline,
            text: switch (reason) {
              ProximityFailureReason.timeout => l10n.mdocProximityTimeout,
              ProximityFailureReason.readerDisconnected =>
                l10n.mdocProximityReaderDisconnected,
              ProximityFailureReason.error => l10n.mdocProximityError,
            },
            detail: message,
            actions: [
              MyElevatedButton(text: l10n.tryAgain, onPressed: cubit.restart),
              MyOutlinedButton(
                text: l10n.close,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        };
      },
    );
  }
}

class _QrCode extends StatelessWidget {
  const _QrCode({required this.uri});

  final String uri;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(context.l10n.mdocProximityScanQrCode, textAlign: TextAlign.center),
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
