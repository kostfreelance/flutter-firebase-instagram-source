# Flutter Firebase Instagram

Flutter Firebase Instagram is a photo and video sharing social networking app based on Flutter and Firebase. This app has a simplified functionality and design similar to Instagram. You can run this app on both platforms: Android and iOS. Also you can easily customize and refine it for yourself, since it uses GetX.

![Preview image](/preview.jpg)

## Main features

* Photo & Video Infinite Scrolling Feed
* Realtime likes
* Realtime comments
* Sharing posts to other social networks
* Search for users
* Following & Unfollowing users
* One-to-one realtime chatting
* Email authentication
* GetX (state management and routing)

## Flutter packages

* firebase_core
* firebase_auth
* cloud_firestore
* firebase_storage
* get
* flutter_screenutil
* image_picker
* video_player
* timeago
* share_plus
* flutter_slidable
* visibility_detector
* keyboard_dismisser
* path

## Demo APK

https://www.dropbox.com/s/hxl4efgkvcpky0r/flutter-firebase-instagram.apk?dl=0
(email: mark.demo@gmail.com, password: demodemo)

## Project Setup

In order to setup the project you need to follow 2 steps: setup Firebase and setup your flutter project.

### Firebase setup

1. Go to https://console.firebase.google.com and create a project.
2. Go to "Authentication/Sign-in method" and enable "Email/Password".
3. Go to "Firestore Database" and create a Cloud Firestore database.
4. Go to "Firestore Database/Rules" and publish this code:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth.uid != null;
    }
  }
}
```
5. Go to "Storage/Rules" and publish this code:
```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```
6. Go to "Database/Indexes" and add 3 composite indexes:
```
1) Collection ID: chats. Fields to index: userIds Arrays lastActivityDate Descending. Query scopes: Collection.
2) Collection ID: posts. Fields to index: userId Ascending date Descending. Query scopes: Collection.
3) Collection ID: users. Fields to index: searchTerms Arrays date Descending. Query scopes: Collection.
```
7. Go to "Project Settings", add an Android app to your project. Follow the assistant, and download the generated google-services.json file and place it inside android/app.
8. Add an iOS app to your project. Follow the assistant, download the generated GoogleService-Info.plist file. Do NOT follow the steps named "Add Firebase SDK" and "Add initialization code" in the Firebase assistant. Open ios/Runner.xcworkspace with Xcode, and within Xcode place the GoogleService-Info.plist file inside ios/Runner.

### Flutter setup

1. Install package dependencies:
```
flutter pub get
```
2. Use one of these commands to build the project:
```
flutter build ipa
flutter build apk
flutter build appbundle
```