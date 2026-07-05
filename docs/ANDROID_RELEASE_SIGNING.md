# Android Release Signing — Salon App

## 1. Application ID

The app uses:

```
com.salonbooking.app
```

---

## 2. Create a keystore (one time)

Open a terminal in the `android/` folder and run:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

You will be asked for:

- Keystore password (remember it)
- Key password (can be the same)
- Your name / organization / country

**Keep `upload-keystore.jks` safe.** If you lose it, you cannot update the app on Google Play with the same listing.

---

## 3. Configure signing

1. Copy the example file:

   ```bash
   copy key.properties.example key.properties
   ```

   (On macOS/Linux: `cp key.properties.example key.properties`)

2. Edit `android/key.properties`:

   ```properties
   storePassword=YOUR_STORE_PASSWORD
   keyPassword=YOUR_KEY_PASSWORD
   keyAlias=upload
   storeFile=../upload-keystore.jks
   ```

3. Place `upload-keystore.jks` in the `android/` folder (same level as `key.properties`).

Both `key.properties` and `*.jks` are in `.gitignore` — do not commit them.

---

## 4. Build release APK / App Bundle

```bash
# App Bundle (recommended for Google Play)
flutter build appbundle --release

# Or APK
flutter build apk --release
```

Output:

- AAB: `build/app/outputs/bundle/release/app-release.aab`
- APK: `build/app/outputs/flutter-apk/app-release.apk`

If `key.properties` is missing, release builds fall back to the debug keystore (for local testing only).

---

## 5. Firebase (required after package name change)

Because the application ID changed to `com.salonbooking.app`:

1. Open [Firebase Console](https://console.firebase.google.com/) → project **salonbookingapp-dd24d**
2. Add Android app with package name **`com.salonbooking.app`**
3. Download the new **`google-services.json`**
4. Replace `android/app/google-services.json`
5. Run `flutterfire configure` or update `lib/firebase_options.dart` with the new `appId`

---

## 6. Google Play Console

When uploading the first release:

1. Create app in [Google Play Console](https://play.google.com/console)
2. Upload the `.aab` file
3. Complete store listing, privacy policy, and content rating
4. Use **Play App Signing** (Google manages the signing key on production)
