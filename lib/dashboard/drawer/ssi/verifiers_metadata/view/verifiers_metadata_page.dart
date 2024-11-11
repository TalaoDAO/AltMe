import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class VerifiersMetadataPage extends StatelessWidget {
  const VerifiersMetadataPage({super.key});

  static Route<dynamic> route() => MaterialPageRoute<void>(
        builder: (_) => const VerifiersMetadataPage(),
        settings: const RouteSettings(name: '/VerifiersMetadataPage'),
      );

  @override
  Widget build(BuildContext context) {
    return const VerifiersMetadataView();
  }
}

class VerifiersMetadataView extends StatelessWidget {
  const VerifiersMetadataView({super.key});

  Future<String> getData() async {
    try {
      final response = await DioClient(
        secureStorageProvider: getSecureStorage,
        dio: Dio(),
      ).get(Parameters.walletMetadataForVerifier);
      final data = response is String
          ? jsonDecode(response) as Map<String, dynamic>
          : response as Map<String, dynamic>;
      final value = const JsonEncoder.withIndent('  ').convert(data);
      return value;
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: 'Wallet metadata for verifiers',
      titleAlignment: Alignment.topCenter,
      titleLeading: const BackLeadingButton(),
      padding: const EdgeInsets.only(
        top: 0,
        bottom: Sizes.spaceSmall,
        left: Sizes.spaceSmall,
        right: Sizes.spaceSmall,
      ),
      secureScreen: true,
      body: FutureBuilder<String>(
        future: getData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return JsonViewWidget(data: snapshot.data.toString());

            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
