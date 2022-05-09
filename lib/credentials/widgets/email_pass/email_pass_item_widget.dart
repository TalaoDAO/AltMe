import 'package:altme/app/app.dart';
import 'package:altme/credentials/credential.dart';
import 'package:flutter/material.dart';

class EmailPassItemWidget extends StatelessWidget {
  const EmailPassItemWidget({Key? key, required this.credentialModel})
      : super(key: key);
  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fitWidth,
          image: AssetImage(
            'assets/image/email_pass_verso.png',
          ),
        ),
      ),
      child: AspectRatio(
        /// size from over18 recto picture
        //TODO remove hardcoded number
        aspectRatio: 584 / 317,
        child: SizedBox(
          height: 317,
          width: 584,
          child: CustomMultiChildLayout(
            delegate: EmailPassVersoDelegate(position: Offset.zero),
            children: [
              LayoutId(
                id: 'name',
                child: DisplayNameCard(credentialModel),
              ),
              LayoutId(
                id: 'description',
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 250 * MediaQuery.of(context).size.aspectRatio),
                  child: DisplayDescriptionCard(credentialModel),
                ),
              ),
              LayoutId(
                id: 'issuer',
                child: Row(
                  children: [
                    SizedBox(
                      height: 30,
                      child: ImageFromNetwork(
                        credentialModel
                            .credentialPreview.credentialSubject.issuedBy.logo,
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
