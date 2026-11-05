import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/oidc4vc/oidc4vc.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final requestedAt = DateTime.utc(2026, 11, 5, 12);

  CredentialModel card(String id, {Object? interval = 30}) => CredentialModel(
    id: id,
    image: '',
    shareLink: '',
    data: const {},
    credentialPreview: Credential.dummy(),
    pendingInfo: PendingInfo(
      encodedCredentialFromOIDC4VC: {
        'transaction_id': 'tx-$id',
        'interval': ?interval,
      },
      accessToken: 'access-token',
      deferredCredentialEndpoint: 'https://issuer.example/deferred',
      format: 'dc+sd-jwt',
      url: 'openid-credential-offer://',
      issuer: 'https://issuer.example',
      requestedAt: requestedAt,
    ),
  );

  final issued = CredentialModel(
    id: 'issued',
    image: '',
    shareLink: '',
    data: const {},
    credentialPreview: Credential.dummy(),
  );

  /// A poller whose clock starts at [requestedAt] + [elapsed] and follows
  /// [async]; each fetch records the card and answers the next of [answers]
  /// (an exception is thrown), null once they run out.
  (DeferredCredentialPoller, List<String>) build(
    FakeAsync async,
    List<Object?> answers, {
    Duration elapsed = Duration.zero,
  }) {
    final start = requestedAt.add(elapsed);
    final fetched = <String>[];
    var index = 0;
    return (
      DeferredCredentialPoller(
        fetch: (pending) async {
          fetched.add(pending.id);
          final answer = index < answers.length ? answers[index++] : null;
          if (answer is Exception) throw answer;
          return answer as Duration?;
        },
        now: () => start.add(async.elapsed),
      ),
      fetched,
    );
  }

  group('DeferredCredentialPoller', () {
    test("asks once the issuer's interval has passed since the request", () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller.track([card('a'), issued]);
        async.elapse(const Duration(seconds: 29));
        expect(fetched, isEmpty);
        async.elapse(const Duration(seconds: 1));
        expect(fetched, ['a']);
      });
    });

    test('asks at once for a card already due, e.g. at app start', () {
      fakeAsync((async) {
        final (poller, fetched) = build(
          async,
          const [],
          elapsed: const Duration(hours: 1),
        );

        poller.track([card('a')]);
        async.flushTimers();
        expect(fetched, ['a']);
      });
    });

    test('waits 5 seconds when the issuer gave no interval', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller.track([card('a', interval: null)]);
        async.elapse(const Duration(seconds: 4));
        expect(fetched, isEmpty);
        async.elapse(const Duration(seconds: 1));
        expect(fetched, ['a']);
      });
    });

    test('asks again at each new interval until the credential is stored', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, [
          const Duration(seconds: 10),
          const Duration(seconds: 20),
        ]);

        poller.track([card('a')]);
        async.elapse(const Duration(seconds: 30));
        expect(fetched, hasLength(1));
        async.elapse(const Duration(seconds: 10));
        expect(fetched, hasLength(2));
        async.elapse(const Duration(seconds: 20));
        expect(fetched, hasLength(3));
        // Stored: not asked for again, even when tracked again.
        poller.track([card('a')]);
        async.elapse(const Duration(minutes: 5));
        expect(fetched, hasLength(3));
      });
    });

    test('stops when the issuer refuses', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, [Exception('invalid_token')]);

        poller.track([card('a')]);
        async.elapse(const Duration(seconds: 30));
        poller.track([card('a')]);
        async.elapse(const Duration(minutes: 5));
        expect(fetched, ['a']);
      });
    });

    test('does not ask twice for a card tracked twice', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller
          ..track([card('a')])
          ..track([card('a')]);
        async.elapse(const Duration(seconds: 30));
        expect(fetched, ['a']);
      });
    });

    test('forgets a card no longer pending', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller
          ..track([card('a')])
          ..track([issued]);
        async.elapse(const Duration(minutes: 5));
        expect(fetched, isEmpty);
      });
    });

    test('stops while asked by hand and resumes after the given wait', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller
          ..track([card('a')])
          ..stop('a');
        async.elapse(const Duration(minutes: 5));
        expect(fetched, isEmpty);

        poller.resume(card('a'), const Duration(seconds: 30));
        async.elapse(const Duration(seconds: 30));
        expect(fetched, ['a']);
      });
    });

    test('asks for nothing once disposed', () {
      fakeAsync((async) {
        final (poller, fetched) = build(async, const []);

        poller
          ..track([card('a')])
          ..dispose()
          ..track([card('b')]);
        async.elapse(const Duration(minutes: 5));
        expect(fetched, isEmpty);
      });
    });
  });
}
