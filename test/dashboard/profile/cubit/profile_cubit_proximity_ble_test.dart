import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:did_kit/did_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockSecureStorageProvider extends Mock
    implements SecureStorageProvider {}

class _MockDIDKitProvider extends Mock implements DIDKitProvider {}

class _MockOIDC4VC extends Mock implements OIDC4VCIClient {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

void main() {
  late _MockSecureStorageProvider secureStorage;

  setUp(() {
    secureStorage = _MockSecureStorageProvider();
    when(() => secureStorage.get(any())).thenAnswer((_) async => null);
    when(() => secureStorage.set(any(), any())).thenAnswer((_) async {});
  });

  ProfileCubit build() => ProfileCubit(
    secureStorageProvider: secureStorage,
    oidc4vc: _MockOIDC4VC(),
    didKitProvider: _MockDIDKitProvider(),
    langCubit: _MockLangCubit(),
    jwtDecode: JWTDecode(),
  );

  group('ProfileCubit.updateProfileSetting', () {
    test('unticks a proximity BLE mode and stores it', () async {
      final cubit = build();
      final before = cubit.state.model.profileSetting;

      await cubit.updateProfileSetting(proximityCentralClient: false);

      final options =
          cubit.state.model.profileSetting.selfSovereignIdentityOptions;
      expect(options.proximityCentralClient, isFalse);
      expect(options.proximityPeripheralServer, isTrue);
      expect(
        options.customOidc4vcProfile,
        before.selfSovereignIdentityOptions.customOidc4vcProfile,
      );

      final stored =
          verify(
                () => secureStorage.set(
                  SecureStorageKeys.customProfileSettings,
                  captureAny(),
                ),
              ).captured.single
              as String;
      expect(
        ProfileSetting.fromJson(
          jsonDecode(stored) as Map<String, dynamic>,
        ).selfSovereignIdentityOptions.proximityCentralClient,
        isFalse,
      );
      await cubit.close();
    });

    test('ticks a proximity BLE mode back', () async {
      final cubit = build();

      await cubit.updateProfileSetting(proximityPeripheralServer: false);
      await cubit.updateProfileSetting(proximityPeripheralServer: true);

      expect(
        cubit
            .state
            .model
            .profileSetting
            .selfSovereignIdentityOptions
            .proximityPeripheralServer,
        isTrue,
      );
      await cubit.close();
    });
  });
}
