import 'dart:convert';

import 'package:altme/ai/widget/ai_analysis_page.dart';
import 'package:altme/app/shared/constants/icon_strings.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/enum/type/profile/profile_type.dart';
import 'package:altme/app/shared/loading/loading_view.dart';
import 'package:altme/app/shared/widget/button/my_elevated_button.dart';
import 'package:altme/app/shared/widget/dialog/confirm_dialog.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

extension on ProfileType {
  String get aiProfile {
    switch (this) {
      case ProfileType.defaultOne:
      case ProfileType.inji:
      case ProfileType.enterprise:
      case ProfileType.custom:
        return 'custom';
      case ProfileType.ebsiV3:
        return 'EBSI';
      case ProfileType.diipv3:
        return 'DIIP_V3';
      case ProfileType.diipv4:
        return 'DIIP_V4';
      case ProfileType.europeanWallet:
        return 'EWC';
    }
  }
}

class AiRequestAnalysisButton extends StatelessWidget {
  const AiRequestAnalysisButton({
    super.key,
    required this.link,
  });

  final String link;

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
          LoadingView().show(context: context, text: l10n.aiPleaseWait);
          final client = DioClient(
            secureStorageProvider: getSecureStorage,
            dio: Dio(),
          );
          // use client to send post request to https://talao.co/wallet/qrcode with 'qrcode' in the body. the value of qrcode is the link in base64 encoded.
          // Encode the link to base64
          final base64Link = base64Encode(utf8.encode(link));
          final DotEnv dotenv = DotEnv();

          await dotenv.load();

          final headers = <String, dynamic>{
            'Content-Type': 'application/x-www-form-urlencoded',
            'api-key': dotenv.get('WALLET_API_KEY_ID360'),
          };
          try {
            final response = await client.post(
              'https://talao.co/ai/wallet/qrcode',
              data: {
                'qrcode': base64Link,
                'oidc4vciDraft': context
                    .read<ProfileCubit>()
                    .state
                    .model
                    .profileSetting
                    .selfSovereignIdentityOptions
                    .customOidc4vcProfile
                    .oidc4vciDraft
                    .numbering,
                'oidc4vpDraft': context
                    .read<ProfileCubit>()
                    .state
                    .model
                    .profileSetting
                    .selfSovereignIdentityOptions
                    .customOidc4vcProfile
                    .oidc4vpDraft
                    .numbering,
                'profil': context
                    .read<ProfileCubit>()
                    .state
                    .model
                    .profileType
                    .aiProfile,
              },
              headers: headers,
              timeout: 90,
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
