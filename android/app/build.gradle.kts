import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "co.altme.alt.me.altme"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    packagingOptions {
      jniLibs.pickFirsts += "lib/x86/libsodium.so"
      jniLibs.pickFirsts += "lib/x86_64/libsodium.so"
      jniLibs.pickFirsts += "lib/armeabi-v7a/libsodium.so"
      jniLibs.pickFirsts += "lib/arm64-v8a/libsodium.so"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "co.altme.alt.me.altme"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    
    signingConfigs {
            create("release") {
              keyAlias = keystoreProperties["keyAlias"] as String
              keyPassword = keystoreProperties["keyPassword"] as String
              storeFile = keystoreProperties["storeFile"]?.let { file(it) }
              storePassword = keystoreProperties["storePassword"] as String
            }
    }
    flavorDimensions += "default"
    productFlavors { 
        create("production") {
            dimension = "default"
            applicationIdSuffix = ""
            resValue(
              type = "string",
              name = "app_name",
              value = "Altme")
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".stg"
            resValue(
              type = "string",
              name = "app_name",
              value = "[STG] Altme")
        }        
        create("development") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            resValue(
              type = "string",
              name = "app_name",
              value = "[DEV] Altme")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            ndk {
                abiFilters "x86_64"
                }
        }
        debug {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
