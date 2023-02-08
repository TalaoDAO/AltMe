import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'credential_model.g.dart';

@JsonSerializable(explicitToJson: true)
// ignore: must_be_immutable
class CredentialModel extends Equatable {
  CredentialModel({
    required this.id,
    required this.image,
    required this.credentialPreview,
    required this.shareLink,
    required this.display,
    required this.data,
    this.expirationDate,
    this.credentialManifest,
    this.receivedId,
    this.challenge,
    this.domain,
    this.activities = const [],
    this.jwt,
  });

  factory CredentialModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> newJson = Map<String, dynamic>.from(json);
    if (newJson['data'] != null) {
      newJson.putIfAbsent('credentialPreview', () => newJson['data']);
    }
    if (newJson['credentialPreview'] != null) {
      newJson.putIfAbsent('data', () => newJson['credentialPreview']);
    }

    if (newJson['type'] == 'object') {
      newJson.putIfAbsent('data', () => newJson['credentialPreview']);
    }

    return _$CredentialModelFromJson(newJson);
  }

  factory CredentialModel.copyWithData({
    required CredentialModel oldCredentialModel,
    required Map<String, dynamic> newData,
    required List<Activity> activities,
  }) {
    return CredentialModel(
      id: oldCredentialModel.id,
      image: oldCredentialModel.image,
      data: newData,
      shareLink: oldCredentialModel.shareLink,
      display: oldCredentialModel.display,
      credentialPreview: Credential.fromJson(newData),
      expirationDate: oldCredentialModel.expirationDate,
      credentialManifest: oldCredentialModel.credentialManifest,
      receivedId: oldCredentialModel.receivedId,
      challenge: oldCredentialModel.challenge,
      domain: oldCredentialModel.domain,
      activities: activities,
      jwt: oldCredentialModel.jwt,
    );
  }

  @JsonKey(fromJson: fromJsonId)
  final String id;
  @JsonKey(readValue: readValueReceivedId)
  late String? receivedId;
  final String? image;
  final Map<String, dynamic> data;
  @JsonKey(defaultValue: '')
  final String shareLink;
  final Credential credentialPreview;
  @JsonKey(fromJson: fromJsonDisplay)
  final Display display;
  final String? expirationDate;
  @JsonKey(name: 'credential_manifest', fromJson: credentialManifestFromJson)
  final CredentialManifest? credentialManifest;
  final String? challenge;
  final String? domain;
  final List<Activity> activities;
  final String? jwt;

  Map<String, dynamic> toJson() => _$CredentialModelToJson(this);

  String get issuer => data['issuer'] as String;

  static String fromJsonId(dynamic json) {
    if (json == null || json == '') {
      return const Uuid().v4();
    } else {
      return json.toString();
    }
  }

  static Display fromJsonDisplay(dynamic json) {
    if (json == null || json == '') {
      return const Display(
        '',
        '',
        '',
        '',
      );
    }
    return Display.fromJson(json as Map<String, dynamic>);
  }

  Future<CredentialStatus> checkRevocationStatus() async {
    final status = await getRevocationStatus();
    switch (status) {
      case RevocationStatus.active:
        return CredentialStatus.active;
      case RevocationStatus.revoked:
        return CredentialStatus.suspended;
    }
  }

  Future<RevocationStatus> getRevocationStatus() async {
    final String vcStr = jsonEncode(data);
    final String optStr = jsonEncode({
      'checks': ['credentialStatus']
    });

    final String? result = await Future.any([
      DIDKitProvider().verifyCredential(vcStr, optStr),
      Future.delayed(const Duration(seconds: 4))
    ]);
    if (result == null) return RevocationStatus.active;
    final jsonResult = jsonDecode(result) as Map<String, dynamic>;
    if (jsonResult['errors']?[0] == 'Credential is revoked.') {
      return RevocationStatus.revoked;
    } else {
      return RevocationStatus.active;
    }
  }

  static CredentialManifest? credentialManifestFromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return null;
    }
    if (json['credential_manifest'] != null) {
      return CredentialManifest.fromJson(
        json['credential_manifest'] as Map<String, dynamic>,
      );
    }
    return CredentialManifest.fromJson(json);
  }

  static String? readValueReceivedId(Map<dynamic, dynamic> map, String value) {
    if (map['receivedId'] != null) {
      return map['receivedId'] as String;
    }
    return map['id'] as String?;
  }

  @override
  List<Object?> get props => [
        id,
        image,
        data,
        shareLink,
        credentialPreview,
        display,
        expirationDate,
        credentialManifest,
        activities,
      ];
}
