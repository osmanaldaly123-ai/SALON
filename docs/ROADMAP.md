# Salon Customer App — Project Roadmap

> تطبيق عميل الصالون — خارطة طريق التطوير  
> Flutter (Android & iOS) | REST API | Arabic & English (RTL/LTR)

> **Delivery:** App code complete — client provides REST API. See [PROJECT_STATUS.md](PROJECT_STATUS.md).

---

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # MaterialApp & localization
├── core/                     # Shared infrastructure
│   ├── config/               # Environment & app config
│   ├── constants/            # API & app constants
│   ├── di/                   # Dependency injection (GetIt)
│   ├── error/                # Exceptions & failures
│   ├── network/              # Dio API client
│   ├── router/               # GoRouter navigation
│   ├── services/             # Locale & shared services
│   ├── theme/                # Colors, typography, theme
│   ├── utils/                # Validators & helpers
│   └── widgets/              # Reusable UI components
├── features/                 # Feature modules (Clean Architecture)
│   ├── auth/                 # Login & Register
│   ├── splash/               # Splash screen
│   ├── home/                 # Home dashboard
│   ├── salons/               # Browse salons
│   ├── services/             # Services listing
│   ├── deals/                # Deals & offers
│   ├── booking/              # Booking flow
│   ├── reviews/              # Ratings & reviews
│   ├── profile/              # Profile & booking history
│   └── notifications/        # FCM push notifications
└── l10n/                     # Arabic & English translations
```

Each feature follows:
```
feature/
├── data/          → datasources, models, repository impl
├── domain/        → entities, repository interfaces
└── presentation/  → pages, widgets, bloc/cubit
```

---

## Development Phases

### Phase 1 — Project Setup & Core Infrastructure ✅ (Current)
**Status:** Ready for review

| Task | Description |
|------|-------------|
| Folder structure | Clean Architecture feature modules |
| Dependencies | BLoC, Dio, GoRouter, GetIt, Firebase, etc. |
| Network layer | ApiClient + AuthInterceptor |
| Routing | All routes defined with GoRouter |
| Theme | Base colors & typography (Figma update in Phase 8) |
| Localization | AR/EN ARB files + RTL/LTR support |
| DI | GetIt service locator |

**Deliverable:** App runs, splash → login/home navigation works.

---

### Phase 2 — Authentication ✅
**Status:** Implemented (pending API + Figma alignment)

| Task | Description |
|------|-------------|
| Login UI | Form from Figma + validation |
| Register UI | Form from Figma + validation |
| Auth BLoC | State management for auth flows |
| Token storage | Secure storage + interceptor |
| Session check | Splash redirects based on auth state |
| Error handling | User-friendly error messages (AR/EN) |

**Deliverable:** User can register, login, logout; token persists.

**Required from client:** Auth API docs (endpoints, request/response format).

---

### Phase 3 — Browse Salons, Services & Deals ✅
**Status:** Implemented (pending API + Figma alignment)

| Task | Description |
|------|-------------|
| Home screen | Featured salons, deals, search (Figma) |
| Salons list | Grid/list with images, rating, distance |
| Salon detail | Info, services, deals, reviews preview |
| Services list | Filter by salon, price, duration |
| Deals list | Active offers with expiry |
| Pull to refresh | Reload data from API |
| Shimmer loading | Skeleton loaders |

**Deliverable:** Full browse experience before booking.

**Required from client:** Salons/Services/Deals API docs + Figma screens.

---

### Phase 4 — Booking Flow ✅
**Status:** Implemented (pending API + Figma alignment)

| Task | Description |
|------|-------------|
| Service selection | Pick service from salon |
| Date & time picker | Available slots from API |
| Booking summary | Confirm details before submit |
| Booking confirmation | Success screen |
| Cancel booking | If supported by API |

**Deliverable:** End-to-end booking without payment.

**Required from client:** Booking API docs (slots, create, cancel).

---

### Phase 5 — Ratings & Reviews ✅
**Status:** Implemented (pending API + Figma alignment)

| Task | Description |
|------|-------------|
| Reviews list | On salon detail page |
| Submit review | Star rating + comment |
| Review BLoC | Load & submit states |

**Deliverable:** Users can view and submit reviews.

---

### Phase 6 — Profile & Booking History ✅
**Status:** Implemented (pending API + Figma alignment)

| Task | Description |
|------|-------------|
| Profile screen | View & edit name, phone, avatar |
| Booking history | Past & upcoming appointments |
| Logout | Clear session & redirect to login |
| Language switch | AR ↔ EN toggle |

**Deliverable:** Complete user account management.

---

### Phase 7 — Push Notifications (FCM)
**Estimated:** 2–3 days

| Task | Description |
|------|-------------|
| Firebase setup | Android & iOS configuration |
| FCM token | Register token with backend API |
| Foreground handler | In-app notification display |
| Background handler | Tap to navigate |
| Permission request | iOS & Android 13+ |

**Deliverable:** Push notifications working on both platforms.

**Required from client:** Firebase project credentials + FCM API endpoint.

---

### Phase 8 — UI Polish & Final Delivery
**Estimated:** 4–5 days

| Task | Description |
|------|-------------|
| Figma implementation | Match all screens pixel-perfect |
| Design tokens | Colors, fonts, spacing from Figma |
| Animations | Transitions & micro-interactions |
| Edge cases | Empty states, errors, offline |
| Testing | Manual QA on Android & iOS |
| Source code delivery | Full repo + README setup guide |

**Deliverable:** Production-ready app + complete source code.

---

## Timeline Summary

| Phase | Duration | Cumulative |
|-------|----------|------------|
| Phase 1 — Setup | ✅ Done | — |
| Phase 2 — Auth | 3–4 days | ~4 days |
| Phase 3 — Browse | 5–6 days | ~10 days |
| Phase 4 — Booking | 4–5 days | ~15 days |
| Phase 5 — Reviews | 2–3 days | ~18 days |
| Phase 6 — Profile | 3–4 days | ~22 days |
| Phase 7 — FCM | 2–3 days | ~25 days |
| Phase 8 — Polish | 4–5 days | ~30 days |

**Total estimated delivery: ~6 weeks**

---

## What We Need From You (Before Each Phase)

1. **Figma design link** — UI/UX for the phase screens
2. **API documentation** — Base URL, endpoints, auth method, sample responses
3. **Test credentials** — For development & QA
4. **Firebase config** — `google-services.json` (Android) + `GoogleService-Info.plist` (iOS) for Phase 7

---

## Tech Stack

| Layer | Package |
|-------|---------|
| State Management | flutter_bloc |
| Navigation | go_router |
| HTTP | dio |
| DI | get_it |
| Storage | shared_preferences + flutter_secure_storage |
| Images | cached_network_image |
| Push | firebase_messaging |
| i18n | flutter_localizations + ARB |

---

## Next Step

**Client:** Implement REST API per [API_INTEGRATION.md](API_INTEGRATION.md) and provide base URL.

**Optional:** Figma files for Phase 8B pixel polish.

**Developer (when API arrives):**

```bash
flutter run --dart-define=API_BASE_URL=https://your-api.com/v1
```
