if [[ "$*" == *-build_runner* ]]; 
then
  echo "build runner"
  fvm flutter clean
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs

elif [[ "$*" == *-run* ]]; 
then
  echo "flutter run"
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
  fvm flutter build ios --release 
  cd ios 
  fastlane beta
  cd ..

elif [[ "$*" == *-completeIos* ]]; 
then 
  echo "build runner"
  fvm flutter clean
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs
  echo "pod install"
  cd ios
  pod install
  cd ..
  echo "deploy ios"
  echo "Make sure you are in right branch"
  fvm flutter build ios --release
  cd ios 
  fastlane beta
  cd ..

else
  echo "build runner"
  fvm flutter clean
  fvm flutter pub get
  fvm flutter packages pub run build_runner build --delete-conflicting-outputs  
fi