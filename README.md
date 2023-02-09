# Talao

![coverage][coverage_badge]
[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

`ALTME` – THE UNIVERSAL WALLET THAT WORKS FOR YOU 
The Web 3 revolution is all about redistributing the power to the average consumer. 
This is why we are building Altme, to help you get control over your data back.

---

## Getting Started 🚀

This project contains 3 flavors:
- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```bash
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*Talao works on iOS and Android._

---

## Common Dependencies

To manually build Altme for either Android or iOS, you will need to install
the following dependencies:

- Rust
- Java 7 or higher
- Flutter (`dev` channel)
- [DIDKit](https://github.com/spruceid/didkit)/[SSI](https://github.com/spruceid/ssi)

### Rust

It is recommended to use [rustup](https://www.rust-lang.org/tools/install) to
manage your Rust installation.

### Java

On Ubuntu you could run:

```bash
$ apt update
$ apt install openjdk-8-jdk
```

For more information, please refer to the documentation of your favorite flavour
of Java and your operating system/package manager.

### Flutter

Please follow the official instalation instructions available
[here](https://flutter.dev/docs/get-started/install) to install Flutter,
don't forget to also install the build dependencies for the platform you
will be building (Android SDK/NDK, Xcode, etc).

We currently only support build this project using the `dev` channel of Flutter.

To change your installation to the `dev` channel, please execute the following command:

```bash
$ flutter channel dev
$ flutter upgrade
```

To confirm that everything is setup correctly, please run the following command
and resolve any issues that arise before proceeding to the next steps.

```bash
$ flutter doctor
```

### DIDKit and SSI

This project also depends on two other [`Spruce`](https://github.com/spruceid) projects,
[`DIDKit`](https://github.com/spruceid/didkit) and
[`SSI`](https://github.com/spruceid/ssi). 

These projects are all configured to work with relative paths by default,
so it is recommended to clone them all under the same root directory, for 
example `$HOME/$FOLDER_NAME/{didkit,ssi,altme}`.

## Target-Specific Dependencies

### Android Dependencies

To build Altme for Android, you will require both the Android SDK and NDK.

These two dependencies can be easily obtained with [Android
Studio](https://developer.android.com/studio/install), which install further
dependencies upon first being opened after installation. Installing the
appropriate Android NDK (often not the newest) in Android Studio can be
accomplished by going to Settings > Appearance & Behavior > System Settings >
Android SDK and selecting to install the "NDK (Side by Side)". 

An alternative method of installing SDK and NDK without Android Studio can be 
found in the script below:
```
cd $HOME
wget https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip
unzip sdk-tools-linux-4333796.zip -d Android
rm sdk-tools-linux-4333796.zip
wget https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
unzip commandlinetools-linux-6200805_latest.zip -d Android/cmdline-tools
rm commandlinetools-linux-6200805_latest.zip
echo 'export ANDROID_SDK_ROOT=$HOME/Android' >> $HOME/.bashrc
echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> $HOME/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/bin:"$PATH"' >> $HOME/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/cmdline-tools/tools/lib:"$PATH"' >> $HOME/.bashrc
echo 'export PATH=$ANDROID_SDK_ROOT/tools:"$PATH"' >> $HOME/.bashrc
echo 'export PATH=$JAVA_HOME/bin:"$PATH"' >> $HOME/.bashrc
. $HOME/.bashrc
sdkmanager --sdk_root=$ANDROID_SDK_ROOT --install "system-images;android-29;google_apis;x86" "system-images;android-29;google_apis;x86_64" "platform-tools" "platforms;android-29" "build-tools;29.0.3" "ndk;22.0.7026061" "cmdline-tools;latest"
sdkmanager --licenses
```

If your Android SDK doesn't live at `$HOME/Android/Sdk` you will need to set
`ANDROID_SDK_ROOT` like so:

```bash
$ export ANDROID_SDK_ROOT=/path/to/Android/Sdk
```

Note: Some users have experienced difficulties with cross-compilation
artefacts missing from the newest NDK, which is downloaded by default in the
installation process.  If you experience errors of this kind, you may have to
manually downgrade or install multiple NDK versions as [shown
here])(img/ndk_downgrade.png) in the Android Studio installer (screengrabbed
from an Ubuntu installation).

If your `build-tools` and/or `NDK`  live in different locations than the default ones inside /SDK/, or if you want to specify a specific NDK or build-tools version, you can manually configure the following two environment variables:

```bash
$ export ANDROID_TOOLS=/path/to/SDK/build-tools/XX.X.X/
$ export ANDROID_NDK_HOME=/path/to/SDK/ndk/XX.X.XXXXX/
```
::: 

### iOS Dependencies

To build Altme for iOS you will need to install CocoaPods, which can be done
with Homebrew on MacOS.

```bash
$ brew install cocoapods
```

## Building DIDKit for different targets

### Android

To build `DIDKit` for the Android targets, you will go to the root of `DIDKit`
and run:

```bash
$ make -C lib install-rustup-android
$ make -C lib ../target/test/java.stamp
$ make -C lib ../target/test/android.stamp
$ make -C lib ../target/test/flutter.stamp
$ cargo build
```
*This may take some time as it compiles the entire project for multiple targets*

### Android APK
```bash
# Development
$ flutter build apk --release --split-per-abi --flavor development -t lib/main_development.dart

# Staging
$ flutter build apk --release --split-per-abi --flavor staging -t lib/main_staging.dart

# Production
$ flutter build apk --release --split-per-abi --flavor production -t lib/main_production.dart
```

### Android App Bundle
```bash
# Development
$ flutter build appbundle --flavor "development" --target "lib/main_development.dart"

# Staging
$ flutter build appbundle --flavor "staging" --target "lib/main_staging.dart"

# Production
$ flutter build appbundle --flavor "production" --target "lib/main_production.dart"
```

### iOS

To build DIDKit for the iOS targets, you will go to the root of `DIDKit` and run: 

```bash
$ make -C lib install-rustup-ios
$ make -C lib ../target/test/ios.stamp
$ cargo build
```

## Shortcut setup
In order to handle installation of didkit, ssi and altme, we can run shortcut script. We can also get the warnings if we have not configured the required things for building Altme.

For consistent app builts we can use [`fvm`](https://fvm.app/docs/getting_started/installation).

You have to add the [`install_altme.sh`](https://github.com/TalaoDAO/mobile-install-deploy/blob/main/install_altme.sh) in the directory `$HOME/$FOLDER_NAME/`. Then run the following command to 
do the setup:

```bash 
# Android
$ ./install_altme.sh -android

# iOS
$ ./install_altme.sh -ios
```


## Generate missing .g.dart file
In order to generate all *.g.dart files, run the following command:
```bash
$ flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Key Dependencies
For smooth running of the functionalities of Altme, you need to add the following 
keys:


 
1. PASSBASE_WEBHOOK_AUTH_TOKEN<br />
You can get this key from [`here`](https://passbase.com/).

2. PASSBASE_CHECK_DID_AUTH_TOKEN<br />
The key is available [`here`](https://passbase.com/).

3. YOTI_AI_API_KEY<br />
This key can be obtained from [`here`](https://developers.yoti.com/).

4. TALAO_ISSUER_API_KEY<br />
The key is available [`here`](https://talao.io/).

5. INFURA_API_KEY<br />
This key can be obtained from [`here`](https://docs.infura.io/infura/networks/ethereum/how-to/secure-a-project/project-id).

6. MORALIS_API_KEY<br />
You can get this key from [`here`](https://docs.moralis.io/web3-data-api/get-your-api-key).
 

## Building Altme

You are now ready to build or run Altme.

### Run on emulator

If you want to run the project on your connected device, you can use:

```bash
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

### iOS .app for Simulator
```bash
# Development
$ flutter build ios --simulator --flavor "development" --target "lib/main_development.dart"

# Staging
$ flutter build ios --simulator --flavor "staging" --target "lib/main_staging.dart"

# Production
$ flutter build ios --simulator --flavor "production" --target "lib/main_production.dart"
```

### iOS .app for Devices
```bash
# Development
$ flutter build ios --no-codesign --flavor "development" --target "lib/main_development.dart"

# Staging
$ flutter build ios --no-codesign --flavor "staging" --target "lib/main_staging.dart"

# Production
$ flutter build ios --no-codesign --flavor "production" --target "lib/main_production.dart"
```

### iOS IPA 
```bash
# Development
$ flutter build ipa --flavor "development" --target "lib/main_development.dart"

# Staging
$ flutter build ipa --flavor "staging" --target "lib/main_staging.dart"

# Production
$ flutter build ipa --flavor "production" --target "lib/main_production.dart"
```

### iOS Continuous Delivery
If you have setup the [`fastlane`](https://docs.flutter.dev/deployment/cd) for continuous delivery, then you can run the following command to publish:

```bash
$ flutter pub get
$ flutter packages pub run build_runner build --delete-conflicting-outputs
$ flutter build ios --release --flavor "production" --target "lib/main_production.dart"
$ $cd ios 
$ fastlane beta
```

## Troubleshooting

If you encounter any errors in the build process described here, please first try
clean builds of the projects listed.

For instance, on Flutter, you can delete build files to start over by running:

```bash
$ flutter clean
```
Also, reviewing the
[`install_altme.sh`](https://github.com/TalaoDAO/mobile-install-deploy/blob/main/install_altme.sh) 
script may be helpful.

## Supported Protocols

All QRCode interactions start as listed below:

- User scans a QRCode containing a URL;
- User is presented the choice to trust the domain in the URL;
- App makes a GET request to the URL;

Then, depending on the type of message, one of the following protocols will be
executed.

### CredentialOffer

After receiving a `CredentialOffer` from a trusted host, the app calls the API
with `subject_id` in the form body, that value is the didKey obtained from the
private key stored in the `FlutterSecureStorage`, which is backed by KeyStore 
on Android and Keychain on iOS.

The flow of events and actions is listed below:

- User is presented a credential preview to review and make a decision;
- App generates `didKey` from the stored private key using `DIDKit.keyToDIDKey`;
- App makes a POST request to the initial URL with the subject set to the `didKey`;
- App receives and stores the new credential;
- User is redirect back to the wallet.

And below is another version of the step-by-step:

| Wallet                   | <sup>1</sup> |       |                      Server |
| ------------------------ | ------------ | :---: | --------------------------: |
| Scan QRCode <sup>2</sup> |              |       |
| Trust Host               | ○ / ×        |       |                             |
| HTTP GET                 |              |   →   | https://domain.tld/endpoint |
|                          |              |   ←   |             CredentialOffer |
| Preview Credential       |              |       |                             |
| Choose DID               | ○ / ×        |       |                             |
| HTTP POST <sup>3</sup>   |              |   →   | https://domain.tld/endpoint |
|                          |              |   ←   |        VerifiableCredential |
| Verify Credential        |              |       |                             |
| Store Credential         |              |       |                             |

*<sup>1</sup> Whether this action requires user confirmation, exiting the flow
early when the user denies.*  
*<sup>2</sup> The QRCode should contain the HTTP endpoint where the requests
will be made.*  
*<sup>3</sup> The body of the request contains a field `subject_id` set to the
chosen DID.*

### VerifiablePresentationRequest

After receiving a `VerifiablePresentationRequest` from a trusted host, the app
calls the API with `presentation` the form body, that value is a JSON encoded
string with the presentation obtained from the selected credential and signed
with the credential's private key using `DIDKit.issuePresentation`.

Here are some of the parameters used to generate a presentation:

- `presentation`
  - `id` is set to a random `UUID.v4` string;
  - `holder` is set to the selected credential's `didKey`;
  - `verifiableCredential` is set to the credential value;
- `options`
  - `verificationMethod` is set to the DID's `verificationMethod` `id`;
  - `proofPurpose` is set to `'authentication'`;
  - `challenge` is set to the request's `challenge';
  - `domain` is set to the request's `domain';
- `key` is the credential's stored private key;

The flow of events and actions is listed below:

- User is presented a presentation request to review and make a decision;
- App generates `didKey` from the stored private key using `DIDKit.keyToDIDKey`;
- App issues a presentation using `DIDKit.issuePresentation`;
- App makes a POST request to the initial URL with the presentation;
- User is redirect back to the wallet.

And below is another version of the step-by-step:

| Wallet                       | <sup>1</sup> |       |                        Server |
| ---------------------------- | ------------ | :---: | ----------------------------: |
| Scan QRCode <sup>2</sup>     |              |       |
| Trust Host                   | ○ / ×        |       |                               |
| HTTP GET                     |              |   →   |   https://domain.tld/endpoint |
|                              |              |   ←   | VerifiablePresentationRequest |
| Preview Presentation         |              |       |                               |
| Choose Verifiable Credential | ○ / ×        |       |                               |
| HTTP POST <sup>3</sup>       |              |   →   |   https://domain.tld/endpoint |
|                              |              |   ←   |                        Result |

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:altme/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```
## Run shortcut scripts
```bash
# generate .g.dart files
$ ./script.sh -build_runner

# build app for development
$ ./script.sh -rundev

# build app for stage
$ ./script.sh -runstage

# build app for production
$ ./script.sh -run

# add/update pod
$ ./script.sh -pod install

# build app bundle for ios
$ ./script.sh -build appbundle

# deploy ios app with fastlane setup
$ ./script.sh -deploy ios
```


```bash
#For permission
$ sudo chmod 777 script.sh
```


[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli