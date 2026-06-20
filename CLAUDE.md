# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Red Owl is an offline-first Wordle clone built with Flutter (Dart SDK `^3.8.0`). It ships on Android, iOS, Linux, macOS, Windows and web from one codebase. There are no network calls, accounts, or telemetry.

## Commands

```bash
flutter pub get                                       # install deps
dart run build_runner build --delete-conflicting-outputs   # regenerate code (see below)
dart run build_runner watch --delete-conflicting-outputs   # regenerate continuously

flutter run                          # run on default device (also -d chrome, -d <id>)
flutter analyze                      # static analyzer
dart run custom_lint                 # riverpod_lint + custom lints (NOT covered by flutter analyze)
dart format lib test

flutter test                                          # all unit + widget tests
flutter test test/unit/models/grid_test.dart          # single file
flutter test --plain-name "name of test"              # single test by name
flutter test integration_test/                        # integration tests (needs a device)
```

`flutter analyze` does not run the Riverpod lints — run `dart run custom_lint` separately to catch provider misuse.

## Code generation is mandatory

This project relies heavily on `build_runner`. After editing any of these, regenerate or the project won't compile:

- `lib/models/**` — Freezed models + JSON (`*.freezed.dart`, `*.g.dart`)
- `lib/riverpod/**` — Riverpod notifiers (`*.g.dart`, provides the `_$ClassName` base and the `xxxProvider`)
- `lib/database/database.dart` — Drift schema (`database.g.dart`)

Generated files are committed, so a fresh checkout compiles without running the generator first — but they go stale the moment you touch a source file. When a `_$Foo` base class or a `fooProvider` symbol is "missing", the fix is almost always re-running `build_runner`, not editing code.

## Barrel-file import convention

Every `lib/` subdirectory exposes a `shared.dart` that re-exports its public files (e.g. `lib/config/shared.dart`, `lib/util/shared.dart`, `lib/riverpod/shared.dart`). Code imports from the barrel with a `show` clause rather than reaching into individual files:

```dart
import 'package:red_owl/util/shared.dart' show SharedPreferenceService, WordleService;
```

When adding a new file to a directory, add it to that directory's `shared.dart` export list. `lib/models/shared.dart` is imported `as models` in places to avoid clashing with the Drift-generated `Grid`/`Tile` classes — keep that aliasing.

## Architecture

**Startup order matters.** `main()` (`lib/main.dart`) must `await SharedPreferenceService().init()` and `await WordleService().init()` *before* `runApp`, because both are singletons read synchronously during the first widget build (dark-mode theme, today's word, rehydrated grid). Adding new persisted state that the first frame depends on means initializing it here too.

**Two singletons back all persistence:**
- `SharedPreferenceService` (`lib/util/shared_preference_service.dart`) wraps `SharedPreferencesWithCache` with an allowlist derived from the `SharedPreferencesKeys` enum. Only enum-named keys can be stored — add a key to that enum before using it.
- `WordleService` (`lib/util/wordle.dart`) owns the word list and computes the **word of the day deterministically** by seeding `Random` with the date as `yyyyMMdd`. Same date → same word on every device, no server. It resolves the active list as either the bundled `assets/word_list.txt` or the user's imported `custom_list.txt` in the app documents dir, gated by the `useCustomList` preference. Words are normalised to trimmed lower-case on load; guess matching in `checkGuessWord` lower-cases the guess, so the stored list must stay lower-case.

**Backup / restore.** `BackupService` (`lib/util/backup_service.dart`, also a singleton) serialises settings, stats and the full `History` table into one versioned JSON document (`backupVersion`), and optionally the custom word list. The Settings page's Export/Import buttons drive it via `share_plus` / `file_picker`. `importFromJson` validates the entire document **before** writing anything, so a malformed file leaves existing data untouched; after a successful import the caller re-inits `WordleService`, resets the board, and invalidates the dark-mode / custom-list `boolFamilyProvider`s so the UI reflects the restored values. The in-progress board (`gridState`) is intentionally **not** part of a backup.

**Game state lives in one Riverpod notifier.** `Grid` (`lib/riverpod/grid/grid.dart`) owns the entire board. All input — letters, DELETE, ENTER — funnels through `onKeyboardPressed`. Its `build()` rehydrates an in-progress game from a base64-encoded JSON blob in SharedPreferences and handles **day rollover**: if the stored game is from a previous day and wasn't finished, it's archived to the database as `GameState.incomplete` and a fresh board is returned.

**Stats are split across two stores, by design:**
- Aggregate stats (games played/won, current/max streak, guess distribution) are plain string-list arrays in SharedPreferences, updated in `_updateStatsData`.
- Per-game history is a Drift/SQLite `History` table (`lib/database/database.dart`), one row per day (`date` is the primary key), written in `_addToDatabase`. The Stats page reads this for the history list and chart.

**Generic boolean settings.** Rather than a notifier per toggle, `BoolFamilyNotifier` (`lib/riverpod/bool_family_notifier/bool_family_notifier.dart`) is a Riverpod *family* keyed by `(BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey)`. Dark mode, custom-list toggle, etc. all reuse it. Per-key defaults (e.g. dark mode falling back to system brightness) live in its `build()` switch. To add a boolean setting, add an ID + a prefs key and read `boolFamilyProvider(id: ..., sharedPrefsKey: ...)`.

**Routes** under `lib/routes/{game,settings,stats}/` are the three screens; `HomePage` lives in `main.dart` and pushes them with custom slide transitions. `lib/config/` holds themes (with `GameColors`/`HistoryColors` theme extensions), enums, animation timings, and key/ID enums.

## Localization

UI strings are ARB files in `lib/l10n/` (`en.arb` is the template, `nl.arb` is Dutch). `generate: true` in `pubspec.yaml` makes `AppLocalizations` regenerate automatically on build. Access strings via the `context.l10n.<key>` extension (`lib/util/localization.dart`). To add a string: add the key to `en.arb` plus every other ARB file. To add a language: drop in a new `xx.arb`.

## Testing notes

`SharedPreferencesWithCache` reads through the **async** platform interface, which `SharedPreferences.setMockInitialValues` does not patch. Tests must use the helpers in `test/helpers/test_helpers.dart`: `setSharedPreferencesMock(...)` installs both interfaces, `installFakePathProvider()` fakes the documents dir, and `setAssetBundleMock(words)` stubs the bundled word list. Wrap widgets with `makeTestApp` (adds a Scaffold) or `makeTestAppRaw` (widget supplies its own Scaffold); both inject `lightTheme` so the color theme extensions are present. Use `AppDatabase.forTesting(NativeDatabase.memory())` for in-memory DB tests.
