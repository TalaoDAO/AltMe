// ignore_for_file: overridden_fields

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/widget/image_from_network.dart';
import 'package:altme/credentials/credential.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'email_pass.g.dart';

@JsonSerializable(explicitToJson: true)
class EmailPass extends CredentialSubject {
  EmailPass(
    this.expires,
    this.email,
    this.id,
    this.type,
    this.issuedBy,
    this.passbaseMetadata,
  ) : super(id, type, issuedBy);

  factory EmailPass.fromJson(Map<String, dynamic> json) =>
      _$EmailPassFromJson(json);

  @JsonKey(defaultValue: '')
  final String expires;
  @JsonKey(defaultValue: '')
  final String email;
  @override
  final String id;
  @override
  final String type;
  @override
  final Author issuedBy;
  @JsonKey(defaultValue: '')
  final String passbaseMetadata;

  @override
  Map<String, dynamic> toJson() => _$EmailPassToJson(this);

  @override
  Widget displayInList(BuildContext context, CredentialModel item) {
    return EmailPassRecto(item);
  }

  @override
  Widget displayInSelectionList(BuildContext context, CredentialModel item) {
    return EmailPassRecto(item);
  }

  @override
  Widget displayDetail(BuildContext context, CredentialModel item) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 584 / 317,
          child: SizedBox(
            height: 317,
            width: 584,
            child: CardAnimation(
              recto: EmailPassRecto(item),
              verso: EmailPassVerso(item),
            ),
          ),
        ),
      ],
    );
  }
}

class EmailPassRecto extends Recto {
  const EmailPassRecto(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.emailPassFront),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: EmailPassVersoDelegate(position: Offset.zero),
            children: [
              LayoutId(
                id: 'name',
                child: DisplayNameCard(
                  item,
                  Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
              LayoutId(
                id: 'description',
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 250 * MediaQuery.of(context).size.aspectRatio,
                  ),
                  child: DisplayDescriptionCard(
                    item,
                    Theme.of(context).textTheme.credentialTextCard,
                  ),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        item.credentialPreview.credentialSubject.issuedBy.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPassVerso extends Verso {
  const EmailPassVerso(this.item, {Key? key}) : super(key: key);
  final CredentialModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final credentialSubject = item.credentialPreview.credentialSubject;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(ImageStrings.emailPassBack),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: EmailPassVersoDelegate(position: Offset.zero),
            children: [
              LayoutId(
                id: 'name',
                child: DisplayNameCard(
                  item,
                  Theme.of(context).textTheme.credentialTitleCard,
                ),
              ),
              LayoutId(
                id: 'description',
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 250 * MediaQuery.of(context).size.aspectRatio,
                  ),
                  child: DisplayDescriptionCard(
                    item,
                    Theme.of(context).textTheme.credentialTextCard,
                  ),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        item.credentialPreview.credentialSubject.issuedBy.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Row(
                      children: [
                        Text(
                          '${l10n.personalMail}: ',
                          style: Theme.of(context)
                              .textTheme
                              .credentialTextCard
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        if (credentialSubject is EmailPass)
                          Text(
                            credentialSubject.email,
                            style:
                                Theme.of(context).textTheme.credentialTextCard,
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmailPassVersoDelegate extends MultiChildLayoutDelegate {
  EmailPassVersoDelegate({this.position = Offset.zero});

  final Offset position;

  @override
  void performLayout(Size size) {
    if (hasChild('name')) {
      layoutChild('name', BoxConstraints.loose(size));
      positionChild('name', Offset(size.width * 0.06, size.height * 0.14));
    }
    if (hasChild('description')) {
      layoutChild('description', BoxConstraints.loose(size));
      positionChild(
        'description',
        Offset(size.width * 0.06, size.height * 0.33),
      );
    }

    if (hasChild('issuer')) {
      layoutChild('issuer', BoxConstraints.loose(size));
      positionChild('issuer', Offset(size.width * 0.06, size.height * 0.783));
    }
  }

  @override
  bool shouldRelayout(EmailPassVersoDelegate oldDelegate) {
    return oldDelegate.position != position;
  }
}
