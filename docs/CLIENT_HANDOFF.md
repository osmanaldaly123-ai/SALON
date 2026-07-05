# Client Handoff Checklist

Items the **client** must provide to go live. Everything else is implemented in the mobile app.

---

## Required for launch

### 1. REST API

- [ ] Production base URL (e.g. `https://api.yourdomain.com/v1`)
- [ ] All endpoints in [API_INTEGRATION.md](API_INTEGRATION.md) implemented
- [ ] HTTPS with valid certificate
- [ ] Test accounts (email + password) for QA

**How to connect:**

```bash
flutter run --dart-define=API_BASE_URL=https://api.yourdomain.com/v1
flutter build apk --release --dart-define=API_BASE_URL=https://api.yourdomain.com/v1
```

---

### 2. Firebase (push notifications)

Already configured for **Android** in project `salonbookingapp-dd24d`.

**Client action for iOS:**

- [ ] Add iOS app in Firebase Console (bundle: `com.salonbooking.app`)
- [ ] Download `GoogleService-Info.plist` → place in `ios/Runner/`
- [ ] Upload APNs key (.p8) to Firebase Cloud Messaging
- [ ] Set `iosConfigured = true` in `lib/firebase_options.dart` (or run `flutterfire configure` on Mac)

See [IOS_SETUP.md](IOS_SETUP.md).

---

### 3. Google Play (Android)

- [ ] **Production keystore** (not the test keystore in docs)
- [ ] Google Play Developer account
- [ ] Store listing: title, description, screenshots
- [ ] Privacy Policy URL (required by Play Store)

See [ANDROID_RELEASE_SIGNING.md](ANDROID_RELEASE_SIGNING.md).

---

### 4. App Store (iOS) — if needed

- [ ] Apple Developer account
- [ ] Mac + Xcode for build & upload
- [ ] App Store Connect listing
- [ ] Privacy Policy URL

---

## Optional (Phase 8 polish)

- [ ] **Figma** design files — for pixel-perfect UI update
- [ ] Brand assets: final app icon, splash screen
- [ ] Analytics requirements (Firebase Analytics is included but not wired to custom events)

---

## Already done (developer delivery)

| Item | Status |
|------|--------|
| Flutter app (Android + iOS project) | ✅ |
| Auth, browse, booking, reviews, profile UI | ✅ |
| Guest / demo mode | ✅ |
| Arabic + English | ✅ |
| FCM Android code | ✅ |
| Token refresh | ✅ |
| Release signing setup (Android test keystore) | ✅ |
| Documentation | ✅ |

---

## Support contacts

After API is live, verify with the **Testing checklist** at the end of [API_INTEGRATION.md](API_INTEGRATION.md).

If the backend uses different field names, share the OpenAPI/Swagger spec — the app supports common `snake_case` and `camelCase` variants.
