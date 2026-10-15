import 'package:dio/dio.dart';
import 'package:altme/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _refusal(Map<String, dynamic> body, {String? challenge}) =>
    DioException(
      requestOptions: RequestOptions(),
      response: Response(
        requestOptions: RequestOptions(),
        statusCode: 400,
        data: body,
        headers: Headers.fromMap({
          if (challenge != null)
            'OAuth-Client-Attestation-Challenge': [challenge],
        }),
      ),
    );

void main() {
  group('attestationChallengeRequest', () {
    test('reads the challenge the authorization server supplied', () {
      final request = attestationChallengeRequest(
        _refusal({
          'error': 'use_attestation_challenge',
          'error_description':
              'Authorization Server requires a fresh '
              'challenge',
        }, challenge: 'abc123'),
      );

      expect(request.requested, isTrue);
      expect(request.challenge, 'abc123');
    });

    test('is a request without a header too', () {
      // The challenge then comes from the challenge endpoint.
      final request = attestationChallengeRequest(
        _refusal({'error': 'use_attestation_challenge'}),
      );

      expect(request.requested, isTrue);
      expect(request.challenge, isNull);
    });

    test('is not a request for any other error', () {
      final request = attestationChallengeRequest(
        _refusal({'error': 'invalid_client'}, challenge: 'abc123'),
      );

      expect(request.requested, isFalse);
      expect(request.challenge, isNull);
    });

    test('is not a request for an error with no response', () {
      expect(
        attestationChallengeRequest(Exception('offline')).requested,
        isFalse,
      );
    });
  });
}
