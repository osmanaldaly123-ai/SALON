# Salon Customer App

Flutter mobile app for browsing salons, booking services, reviews, and profile management.

**Package:** `com.salonbooking.app`  
**Version:** 1.0.0  
**Platforms:** Android (ready), iOS (prepared — needs Mac + Firebase plist)

---

## Features

| Feature | Status |
|---------|--------|
| Auth (login, register, forgot password) | ✅ Ready — needs API |
| Guest mode (browse demo data) | ✅ Works without API |
| Home, salons, services, deals | ✅ |
| Booking flow | ✅ — needs API |
| Reviews | ✅ — needs API |
| Profile & booking history | ✅ — needs API |
| Push notifications (FCM) | ✅ Android — needs API for token sync |
| AR / EN + RTL | ✅ |
| Token refresh on 401 | ✅ |

---

## Quick start

### Requirements

- Flutter SDK 3.12+ ([install](https://docs.flutter.dev/get-started/install))
- Android Studio (Android builds)
- Mac + Xcode (iOS builds only)

### Run (guest mode — no API needed)

```bash
flutter pub get
flutter run
```

On the login screen, tap **Continue as guest** to browse demo salons.

### Run with API (when backend is ready)

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com/v1
```

Release build:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://your-api.com/v1
```

---

## Project structure

```
lib/
├── core/           # Config, network, DI, router, widgets
├── features/       # auth, home, salons, booking, reviews, profile, ...
├── l10n/           # Arabic + English
└── main.dart
docs/
├── API_INTEGRATION.md      # Backend contract for the client
├── CLIENT_HANDOFF.md       # What the client must provide
├── ANDROID_RELEASE_SIGNING.md
├── IOS_SETUP.md
└── PROJECT_STATUS.md
```

---

## Configuration

| Variable | How to set | Default |
|----------|------------|---------|
| `API_BASE_URL` | `--dart-define=API_BASE_URL=...` | `https://api.example.com/v1` |

When the default URL is used, login/register show an info banner. Use **guest mode** for UI testing.

---

## Android release

See [docs/ANDROID_RELEASE_SIGNING.md](docs/ANDROID_RELEASE_SIGNING.md).

Copy `android/key.properties.example` → `android/key.properties` and create your keystore.

---

## iOS

See [docs/IOS_SETUP.md](docs/IOS_SETUP.md).

Copy `ios/Runner/GoogleService-Info.plist.example` instructions and add the real plist from Firebase.

---

## Firebase

- Project: `salonbookingapp-dd24d`
- Android: configured (`google-services.json`)
- iOS: pending `GoogleService-Info.plist` + `iosConfigured = true` in `lib/firebase_options.dart`

---

## Documentation for the client

| Document | Purpose |
|----------|---------|
| [API_INTEGRATION.md](docs/API_INTEGRATION.md) | All REST endpoints the app expects |
| [CLIENT_HANDOFF.md](docs/CLIENT_HANDOFF.md) | Checklist of client deliverables |
| [PROJECT_STATUS.md](docs/PROJECT_STATUS.md) | What is done vs pending |

---

## Tech stack

- **Flutter** + **shadcn_ui**
- **flutter_bloc** — state
- **go_router** — navigation
- **dio** — HTTP
- **get_it** — DI
- **firebase_messaging** — push
- **flutter_secure_storage** — tokens

---

## License

Proprietary — source delivered to client for Salon Booking App project.
