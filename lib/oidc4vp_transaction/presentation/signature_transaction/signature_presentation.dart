import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/widget/base/background_card.dart';
import 'package:altme/oidc4vp_transaction/domain/oidc4vp_transaction.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:secure_storage/secure_storage.dart';

class SignaturePresentation extends StatelessWidget {
  const SignaturePresentation(this.signatureTransaction, {super.key});
  final SignatureTransaction signatureTransaction;

  Future<String> _fetchTextFromHref(String href) async {
    if (href.isEmpty) return '';
    try {
      final client = DioClient(
        secureStorageProvider: getSecureStorage,
        dio: Dio(),
      );
      final response = await client.get(href);
      return response.toString();
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final signatureRequests =
        signatureTransaction.transactionJson['signatureRequests']
            as List<dynamic>? ??
        [];
    final signatureRequest =
        signatureRequests[0] as Map<String, dynamic>? ?? {};
    final label = signatureRequest['label'] as String? ?? '';
    final href = signatureRequest['href'] as String? ?? '';

    return Padding(
      padding: const EdgeInsets.all(16),
      child: BackgroundCard(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    label,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall!.copyWith(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: FutureBuilder<String>(
                  future: _fetchTextFromHref(href),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return Center(
                      child: Text(
                        snapshot.data!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
