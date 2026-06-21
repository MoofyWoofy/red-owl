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

**Startup order matters.** `main()` (`lib/main.dart`) must `await SharedPreferenceService().init()` and `await WordleService().init()` *before* `runApp`, because both are singletons read synchronously during the first widget build (dark-mode theme, today's word, rehydrated grid). It also `await`s `NotificationService().init()` (prepares the reminder plugin; scheduling only happens when the user opts in). Adding new persisted state that the first frame depends on means initializing it here too.

**App-wide presentation is wired in `App.build` (`main.dart`).** It watches several settings providers and applies them globally: `boolFamilyProvider` for dark mode and the color-blind/high-contrast palette (picks `lightTheme`/`darkTheme` vs. `lightThemeHighContrast`/`darkThemeHighContrast`), `localeProvider` for the UI language, `fontScaleProvider` via a `MediaQuery` `textScaler`, and `motionSpeedProvider` via the global `timeDilation` (the system "remove animations" flag forces the reduced speed, satisfying reduce-motion). These small `String`/`Locale` notifiers live under `lib/riverpod/{locale,font_scale,motion_speed}/`; doubles are stored as string codes because `SharedPreferenceService` has no double methods.

**Two singletons back all persistence:**
- `SharedPreferenceService` (`lib/util/shared_preference_service.dart`) wraps `SharedPreferencesWithCache` with an allowlist derived from the `SharedPreferencesKeys` enum. Only enum-named keys can be stored — add a key to that enum before using it.
- `WordleService` (`lib/util/wordle.dart`) owns the word list and computes the **word of the day deterministically** by seeding `Random` with the date as `yyyyMMdd`. Same date → same word on every device, no server. It resolves the active list as either the bundled `assets/word_list.txt` or the user's imported `custom_list.txt` in the app documents dir, gated by the `useCustomList` preference. Words are normalised to trimmed lower-case on load; guess matching in `checkGuessWord` lower-cases the guess, so the stored list must stay lower-case.

**Backup / restore.** `BackupService` (`lib/util/backup_service.dart`, also a singleton) serialises settings, stats and the full `History` table into one versioned JSON document (`backupVersion`), and optionally the custom word list. The Settings page's Export/Import buttons drive it via `share_plus` / `file_picker`. `importFromJson` validates the entire document **before** writing anything, so a malformed file leaves existing data untouched; after a successful import the caller re-inits `WordleService`, resets the board, and invalidates the dark-mode / custom-list `boolFamilyProvider`s so the UI reflects the restored values. The in-progress board (`gridState`) is intentionally **not** part of a backup.

**Game state lives in one Riverpod notifier.** `Grid` (`lib/riverpod/grid/grid.dart`) owns the entire board. All input — letters, DELETE, ENTER — funnels through `onKeyboardPressed`. Its `build()` rehydrates an in-progress game from a base64-encoded JSON blob in SharedPreferences and handles **day rollover**: if the stored game is from a previous day and wasn't finished, it's archived to the database as `GameState.incomplete` and a fresh board is returned. On a submitted guess it also enforces **hard mode** (`_hardModeViolation`, gated by the `isHardMode` pref — green letters must stay put, yellow letters must reappear) and celebrates **streak milestones** (`isStreakMilestone`) by swapping the win snackbar for a share nudge. Outcome side effects go through two overridable hooks — `recordOutcome` (stats + history) and `getGuessResult` (answer lookup) — so practice mode can change them without duplicating `onKeyboardPressed`.

**Practice mode reuses the daily UI via a provider override.** `PracticeGrid` (`lib/riverpod/practice_grid/practice_grid.dart`) **subclasses** `Grid`: it overrides `build()`/`resetGrid()` to use a fresh random word (`WordleService().randomWord()`), `getGuessResult` to score against that word, and `recordOutcome` to a no-op (no stats/history). Its board sets `persistState: false`, so the `Tile` widget skips writing `gridState` and the daily save is never clobbered. `PracticePage` (`lib/routes/game/practice_page.dart`) wraps its subtree in a `ProviderScope` that does `gridProvider.overrideWith(PracticeGrid.new)`, so the shared **`GameBoard`** widget (`lib/routes/game/widgets/game_board.dart`, the grid + keyboard + hardware-key handler, used by both `WordlePage` and `PracticePage`) and all tiles/keys read the practice notifier unchanged. The game board is pinned to LTR (5-letter Latin words / QWERTY) even when the rest of the UI is RTL.

**Hints, sharing and accessibility.** `HintNotifier` (`lib/riverpod/hint/hint_notifier.dart`) gates the once-a-day hint by storing the usage date. `buildEmojiGrid` (`lib/util/share_grid.dart`) is a pure builder for the NYT-style emoji result (color-blind aware); the share/hint actions live in `lib/routes/game/widgets/`. Tiles and keys carry `Semantics` labels (`a11y_labels.dart`), a `GameStatusAnnouncer` live region announces win/loss, and on-screen keys expose an explicit `onTap` so assistive tech can activate them.

**Stats are split across two stores, by design:**
- Aggregate stats (games played/won, current/max streak, guess distribution) are plain string-list arrays in SharedPreferences, updated in `_updateStatsData`. The Stats page derives win rate and average guesses from these (`getWinRate`, `getAverageGuesses` in `lib/util/misc.dart`).
- Per-game history is a Drift/SQLite `History` table (`lib/database/database.dart`), one row per day (`date` is the primary key), written in `_addToDatabase`. The `History` widget reads it for the list and supports a date filter (all / rolling 30 days / custom range) by adding a `where` to the query. The Stats page's reset action clears both stores and bumps a key to rebuild the data-reading children.

**Notifications (Android).** `NotificationService` (`lib/util/notification_service.dart`, a singleton) wraps `flutter_local_notifications` for the opt-in daily reminder (off by default). It uses inexact timezone-aware scheduling (no exact-alarm permission needed); the underlying plugin is injectable via `pluginForTesting`. The `ReminderSetting` widget owns the toggle + time picker and localizes the notification text at schedule time. Native requirements: core library desugaring in `android/app/build.gradle` and the `POST_NOTIFICATIONS`/`RECEIVE_BOOT_COMPLETED` manifest permissions.

**Generic boolean settings.** Rather than a notifier per toggle, `BoolFamilyNotifier` (`lib/riverpod/bool_family_notifier/bool_family_notifier.dart`) is a Riverpod *family* keyed by `(BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey)`. Dark mode, custom-list toggle, etc. all reuse it. Per-key defaults (e.g. dark mode falling back to system brightness) live in its `build()` switch. To add a boolean setting, add an ID + a prefs key and read `boolFamilyProvider(id: ..., sharedPrefsKey: ...)`.

**Routes** under `lib/routes/{game,settings,stats}/` are the three screens; `HomePage` lives in `main.dart` and pushes them with custom slide transitions. `lib/config/` holds themes (with `GameColors`/`HistoryColors` theme extensions), enums, animation timings, and key/ID enums.

## Localization

UI strings are ARB files in `lib/l10n/` (`en.arb` is the template, `nl.arb` is Dutch). `generate: true` in `pubspec.yaml` makes `AppLocalizations` regenerate on a full build, but **`build_runner` does not regenerate it** — after editing an ARB file run `flutter gen-l10n` (then `flutter analyze`) or the new `context.l10n.<key>` getters won't resolve. Access strings via the `context.l10n.<key>` extension (`lib/util/localization.dart`). To add a string: add the key to `en.arb` plus every other ARB file (placeholder strings need an `@key` metadata block). To add a language: drop in a new `xx.arb`.

## Testing notes

`SharedPreferencesWithCache` reads through the **async** platform interface, which `SharedPreferences.setMockInitialValues` does not patch. Tests must use the helpers in `test/helpers/test_helpers.dart`: `setSharedPreferencesMock(...)` installs both interfaces, `installFakePathProvider()` fakes the documents dir, and `setAssetBundleMock(words)` stubs the bundled word list. Wrap widgets with `makeTestApp` (adds a Scaffold) or `makeTestAppRaw` (widget supplies its own Scaffold); both accept `overrides` (e.g. `gridProvider.overrideWith(PracticeGrid.new)`) and inject `lightTheme` so the color theme extensions are present. Use `AppDatabase.forTesting(NativeDatabase.memory())` for in-memory DB tests, and `NotificationService().pluginForTesting = mockPlugin` to test reminder scheduling without the platform channel.

Two gotchas: `showSnackBar` (`lib/util/toastbox.dart`) defers via `addPostFrameCallback`, so a widget test needs an extra `pump()` (plus an animation pump) before the snack-bar text is in the tree; and to advance a snack-bar's display timer you must `pump(Duration)` (real time), not `pumpAndSettle(Duration)` (which only sets the frame interval).
