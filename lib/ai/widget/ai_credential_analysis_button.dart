import 'package:altme/ai/widget/ai_analysis_page.dart';
import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/loading/loading_view.dart';
import 'package:altme/app/shared/widget/button/my_elevated_button.dart';
import 'package:altme/app/shared/widget/dialog/confirm_dialog.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:secure_storage/secure_storage.dart';

class AiCredentialAnalysisButton extends StatelessWidget {
  const AiCredentialAnalysisButton({
    super.key,
    required this.credential,
  });

  /// received credential is already in base64 format if it is a jwt and
  /// is converted to base64 if it is a json-ld
  final String credential;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = context.l10n;
    return MyElevatedButton(
      text: l10n.iaAnalyzeTitle,
      onPressed: () async {
        /// open popup which explain user is about to share
        /// current link with talao.io. In the popup User can
        /// press on the accept button to continue or cancel
        /// to close the popup
        final acceptAnalysis = await showDialog<bool>(
              context: context,
              builder: (BuildContext context) {
                return ConfirmDialog(
                  icon: IconStrings.share,
                  title: l10n.iaAnalyzeTitle,
                  subtitle: l10n.iaAnalyze,
                  yes: l10n.communicationHostAllow,
                  no: l10n.communicationHostDeny,
                  //lock: state.uri!.scheme == 'http',
                );
              },
            ) ??
            false;
        if (acceptAnalysis) {
          LoadingView().show(context: context);
          final client = DioClient(
            secureStorageProvider: getSecureStorage,
            dio: Dio(),
          );
          // use client to send post request to https://talao.co/wallet/qrcode with 'qrcode' in the body. the value of qrcode is the link in base64 encoded.
          // Encode the link to base64
          final DotEnv dotenv = DotEnv();

          await dotenv.load();

          final headers = <String, dynamic>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'api-key': dotenv.get('WALLET_API_KEY_ID360'),
          };
          try {
            final response = await client.post(
              'https://talao.co/ai/wallet/vc',
              data: {
                'vc': credential,
              },
              headers: headers,
            ) as String;
            if (response == '') {
              throw Exception('Ai analysis is null or empty');
            }
            LoadingView().hide();
            await Navigator.of(context).push<void>(
              AiAnalysisPage.route(
                content: response,
              ),
            );
          } catch (e) {
            LoadingView().hide();
            Exception('Error during AI analysis: $e');
            // Optionally show error message to user
          }
        }
      },
    );
  }
}
