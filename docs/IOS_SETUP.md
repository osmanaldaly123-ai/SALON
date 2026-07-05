# iOS Setup — Salon App

This guide covers iOS configuration for **com.salonbooking.app**.

---

## Current status

| Item | Status |
|------|--------|
| Bundle ID `com.salonbooking.app` | Done |
| Display name **Salon** | Done |
| Push entitlements (development) | Done |
| Info.plist permissions | Done |
| Firebase iOS options | **Done** — `GoogleService-Info.plist` added |
| APNs key in Firebase | **Pending** — client / Apple Developer |
| Mac build & TestFlight | **Pending** — requires Mac + Xcode |

The app **launches on iOS without Firebase** until you complete Step 3 below. Browse, guest mode, and UI work; push notifications do not.

---

## 1. Prerequisites

- **Mac** with Xcode 15+ (iOS builds cannot run on Windows)
- Apple Developer account ($99/year)
- Firebase project: `salonbookingapp-dd24d` (same as Android)

---

## 2. Register the iOS app in Firebase

1. Open [Firebase Console](https://console.firebase.google.com/) → project **salonbookingapp-dd24d**
2. **Project settings** → **Your apps** → **Add app** → **iOS**
3. Bundle ID: `com.salonbooking.app`
4. Download **GoogleService-Info.plist**
5. Copy it to:

```
ios/Runner/GoogleService-Info.plist
```

6. In Xcode (optional check): Runner target → **Build Phases** → **Copy Bundle Resources** should include the plist.

---

## 3. Enable Firebase in Dart

1. Open `GoogleService-Info.plist` and copy:
   - `API_KEY` → `apiKey`
   - `GOOGLE_APP_ID` → `appId`
   - `GCM_SENDER_ID` → already `920429460532`

2. Edit `lib/firebase_options.dart`:

```dart
static const bool iosConfigured = true; // was false

static const FirebaseOptions ios = FirebaseOptions(
  apiKey: 'YOUR_API_KEY_FROM_PLIST',
  appId: 'YOUR_GOOGLE_APP_ID_FROM_PLIST',
  messagingSenderId: '920429460532',
  projectId: 'salonbookingapp-dd24d',
  storageBucket: 'salonbookingapp-dd24d.firebasestorage.app',
  iosBundleId: 'com.salonbooking.app',
);
```

Or run on Mac (recommended):

```bash
dart pub global activate flutterfire_cli
firebase login
flutterfire configure --project=salonbookingapp-dd24d
```

Then set `iosConfigured = true` if the CLI does not add that flag.

---

## 4. APNs (push notifications)

1. [Apple Developer](https://developer.apple.com/account/) → **Certificates, Identifiers & Profiles**
2. **Keys** → create **Apple Push Notifications service (APNs)** key
3. Download `.p8` file (keep it safe)
4. Firebase Console → **Project settings** → **Cloud Messaging** → **Apple app configuration**
5. Upload APNs key (Key ID + Team ID + `.p8`)

For **Release / App Store**, change in `ios/Runner/Runner.entitlements`:

```xml
<key>aps-environment</key>
<string>production</string>
```

And enable **Push Notifications** capability in Xcode (Signing & Capabilities).

---

## 5. Build on Mac

```bash
cd my_ewesome_app
flutter pub get
flutter build ios --release
```

Open in Xcode for signing:

```bash
open ios/Runner.xcworkspace
```

- Select your **Team** under Signing & Capabilities
- Connect iPhone or use Simulator (push needs real device)
- **Product → Run**

---

## 6. TestFlight / App Store

1. Archive in Xcode: **Product → Archive**
2. **Distribute App** → App Store Connect
3. Create app in [App Store Connect](https://appstoreconnect.apple.com/) with bundle ID `com.salonbooking.app`

---

## 7. Notes

- This Flutter project uses **Swift Package Manager** for plugins (no `Podfile`). Do not add CocoaPods unless Flutter docs require it for your SDK version.
- Minimum iOS: **13.0** (set in Xcode project)
- Match Android package: `com.salonbooking.app`
- Windows: prepare files here; final build and signing happen on Mac

---

## Checklist

- [ ] `GoogleService-Info.plist` in `ios/Runner/`
- [ ] `iosConfigured = true` + real iOS values in `firebase_options.dart`
- [ ] APNs key uploaded to Firebase
- [ ] Push capability enabled in Xcode
- [ ] Test on physical iPhone
- [ ] TestFlight build submitted
