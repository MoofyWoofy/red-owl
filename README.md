# Red Owl

> Yet another Wordle app. *Red Owl* is an anagram of *Wordle*.

A clean, offline-first Wordle clone built with Flutter. Bring your own word list, track your stats over time, and play in light or dark mode.

[![Get it on Google Play](https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png)](https://play.google.com/store/apps/details?id=dev.moofy.red_owl)

Privacy Policy: <https://moofywoofy.github.io/red-owl/>

---

## Table of Contents

- [Features](#features)
- [Screens](#screens)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Clone and Install](#clone-and-install)
  - [Generate Code](#generate-code)
  - [Run the App](#run-the-app)
- [Development Workflow](#development-workflow)
  - [Code Generation](#code-generation)
  - [Localization](#localization)
  - [Linting and Analysis](#linting-and-analysis)
- [Custom Word Lists](#custom-word-lists)
- [Building for Release](#building-for-release)
  - [Android](#android)
  - [iOS](#ios)
  - [Desktop and Web](#desktop-and-web)
- [Versioning](#versioning)
- [Changelog](#changelog)
- [Inspiration](#inspiration)
- [License](#license)

---

## Features

- **Daily word mode** — one deterministic puzzle a day, six guesses, the classic Wordle loop.
- **Practice / unlimited mode** — play endless rounds against random words; nothing is recorded against your stats.
- **Hard mode** — every revealed hint must be reused in later guesses; the toggle locks once you start the day's puzzle.
- **Once-a-day hint** — reveal a single correct letter when you're stuck.
- **Custom word lists** — import any `.txt` file (one word per line) and play against your own dictionary.
- **Stats tracking** — local Drift database records every game, surfacing games played/won, win rate, current/max streak, average guesses, guess distribution and a filterable history (all / last 30 days / custom range), with a reset option.
- **Sharing** — copy a spoiler-free NYT-style emoji result grid, plus celebratory streak-milestone prompts.
- **Daily reminder** — optional local notification at a time you choose (Android, off by default).
- **Theming & readability** — light/dark mode, a color-blind / high-contrast palette, adjustable text size, and an animation-speed control.
- **Accessibility** — screen-reader labels on tiles and keys, win/loss announcements, keyboard/focus operability, and respect for the system "reduce motion" setting.
- **Localized & RTL-ready UI** — English and Dutch out of the box (easy to add more via ARB files), with right-to-left layout support.
- **Offline first** — no network calls, no accounts, no telemetry (notifications are scheduled locally).
- **Cross-platform** — Android, iOS, Linux, macOS, Windows and web from a single codebase (the daily reminder is Android-only).

## Screens

- **Home** — entry point with Daily, Practice and Stats buttons.
- **Game** — the 5×6 guess grid with on-screen keyboard, pop-in/bounce/shake animations, snackbar feedback, plus hint, share-result and help actions.
- **Practice** — the same board with a "new word" action and no stat tracking.
- **Stats** — totals, streaks, average guesses, win-rate chart and a filterable per-game history.
- **Settings** — theme, color-blind mode, language, text size, animation speed, hard mode, daily reminder, custom word list import/preview, data backup/restore, and about info.

## Tech Stack

| Concern | Choice |
| --- | --- |
| Framework | Flutter (Dart SDK `^3.8.0`) |
| State management | `flutter_riverpod` 3.x with `riverpod_generator` 4.x |
| Immutable models | `freezed` 3.x + `json_serializable` |
| Local persistence | `drift` (SQLite) for stats, `shared_preferences` for settings |
| Charts | `fl_chart` 1.x |
| File picking | `file_picker` 11.x |
| Sharing / launching | `share_plus`, `url_launcher` |
| Notifications | `flutter_local_notifications` + `timezone` / `flutter_timezone` (Android) |
| Localization | `flutter_localizations` + ARB files |
| Linting | `flutter_lints`, `custom_lint`, `riverpod_lint` |
| Icons / splash | `flutter_launcher_icons`, `flutter_native_splash` |

## Project Structure

```
lib/
├── main.dart                  # Entry point, MaterialApp + ProviderScope
├── config/                    # Themes, animation timings, enums, shared keys
├── database/                  # Drift database schema and generated code
├── l10n/                      # ARB files and generated AppLocalizations
├── models/                    # Freezed models (Grid, Tile, GuessResult)
├── riverpod/                  # Notifiers and providers
│   ├── bool_family_notifier/  # Generic boolean settings family
│   ├── grid/                  # Daily game grid state
│   ├── practice_grid/         # Practice-mode grid (random word, no stats)
│   ├── hint/                  # Once-a-day hint availability
│   ├── locale/                # UI language override
│   ├── font_scale/            # Text-size preference
│   └── motion_speed/          # Animation-speed preference
├── routes/
│   ├── game/                  # WordlePage, PracticePage, board/tile/keyboard widgets
│   ├── settings/              # Settings page and sub-routes
│   └── stats/                 # Stats page, graph and history widgets
├── util/                      # SharedPreferenceService, WordleService,
│                              # NotificationService, share-grid + helpers
└── widgets/                   # Reusable widgets (AppBar, Logo, etc.)

assets/
├── icon.png                   # App icon used by flutter_launcher_icons
└── word_list.txt              # Default 5-letter word list

l10n.yaml                      # Flutter l10n configuration
```

## Getting Started

### Prerequisites

- **Flutter SDK** with Dart `^3.8.0` — install from <https://docs.flutter.dev/get-started/install>
- **Android Studio** or **Xcode** for the corresponding platform toolchains
- For Android release builds: **JDK 17+**, Android SDK with platform 35, NDK `28.2.13676358`

Verify your environment:

```bash
flutter doctor -v
```

### Clone and Install

```bash
git clone https://github.com/MoofyWoofy/red-owl.git
cd red-owl
flutter pub get
```

### Generate Code

This project uses code generation for Freezed models, JSON serialization, Drift, and Riverpod providers. Run the generator once after install and any time you change a generated source file:

```bash
dart run build_runner build --delete-conflicting-outputs
```

For continuous regeneration during development:

```bash
dart run build_runner watch --delete-conflicting-outputs
```

### Run the App

List available devices, then launch:

```bash
flutter devices
flutter run                    # default device
flutter run -d emulator-5554   # specific device
flutter run -d chrome          # web
```

Hot reload: press `r` in the terminal. Hot restart: `R`. Quit: `q`.

## Development Workflow

### Code Generation

| When you change... | Re-run build_runner |
| --- | --- |
| `lib/models/**/*.dart` (Freezed/JSON) | yes |
| `lib/riverpod/**/*.dart` (Riverpod providers) | yes |
| `lib/database/database.dart` (Drift schema) | yes |

Generated files (`*.g.dart`, `*.freezed.dart`) are committed so the project compiles without running the generator first, but always re-run after editing the source.

### Localization

Translations live in [lib/l10n/](lib/l10n/) as ARB files:

- [en.arb](lib/l10n/en.arb) — English (template)
- [nl.arb](lib/l10n/nl.arb) — Dutch

To add a new string:

1. Add the key and value to `en.arb` (with metadata under `@key` if it has placeholders).
2. Add a translation to every other ARB file.
3. Run `flutter gen-l10n` (or simply `flutter pub get` / `flutter run` — generation happens automatically because `generate: true` is set in `pubspec.yaml`).
4. Use it in code as `context.l10n.yourKey` (helper defined in [lib/util/localization.dart](lib/util/localization.dart)).

To add a new language, drop a `xx.arb` file alongside the existing ones and rebuild — `AppLocalizations.supportedLocales` is generated from the ARB set.

### Linting and Analysis

```bash
flutter analyze                              # standard analyzer
dart run custom_lint                         # riverpod_lint and other custom lints
dart format lib test                         # format
flutter test                                 # widget/unit tests
```

## Custom Word Lists

The default dictionary is bundled at [assets/word_list.txt](assets/word_list.txt). To use your own:

1. Open **Settings**.
2. Toggle **Use custom word list**.
3. Tap **Import** and pick a `.txt` file containing one 5-letter word per line.
4. Words are stored locally in shared preferences and used for the next game.

You can preview, replace or clear the imported list from the settings sub-routes.

## Building for Release

### Android

Set up signing by creating `android/key.properties`:

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=YOUR_KEY_ALIAS
storeFile=/absolute/path/to/your/keystore.jks
```

Then build:

```bash
flutter build apk --release            # APK (universal)
flutter build apk --split-per-abi      # split APKs per ABI
flutter build appbundle --release      # AAB for Play Store
```

Outputs land in `build/app/outputs/`.

The Android module pins:

- Kotlin `2.1.0`
- Android Gradle Plugin `8.9.1`
- Gradle wrapper `8.11.1`
- NDK `28.2.13676358`
- `targetSdk` `35`, ABI filters `armeabi-v7a`, `arm64-v8a`, `x86_64`

The daily reminder requires **core library desugaring** (enabled in `android/app/build.gradle`) for `flutter_local_notifications`, and the `POST_NOTIFICATIONS` / `RECEIVE_BOOT_COMPLETED` permissions are declared in the Android manifest.

### iOS

```bash
cd ios && pod install && cd ..
flutter build ipa --release
```

Open `build/ios/archive/Runner.xcarchive` in Xcode to upload via Organizer, or use `xcrun altool` / Transporter.

### Desktop and Web

```bash
flutter build linux --release
flutter build macos --release
flutter build windows --release
flutter build web --release
```

Generated artifacts are written to `build/<platform>/`.

## Versioning

The current version is declared in `pubspec.yaml` as `version: <name>+<code>`:

- `<name>` — semantic version shown to users.
- `<code>` — monotonically increasing build number used by stores.

Bump both before each release.

## Changelog

### 2.0.0

Stability and startup hardening (no feature changes):

- **Fixed a reveal-animation crash** — leaving the game during the tile flip could call `AnimationController.forward()` after the controller was disposed; the flip and win-bounce animations now guard their widget lifecycle.
- **No more lost input** — the tile reveal now finalizes from the current board state, so letters typed while a row is flipping are preserved.
- **Hardened async UI callbacks** — the centred snackbar and the history date-range filter no longer touch a widget that has been disposed.
- **Word-list robustness** — blank lines in a word list are ignored, and the list is parsed on a background isolate to keep the UI thread free.
- **Lighter startup** — the daily-reminder plugin now initialises after the first frame instead of blocking it.

## Inspiration

- [NYT Games](https://play.google.com/store/apps/details?id=com.nytimes.crossword)
- [Wordly](https://play.google.com/store/apps/details?id=com.appchirp.wordle)

## License

See [LICENSE](LICENSE).
