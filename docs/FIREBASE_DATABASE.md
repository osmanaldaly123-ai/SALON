# Firebase Realtime Database — Salon App

Connect the app to **Firebase Realtime Database** for guest-mode browsing (salons, services, deals) before the REST API is ready.

Project: **system-42ab7**

## 1. Enable Firebase services

### Realtime Database
1. Open [Firebase Console](https://console.firebase.google.com/) → **system-42ab7**
2. **Build** → **Realtime Database** → **Create Database**
3. Import `docs/firebase/seed_data.json`
4. Deploy rules from `database.rules.json` (see section 3)

### Authentication (required for login & booking)
1. **Build** → **Authentication** → **Get started**
2. **Sign-in method** → **Email/Password** → **Enable** → Save

Default database URL:

```
https://system-42ab7-default-rtdb.firebaseio.com
```

Copy that URL — you will send it to the developer or pass it at run time.

---

## 2. Import sample data

1. Firebase Console → Realtime Database → **⋮** menu → **Import JSON**
2. Select file: `docs/firebase/seed_data.json`
3. Confirm import

Expected structure:

```
/salons/{id}
/services/{id}
/deals/{id}
/meta
```

---

## 3. Deploy security rules (recommended)

From project root (with Firebase CLI):

```bash
firebase deploy --only database
```

Or paste contents of `database.rules.json` into Firebase Console → **Rules** tab.

**Test rules** allow public read (guest browsing). Production should restrict writes to authenticated users/backend.

---

## 4. Run the app with your database URL

```powershell
flutter run --dart-define=FIREBASE_DATABASE_URL=https://YOUR-PROJECT-default-rtdb.firebaseio.com
```

Replace `YOUR-PROJECT` with your actual RTDB host from Firebase Console.

**Guest mode:** choose **الدخول كزائر** — the app reads salons/services/deals from Firebase instead of hard-coded demo data.

---

## 5. VS Code launch profile

Use configuration **Salon (Firebase Database)** in `.vscode/launch.json` after pasting your URL there.

---

## 6. How it works in code

| Layer | File |
|-------|------|
| URL config | `lib/core/config/env.dart` → `FIREBASE_DATABASE_URL` |
| DB client | `lib/core/firebase/realtime_database_client.dart` |
| Salons | `lib/features/salons/data/datasources/salons_firebase_datasource.dart` |
| Services | `lib/features/services/data/datasources/services_firebase_datasource.dart` |
| Deals | `lib/features/deals/data/datasources/deals_firebase_datasource.dart` |

**Priority when guest:**
1. Firebase (if URL set)
2. Demo data (fallback)
3. REST API (when logged in)

---

## 7. Codemagic (optional)

Add environment variable:

```
FIREBASE_DATABASE_URL=https://salonbookingapp-dd24d-default-rtdb.firebaseio.com
```

And pass in build args:

```yaml
--dart-define=FIREBASE_DATABASE_URL=$FIREBASE_DATABASE_URL
```

---

## 8. Troubleshooting

| Problem | Fix |
|---------|-----|
| Empty salons list | Import `seed_data.json`; check Rules allow `.read` |
| Permission denied | Update Rules in Firebase Console |
| Still shows demo data | Confirm `--dart-define=FIREBASE_DATABASE_URL=...` and use **guest mode** |
| Web blank screen | Use Android/iOS for first test; web RTDB needs Firebase web init |

---

## Next step

Send the **Realtime Database URL** from Firebase Console. It will be wired into launch config and tested immediately.
