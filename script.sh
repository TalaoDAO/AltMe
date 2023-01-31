if [[ "$*" == *-build_runner* ]]; 
then
  echo "build runner"
  fvm flutter clean
  cd packages
  cd credential_manifest
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  cd ..
  cd cryptocurrency_keys
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  cd ..
  cd ..
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  fvm flutter pub get 

elif [[ "$*" == *-rundev* ]]; 
then
  echo "flutter run development"
  fvm flutter run --flavor development --target lib/main_development.dart

elif [[ "$*" == *-runstage* ]]; 
then
  echo "flutter run staging"
  fvm flutter run --flavor staging --target lib/main_staging.dart

elif [[ "$*" == *-run* ]]; 
then
  echo "flutter run production"
  fvm flutter run --flavor production --target lib/main_production.dart

elif [[ "$*" == *-pod$sinstall* ]]; 
then 
  echo "pod install"
  cd ios
  pod install
  cd ..

elif [[ "$*" == *-build$sappbundle* ]]; 
then 
  echo "app bundle"
  fvm flutter build appbundle --flavor "production" --target "lib/main_production.dart"

elif [[ "$*" == *-deploy$sios* ]]; 
then 
  echo "deploy ios"
  echo "Make sure you are in right branch"
  fvm flutter build ios --release --flavor "production" --target "lib/main_production.dart"
  cd ios 
  fastlane beta
  cd ..

elif [[ "$*" == *-pub* ]];
then
  fvm flutter pub get
  cd packages/credential_manifest
  flutter pub get
  cd  ..
  cd cryptocurrency_keys
  flutter pub get
  cd ..
  cd did_kit
  flutter pub get
  cd ..
  cd ebsi  
  flutter pub get
  cd ..
  cd jwt_decode
  flutter pub get 
  cd ..
  cd key_generator
  flutter pub get
  cd ..
  cd secure_storage
  flutter pub get
  cd ..
  cd tezos_key
  flutter pub get
else
  echo "build runner"
  fvm flutter clean
  cd packages
  cd credential_manifest
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  cd ..
  cd cryptocurrency_keys
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  cd ..
  cd ..
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  fvm flutter pub get 
fi