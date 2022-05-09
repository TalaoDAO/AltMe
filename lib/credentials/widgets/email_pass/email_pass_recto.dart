import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

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
              image: AssetImage(
                'assets/image/email_pass_verso.png',
              ))),
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
                child: DisplayNameCard(item),
              ),
              LayoutId(
                id: 'description',
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 250 * MediaQuery.of(context).size.aspectRatio),
                  child: DisplayDescriptionCard(item),
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
