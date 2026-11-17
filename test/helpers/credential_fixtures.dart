import 'dart:convert';
import 'dart:io';

import 'package:altme/dashboard/dashboard.dart';

/// A credential of the credential details fixtures: `mdl_with_portrait` (a
/// mobile driving licence) or `pid_sd_jwt_with_portrait` (a PID).
CredentialModel loadCredentialFixture(String name) => CredentialModel.fromJson(
  jsonDecode(
        File(
          'test/dashboard/home/tab_bar/credentials/detail/view/fixtures/'
          '$name.json',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>,
);
