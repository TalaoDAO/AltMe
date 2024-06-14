import 'package:altme/app/app.dart';
import 'package:flutter/material.dart';
import 'package:test/test.dart';

void main() {
  group('CredentialStatusExtension', () {
    test('icon returns correct icon for each status', () {
      expect(CredentialStatus.active.icon, Icons.check_circle);
      expect(CredentialStatus.invalidStatus.icon, Icons.circle_outlined);
      expect(CredentialStatus.expired.icon, Icons.circle_outlined);
      expect(CredentialStatus.pending.icon, Icons.circle_outlined);
      expect(CredentialStatus.unknown.icon, Icons.circle_outlined);
      expect(CredentialStatus.invalidSignature.icon, Icons.circle_outlined);
      expect(
        CredentialStatus.statusListInvalidSignature.icon,
        Icons.circle_outlined,
      );
      expect(CredentialStatus.noStatus.icon, Icons.circle_outlined);
    });
  });
}
