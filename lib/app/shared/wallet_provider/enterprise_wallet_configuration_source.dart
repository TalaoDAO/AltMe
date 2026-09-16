import 'dart:convert';

import 'package:altme/app/shared/constants/secure_storage_keys.dart';
import 'package:altme/app/shared/dio_client/dio_client.dart';
import 'package:altme/app/shared/enum/enum.dart';
import 'package:altme/app/shared/wallet_provider/wallet_configuration_source.dart';
import 'package:altme/dashboard/profile/cubit/profile_cubit.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/dashboard/profile/profile_provider/get_profile_from_provider.dart';

/// The enterprise wallet provider's configuration scheme.
///
/// The wallet authenticates with the account's email and password plus the
/// wallet attestation it just obtained, and the provider answers with a signed
/// configuration whose payload is the `ProfileSetting` shape.
///
/// This is today's `getProfileFromProvider` path, moved here unchanged and
/// behind an interface.
///
/// The account credentials are supplied at construction because they identify
/// one enterprise account: a source built for one account must never fetch
/// another's configuration. Applying a configuration needs none of them —
/// by then the document is already in hand — which is what
/// [EnterpriseWalletConfigurationSource.applyOnly] is for. The wallet applies a
/// configuration in a later step than it fetches one, with a user's approval in
/// between, and by then the credentials are out of scope.
class EnterpriseWalletConfigurationSource implements WalletConfigurationSource {
  /// Creates a source for one enterprise account, able to fetch and apply.
  const EnterpriseWalletConfigurationSource({
    required this.profileCubit,
    required DioClient client,
    required String email,
    required String password,
    required String walletAttestationData,
    required String url,
  }) : _client = client,
       _email = email,
       _password = password,
       _walletAttestationData = walletAttestationData,
       _url = url;

  /// Creates a source that can only apply a configuration already in hand.
  ///
  /// [fetchConfigurationJson] throws on one of these: there is no account to
  /// fetch for.
  const EnterpriseWalletConfigurationSource.applyOnly({
    required this.profileCubit,
  }) : _client = null,
       _email = null,
       _password = null,
       _walletAttestationData = null,
       _url = null;

  /// Where the applied configuration is persisted and put into force.
  final ProfileCubit profileCubit;

  final DioClient? _client;
  final String? _email;
  final String? _password;
  final String? _walletAttestationData;
  final String? _url;

  @override
  Future<String> fetchConfigurationJson() {
    final client = _client;
    final email = _email;
    final password = _password;
    final walletAttestationData = _walletAttestationData;
    final url = _url;

    if (client == null ||
        email == null ||
        password == null ||
        walletAttestationData == null ||
        url == null) {
      throw StateError(
        'This source was built to apply a configuration, not to fetch one. '
        'Build it with the enterprise account credentials to fetch.',
      );
    }

    return getProfileFromProvider(
      email: email,
      password: password,
      jwtVc: walletAttestationData,
      url: url,
      client: client,
    );
  }

  @override
  Future<void> applyConfiguration(String json) async {
    await profileCubit.secureStorageProvider.set(
      SecureStorageKeys.enterpriseProfileSetting,
      json,
    );

    final profileSetting = ProfileSetting.fromJson(
      jsonDecode(json) as Map<String, dynamic>,
    );

    ///save to profileCubit
    await profileCubit.setProfileSetting(
      profileSetting: profileSetting,
      profileType: ProfileType.enterprise,
      walletType: WalletType.enterprise,
    );
  }
}
