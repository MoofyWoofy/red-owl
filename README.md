# Red Owl

> Yet another Wordle app. *Red Owl* is an anagram of *Wordle*.

A clean, offline-first Wordle clone built with Flutter. Bring your own word list, track your stats over time, and play in light or dark mode.

[![Get it on Google Play](https://play.google.com/intl/en_us/badges/images/generic/en-play-badge.png)](https://play.google.com/store/apps/details?id=dev.moofy.red_owl)

Privacy Policy: <https://moofywoofy.github.io/red-owl/>

Having trouble — "Can't install Red Owl", a missing reminder, moving your stats to a new phone, or a build error? See the **[FAQ](FAQ.md)**.

> **AI-assisted development** — This codebase is developed and maintained with the help of AI coding assistants. Changes are human-reviewed before release. See [AGENTS.md](AGENTS.md) for the guidance those agents follow.

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
- [Releases](#releases)
- [Changelog](#changelog)
- [FAQ](FAQ.md)
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
- **Backup & restore** — export every setting, your stats and your full game history (and optionally your custom word list) to a single JSON file, and import it on another device. Restoring also re-applies your daily reminder on the new device (asking for the notification permission if it has not been granted there), so the toggle and the reminder you actually get agree.
- **Sharing** — copy a spoiler-free NYT-style emoji result grid, plus celebratory streak-milestone prompts.
- **Daily reminder** — optional local notification at a time you choose that repeats every day (Android, off by default).
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
| Immutable models | `freezed` 4.x + `json_serializable` |
| Local persistence | `drift` (SQLite) for stats, `shared_preferences` for settings |
| Charts | `fl_chart` 1.x |
| File picking | `file_picker` 12.x |
| Sharing / launching | `share_plus`, `url_launcher` |
| Notifications | `flutter_local_notifications` + `timezone` / `flutter_timezone` (Android) |
| Localization | `flutter_localizations` + ARB files |
| Linting | `flutter_lints` + `riverpod_lint` (via `dart analyze`) |
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
│   ├── reminder_time/         # Daily-reminder time preference
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
AGENTS.md                      # Architecture notes and conventions for AI coding agents
```

## Getting Started

### Prerequisites

- **Flutter SDK** with Dart `^3.8.0` — install from <https://docs.flutter.dev/get-started/install>
- **Android Studio** or **Xcode** for the corresponding platform toolchains
- For Android release builds: **JDK 17+** (the JDK bundled with current Android Studio, Java 25, works), Android SDK with platform 36, NDK `28.2.13676358`

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
dart analyze                                 # static analyzer -- use this one
dart format lib test                         # format
flutter test                                 # widget/unit tests
flutter test integration_test/               # end-to-end tests (needs a device)
```

**Use `dart analyze`, not `flutter analyze`.** `riverpod_lint` runs through Dart's
native `analysis_server_plugin` and is declared under the top-level `plugins:` key
in [analysis_options.yaml](analysis_options.yaml) rather than as a dev_dependency.
`flutter analyze` silently ignores that key, reporting a clean tree while the
Riverpod lints never run.

One warning is expected: `scoped_providers_should_specify_dependencies` on the
practice page's provider override. It is deliberate and cannot currently be
suppressed — see the Commands section of [AGENTS.md](AGENTS.md).

`custom_lint` is unused: 0.8.1 pins an old `analyzer` and was holding back eleven
dependencies. `riverpod_lint` no longer needs it.

## Custom Word Lists

The default dictionary is bundled at [assets/word_list.txt](assets/word_list.txt). To use your own:

1. Open **Settings**.
2. Toggle **Use custom word list**.
3. Tap **Import** and pick a `.txt` file containing one 5-letter word per line (A–Z only, at most 5 MB; blank lines and duplicates are dropped).
4. The list is saved as `custom_list.txt` in the app's documents directory and a fresh board starts with a word from it. It is used both for answers and for the guesses the game accepts.

**View** previews the active list, and **Import** again replaces it. Turning the toggle off returns to the bundled list without deleting yours. See the [FAQ](FAQ.md#custom-word-lists) for what each import error means.

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

- Kotlin `2.4.10`
- Android Gradle Plugin `8.13.2` (the newest 8.x; AGP 9 needs the new Gradle DSL)
- Gradle wrapper `9.3.1` (Gradle runs on Java 25 only from 9.1)
- `desugar_jdk_libs` `2.1.5`
- NDK `28.2.13676358`
- `targetSdk` `36`, ABI filters `armeabi-v7a`, `arm64-v8a`, `x86_64`

The daily reminder requires **core library desugaring** (enabled in `android/app/build.gradle`) for `flutter_local_notifications`. The Android manifest declares the `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED` and `SCHEDULE_EXACT_ALARM` permissions, plus the plugin's broadcast receivers (`ScheduledNotificationReceiver`, `ScheduledNotificationBootReceiver`, `ActionBroadcastReceiver`) — the plugin does not declare these itself, and without them a scheduled reminder never posts. The reminder's monochrome status-bar icon (`ic_stat_reminder`) lives in `res/drawable-*` and is referenced only by name at runtime, so `res/raw/keep.xml` keeps it from being removed by release resource shrinking — without it, enabling the reminder fails in release builds. The reminder is an **OS-level daily repeat** (`matchDateTimeComponents: time`), so it keeps firing every day at the chosen time even if the app is never reopened; it is (re)scheduled only when the toggle is switched on or the time is changed. Because the plugin cannot skip individual days, it fires whether or not you have already played.

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

## Releases

Releases are automated by GitHub Actions ([.github/workflows/release.yml](.github/workflows/release.yml)). Pushing a **semver tag** (`X.Y.Z`, e.g. `2.1.0` — no `v` prefix) runs two jobs:

1. **Update changelog** — generates a new section from the commits since the previous tag (grouped by conventional-commit type: `feat` → Added, `fix` → Fixed, `perf` → Performance, `docs` → Documentation, everything else → Changed; `chore`/`ci`/`test` are dropped). The section is inserted below the `<!-- BEGIN_VERSIONS -->` marker in [CHANGELOG.md](CHANGELOG.md) and **committed back to `main`**. Because this commit lands after the tag, the tagged commit itself won't contain the new entry. The step is idempotent — re-tagging an already-documented version is a no-op.
2. **Build & release signed APK** — builds a single universal **signed** release APK with Flutter `3.47.1`, then publishes a GitHub Release (auto-generated notes) with `red_owl-<tag>.apk` attached.

### Required repository secrets

The APK is signed with the release keystore, which is reconstructed in CI from these **Settings → Secrets and variables → Actions** secrets:

| Secret | Value |
| --- | --- |
| `KEYSTORE_BASE64` | base64 of `android/app/upload-keystore.jks` |
| `KEYSTORE_PASSWORD` | the keystore's `storePassword` |
| `KEY_PASSWORD` | the key's `keyPassword` |
| `KEY_ALIAS` | the key alias (e.g. `upload`) |

Generate the base64 value with:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android/app/upload-keystore.jks"))
```

### Cutting a release

```bash
# 1. Bump version in pubspec.yaml (name + build number), commit it.
# 2. Tag with the matching semver and push:
git tag 2.1.0
git push origin 2.1.0
```

The tag only names the release; it is not checked against `pubspec.yaml`, so keep them in sync manually. The CHANGELOG auto-commit needs push access for the workflow's `GITHUB_TOKEN` — if `main` is protected against the Actions bot, that push will fail.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for the full, versioned history. It is updated automatically when a new version tag is pushed (see [Releases](#releases)).

## Inspiration

- [NYT Games](https://play.google.com/store/apps/details?id=com.nytimes.crossword)
- [Wordly](https://play.google.com/store/apps/details?id=com.appchirp.wordle)

## License

See [LICENSE](LICENSE).
