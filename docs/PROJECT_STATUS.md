# Project Status — Salon Customer App

Last updated: delivery phase (API pending from client).

---

## Summary

| Area | Progress | Notes |
|------|----------|-------|
| **Mobile app code** | 100% | All planned features implemented |
| **Android** | 95% | Release build works; production keystore = client |
| **iOS** | 80% | Project configured; needs plist + Mac build |
| **Backend API** | 0% | **Client responsibility** |
| **Figma polish** | Optional | App uses shadcn_ui + violet theme |
| **Store publish** | 0% | Client accounts + listing |

---

## Completed phases

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Architecture, DI, routing, i18n | ✅ |
| 2 | Auth (login, register, forgot password, guest) | ✅ |
| 3 | Browse (home, salons, services, deals) | ✅ |
| 4 | Booking flow | ✅ |
| 5 | Reviews | ✅ |
| 6 | Profile & history | ✅ |
| 7 | FCM (Android) | ✅ |
| 8A | Settings, animations, token refresh, splash | ✅ |
| 8B | Figma pixel-perfect | ⏳ Optional — needs client Figma |

---

## Platform matrix

| Platform | Build | Browse (guest) | Auth/Booking | Push |
|----------|-------|------------------|--------------|------|
| Android | ✅ | ✅ | Needs API | ✅ code ready |
| iOS | Needs Mac | ✅ | Needs API | Needs APNs |
| Web/Chrome | Preview only | ✅ | N/A | N/A |

---

## Client must provide

1. **API base URL** + endpoints ([API_INTEGRATION.md](API_INTEGRATION.md))
2. **Test credentials**
3. **GoogleService-Info.plist** (iOS Firebase)
4. **Production keystore** (Android Play Store)
5. **Store listings** + privacy policy URLs

See [CLIENT_HANDOFF.md](CLIENT_HANDOFF.md).

---

## How to run today (without API)

```bash
flutter pub get
flutter run
```

Login → **Continue as guest** → full browse experience with demo data.

---

## How to run with API

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com/v1
```

---

## Key files

| File | Purpose |
|------|---------|
| `lib/core/config/env.dart` | API URL configuration |
| `lib/firebase_options.dart` | Firebase (Android on, iOS flag off) |
| `android/app/google-services.json` | Firebase Android |
| `docs/API_INTEGRATION.md` | Backend contract |
| `docs/IOS_SETUP.md` | iOS completion steps |
| `docs/ANDROID_RELEASE_SIGNING.md` | Play Store signing |
