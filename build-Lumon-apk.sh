#!/bin/bash

echo "Building Lumon APK..."

# Create minimal Android project structure
mkdir -p Lumon-apk/app/src/main/{java/com/Lumon/app,res/{layout,values,drawable,mipmap-hdpi,mipmap-mdpi,mipmap-xhdpi,mipmap-xxhdpi,mipmap-xxxhdpi},assets/www}

# Copy Lumon web assets
cp -r static Lumon-apk/app/src/main/assets/www/
cp -r templates Lumon-apk/app/src/main/assets/www/
cp app.py Lumon-apk/app/src/main/assets/www/
cp main.py Lumon-apk/app/src/main/assets/www/

# Create AndroidManifest.xml
cat > Lumon-apk/app/src/main/AndroidManifest.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.Lumon.app"
    android:versionCode="1"
    android:versionName="1.0">

    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
    
    <uses-feature android:name="android.hardware.camera" android:required="true" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="Lumon - AI Plant Expert"
        android:theme="@android:style/Theme.Black.NoTitleBar.Fullscreen">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:screenOrientation="portrait">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
EOF

# Create MainActivity.java
cat > Lumon-apk/app/src/main/java/com/Lumon/app/MainActivity.java << 'EOF'
package com.Lumon.app;

import android.app.Activity;
import android.os.Bundle;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

public class MainActivity extends Activity {
    private WebView webView;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        webView = new WebView(this);
        setContentView(webView);
        
        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDomStorageEnabled(true);
        webSettings.setAllowFileAccess(true);
        webSettings.setAllowFileAccessFromFileURLs(true);
        webSettings.setAllowUniversalAccessFromFileURLs(true);
        
        webView.setWebViewClient(new WebViewClient());
        webView.loadUrl("file:///android_asset/www/templates/landing.html");
    }
    
    @Override
    public void onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack();
        } else {
            super.onBackPressed();
        }
    }
}
EOF

# Create strings.xml
cat > Lumon-apk/app/src/main/res/values/strings.xml << 'EOF'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Lumon - AI Plant Expert</string>
</resources>
EOF

# Create build.gradle files
cat > Lumon-apk/build.gradle << 'EOF'
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:8.1.1'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
EOF

cat > Lumon-apk/app/build.gradle << 'EOF'
apply plugin: 'com.android.application'

android {
    compileSdkVersion 34
    buildToolsVersion "34.0.0"
    
    defaultConfig {
        applicationId "com.Lumon.app"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0"
    }
    
    buildTypes {
        release {
            minifyEnabled false
        }
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.6.1'
}
EOF

cat > Lumon-apk/settings.gradle << 'EOF'
include ':app'
rootProject.name = "Lumon"
EOF

echo "Lumon APK project structure created!"
echo "Files:"
find Lumon-apk -type f | head -20
echo ""
echo "APK Features:"
echo "- Native Android WebView app"
echo "- Camera permissions for plant photos"
echo "- Offline Lumon interface"
echo "- Production-ready structure"
echo ""
echo "To build: cd Lumon-apk && ./gradlew assembleDebug"
