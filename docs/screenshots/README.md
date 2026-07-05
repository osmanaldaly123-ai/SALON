# App Screenshots for Client

Preview images for **Android** and **iPhone** (Salon Customer App).

## Location

| Platform | Folder |
|----------|--------|
| Android | `docs/screenshots/android/` |
| iPhone | `docs/screenshots/ios/` |

| File | Screen |
|------|--------|
| `01-login.png` | Login + guest option |
| `02-home.png` | Home (guest mode) |
| `03-salons.png` / `03-profile-guest.png` | Salons list / Guest profile |

## Important note

These are **UI preview mockups** based on the actual app design (violet `#6B4EFF`, Arabic RTL, shadcn UI).

For **pixel-perfect store screenshots**, capture from a real device after:

```bash
flutter run
# Login → Continue as guest → navigate screens → device screenshot
```

### Android (real device)

1. Connect phone or start Android emulator (Android Studio → AVD)
2. `flutter run`
3. Power + Volume Down (or emulator camera icon)

### iPhone (real device)

1. Mac + Xcode required
2. `flutter run` on iPhone
3. Side button + Volume Up

## Re-capture script (when emulator is available)

```bash
# Terminal 1
flutter run -d chrome --web-port=8080
# OR: flutter run -d <android-device-id>

# Terminal 2 (web build alternative)
flutter build web
cd build/web && npx serve -p 8080

cd docs/screenshots
npm install
node capture.mjs
```

---

Send the PNG files in `android/` and `ios/` folders to the client.
