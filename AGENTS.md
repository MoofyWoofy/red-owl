# AGENTS.md

This file provides guidance to AI coding agents working in this repository. It is the single source of truth for agent instructions — there is no separate `CLAUDE.md`.

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

**Startup order matters.** `main()` (`lib/main.dart`) must `await SharedPreferenceService().init()` and `await WordleService().init()` *before* `runApp`, because both are singletons read synchronously during the first widget build (dark-mode theme, today's word, rehydrated grid). `NotificationService().init()` is **not** awaited here: it loads the full timezone database and makes platform-channel calls that nothing on the startup screen needs, so it is scheduled in a post-first-frame callback to keep it off the first-frame critical path (scheduling reminders still only happens when the user opts in). Adding new persisted state that the first frame depends on means initializing it (awaited) here too. (Note: startup profiling shows `SharedPreferenceService().init()` itself dominates time-to-first-frame on cold start — see the auto-memory note.)

**App-wide presentation is wired in `App.build` (`main.dart`).** It watches several settings providers and applies them globally: `boolFamilyProvider` for dark mode and the color-blind/high-contrast palette (picks `lightTheme`/`darkTheme` vs. `lightThemeHighContrast`/`darkThemeHighContrast`), `localeProvider` for the UI language, `fontScaleProvider` via a `MediaQuery` `textScaler`, and `motionSpeedProvider` via the global `timeDilation` (the system "remove animations" flag forces the reduced speed, satisfying reduce-motion). These small `String`/`Locale` notifiers live under `lib/riverpod/{locale,font_scale,motion_speed}/`; doubles are stored as string codes because `SharedPreferenceService` has no double methods.

**Two singletons back all persistence:**
- `SharedPreferenceService` (`lib/util/shared_preference_service.dart`) wraps `SharedPreferencesWithCache` with an allowlist derived from the `SharedPreferencesKeys` enum. Only enum-named keys can be stored — add a key to that enum before using it.
- `WordleService` (`lib/util/wordle.dart`) owns the word list and computes the **word of the day deterministically** by seeding `Random` with the date as `yyyyMMdd`. Same date → same word on every device, no server. The seed is built arithmetically (`year * 10000 + month * 100 + day`), **not** via `DateFormat` — `DateFormat` follows the ambient `Intl.defaultLocale`, and a locale rendering non-ASCII numerals would change the daily word per device. The same reasoning applies to `dateToString` in `lib/util/misc.dart`, which produces a storage key, not display text. It resolves the active list as either the bundled `assets/word_list.txt` or the user's imported `custom_list.txt` in the app documents dir, gated by the `useCustomList` preference. Words are normalised to trimmed lower-case on load (blank lines dropped); the raw-text parse runs in a background isolate via `compute` (top-level `_parseWordList`) to keep the ~13k-line split/normalise off the UI thread. `getWordList` caches the result **and** shares the in-flight future (`_pendingLoad`), so concurrent first readers at startup join one load instead of each spawning a parse isolate; `init()` and `importWordList` clear both. Guess matching in `checkGuessWord` lower-cases the guess, so the stored list must stay lower-case.

  **Guess scoring uses the standard two-pass algorithm** (`_scoreGuess`). Pass 1 claims exact matches and tallies the answer letters they did not consume; pass 2 marks misplaced letters left to right only while unclaimed copies remain. Each answer letter is spent once, so green + yellow marks for a letter never exceed its count in the answer. A naive `answer.contains(letter)` test is wrong here — for answer `CRANE` and guess `EERIE` it credits all three `E`s instead of one. Tile colours, the shared emoji grid and hard mode all derive from this, so tests must assert hand-derived expected colours rather than re-deriving them the way the implementation does.

  An **empty word list is rejected at import** (`WordListImportStatus.empty`) and `getWordList` falls back to the bundled asset if the custom list reads back empty. An empty list makes `getWordOfTheDay` throw on `nextInt(0)`, and since `main()` awaits `WordleService().init()`, persisting one stops the app from starting at all.

**Backup / restore.** `BackupService` (`lib/util/backup_service.dart`, also a singleton) serialises settings, stats and the full `History` table into one versioned JSON document (`backupVersion`), and optionally the custom word list. The Settings page's Export/Import buttons drive it via `share_plus` / `file_picker`. `importFromJson` validates the entire document **before** writing anything, so a malformed file leaves existing data untouched; after a successful import the caller re-inits `WordleService`, resets the board, and invalidates the dark-mode / custom-list `boolFamilyProvider`s so the UI reflects the restored values. The in-progress board (`gridState`) is intentionally **not** part of a backup.

That up-front validation covers **both** the `history` rows and the `stats` counter arrays (`_parseCounters`, which requires exactly `statsDataLength` / `guessDistributionLength` non-negative integers). Validating stats is not optional politeness: they are consumed positionally and numerically (`Grid._updateStatsData` destructures `statsData` into four fields and `int.parse`s them; `guessDistribution` is indexed by row), so a wrong length or a non-numeric entry does not fail at import — it breaks the next finished game. Anything new added to a backup needs the same treatment: validate before the first write, or it becomes a delayed crash somewhere else.

**Game state lives in one Riverpod notifier.** `Grid` (`lib/riverpod/grid/grid.dart`) owns the entire board. All input — letters, DELETE, ENTER — funnels through `onKeyboardPressed`. Its `build()` rehydrates an in-progress game from a base64-encoded JSON blob in SharedPreferences and handles **day rollover**: if the stored game is from a previous day and wasn't finished, it's archived to the database as `GameState.incomplete` and a fresh board is returned. On a submitted guess it also enforces **hard mode** (`_hardModeViolation`, gated by the `isHardMode` pref — green letters must stay put, yellow letters must reappear) and celebrates **streak milestones** (`isStreakMilestone`) by swapping the win snackbar for a share nudge. Outcome side effects go through two overridable hooks — `recordOutcome` (stats + history) and `getGuessResult` (answer lookup) — so practice mode can change them without duplicating `onKeyboardPressed`.

`onKeyboardPressed` awaits `getGuessResult` mid-way, so it guards re-entrancy with `_isEvaluatingGuess` and pins the row to a local before the await. Both matter: the writes after the await index the tile list by row, and a DELETE handled during the await shortens the row, which used to throw `RangeError (length): Invalid value: Not in inclusive range 0..3: 4`. Anything new added after that await must use the pinned `row`, not `state.row`.

`_updateStatsData` reads the stored counters defensively (`tryParse`, index-checked) rather than destructuring, so an install already holding a corrupted array heals instead of breaking on every finished game.

**Reveal animation finalization & lifecycle.** The per-tile flip (`tile.dart`) and the staggered win-row bounce (`animations/bounce.dart`) start via `Future.delayed`, so their callbacks must guard `mounted` before driving the `AnimationController` — otherwise leaving the board mid-animation throws `AnimationController.forward() called after dispose()`. When the flip completes, `Tile` finalizes the board from the **current** `gridProvider` state (read fresh, not the value captured when the flip was scheduled), so letters typed during the animation survive; only already-revealed (non-`initial`) tiles are marked `hasFlipAnimationPlayed`.

The flip is scheduled from `ref.listen(gridProvider, ...)` (`_maybeStartFlip`), **not** from `build`. Starting an animation, writing notifier state and persisting to SharedPreferences are side effects and must not run as part of rendering — from `build` every rebuild inside the flip window queued another callback, including rebuilds caused by unrelated things like a theme change. The controller is driven with `forward(from: 0)` and the callback bails out if `isAnimating` or if `runFlipAnimation` has already been cleared: the controller keeps its value between games, so a plain `forward()` after `resetGrid()` completes instantly and the tiles snap to their colour with no flip (most visible in practice mode, which resets on every "New word").

**Practice mode reuses the daily UI via a provider override.** `PracticeGrid` (`lib/riverpod/practice_grid/practice_grid.dart`) **subclasses** `Grid`: it overrides `build()`/`resetGrid()` to use a fresh random word (`WordleService().randomWord()`), `getGuessResult` to score against that word, and `recordOutcome` to a no-op (no stats/history). Its board sets `persistState: false`, so the `Tile` widget skips writing `gridState` and the daily save is never clobbered. `PracticePage` (`lib/routes/game/practice_page.dart`) wraps its subtree in a `ProviderScope` that does `gridProvider.overrideWith(PracticeGrid.new)`, so the shared **`GameBoard`** widget (`lib/routes/game/widgets/game_board.dart`, the grid + keyboard + hardware-key handler, used by both `WordlePage` and `PracticePage`) and all tiles/keys read the practice notifier unchanged. The game board is pinned to LTR (5-letter Latin words / QWERTY) even when the rest of the UI is RTL.

**Hints, sharing and accessibility.** `HintNotifier` (`lib/riverpod/hint/hint_notifier.dart`) gates the once-a-day hint by storing the usage date. `buildEmojiGrid` (`lib/util/share_grid.dart`) is a pure builder for the NYT-style emoji result (color-blind aware); the share/hint actions live in `lib/routes/game/widgets/`. Tiles and keys carry `Semantics` labels (`a11y_labels.dart`), a `GameStatusAnnouncer` live region announces win/loss, and on-screen keys expose an explicit `onTap` so assistive tech can activate them.

**Stats are split across two stores, by design:**
- Aggregate stats (games played/won, current/max streak, guess distribution) are plain string-list arrays in SharedPreferences, updated in `_updateStatsData`. The Stats page derives win rate and average guesses from these (`getWinRate`, `getAverageGuesses` in `lib/util/misc.dart`).
- Per-game history is a Drift/SQLite `History` table (`lib/database/database.dart`), one row per day (`date` is the primary key), written in `_addToDatabase` with `InsertMode.insertOrReplace`. The replace matters: `resetGrid()` restarts the board (word-list toggle, word-list import, backup restore) without clearing that day's existing row, so a plain insert raises `UNIQUE constraint failed: history.date` when the replacement game finishes. Any new write to this table needs the same mode. The `History` widget reads it for the list and supports a date filter (all / rolling 30 days / custom range) by adding a `where` to the query. The Stats page's reset action clears both stores and bumps a key to rebuild the data-reading children.

**Notifications (Android).** `NotificationService` (`lib/util/notification_service.dart`, a singleton) wraps `flutter_local_notifications` for the opt-in daily reminder (off by default). It uses timezone-aware scheduling with a **hybrid exact/inexact** mode (`_scheduleMode()`): if exact alarms are permitted (`canScheduleExactNotifications`) it schedules to-the-minute (`exactAllowWhileIdle`), otherwise it falls back to `inexactAllowWhileIdle` so the reminder still works without the special permission. Enabling the reminder best-effort requests the exact-alarm permission (`requestExactAlarmPermission`, opens system settings on Android 12+). The reminder is an **OS-level daily repeat** (`matchDateTimeComponents: DateTimeComponents.time`): the plugin re-fires it at the next occurrence of the time every day, so it keeps nudging even if the app is never reopened (e.g. the player ignores a reminder and doesn't play — the next day still fires). It is (re)scheduled only when the reminder is enabled and when its time changes (`ReminderSetting`). Consequence of the OS repeat: it fires **every** day at the set time regardless of whether the player already played that day — the plugin cannot skip individual days, so there is intentionally no skip-played logic (`Grid.recordOutcome` no longer touches the reminder). The notification carries a monochrome white-owl status-bar icon (`ic_stat_reminder`, generated from the launcher foreground) and **no large icon**. Because that icon is referenced **only by name string at runtime** (never via `R.drawable`), Flutter's release build (R8 + `shrinkResources`) marks it unreachable and strips it — so `res/raw/keep.xml` (`tools:keep`) must retain it, otherwise `scheduleDailyReminder` throws `PlatformException(invalid_icon)` in **release only** and the reminder toggle silently fails (debug builds don't shrink, so this never reproduces there; guarded by `test/unit/android_manifest_test.dart`). As a backstop, `ReminderSetting._setEnabled` wraps scheduling in a try/catch and surfaces a snackbar (`reminderError`) instead of leaving the toggle stuck off. The underlying plugin is injectable via `pluginForTesting`. The `ReminderSetting` widget owns the toggle + time picker and localizes the notification text at schedule time; the chosen time is held in `ReminderTimeNotifier` (`lib/riverpod/reminder_time/reminder_time_notifier.dart`), persisted as an `HH:mm` string under `SharedPreferencesKeys.reminderTime` (default 8 PM), so the picker reflects a new time immediately instead of only after a restart. Native requirements: core library desugaring in `android/app/build.gradle`, `res/raw/keep.xml` to keep the notification icon through release resource shrinking, the `POST_NOTIFICATIONS`/`RECEIVE_BOOT_COMPLETED`/`SCHEDULE_EXACT_ALARM` manifest permissions, and the plugin's broadcast receivers (`ScheduledNotificationReceiver`, `ScheduledNotificationBootReceiver`, `ActionBroadcastReceiver`) declared in `AndroidManifest.xml` — the v19 plugin does **not** declare them itself, and without `ScheduledNotificationReceiver` the alarm fires but no notification is ever posted (`test/unit/android_manifest_test.dart` guards this).

**Generic boolean settings.** Rather than a notifier per toggle, `BoolFamilyNotifier` (`lib/riverpod/bool_family_notifier/bool_family_notifier.dart`) is a Riverpod *family* keyed by `(BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey)`. Dark mode, custom-list toggle, etc. all reuse it. Per-key defaults (e.g. dark mode falling back to system brightness) live in its `build()` switch. To add a boolean setting, add an ID + a prefs key and read `boolFamilyProvider(id: ..., sharedPrefsKey: ...)`.

**Routes** under `lib/routes/{game,settings,stats}/` are the three screens; `HomePage` lives in `main.dart` and pushes them with custom slide transitions. `lib/config/` holds themes (with `GameColors`/`HistoryColors` theme extensions), enums, animation timings, and key/ID enums.

## Localization

UI strings are ARB files in `lib/l10n/` (`en.arb` is the template, `nl.arb` is Dutch). `generate: true` in `pubspec.yaml` makes `AppLocalizations` regenerate on a full build, but **`build_runner` does not regenerate it** — after editing an ARB file run `flutter gen-l10n` (then `flutter analyze`) or the new `context.l10n.<key>` getters won't resolve. Access strings via the `context.l10n.<key>` extension (`lib/util/localization.dart`). To add a string: add the key to `en.arb` plus every other ARB file (placeholder strings need an `@key` metadata block). To add a language: drop in a new `xx.arb`.

## Testing notes

`SharedPreferencesWithCache` reads through the **async** platform interface, which `SharedPreferences.setMockInitialValues` does not patch. Tests must use the helpers in `test/helpers/test_helpers.dart`: `setSharedPreferencesMock(...)` installs both interfaces, `installFakePathProvider()` fakes the documents dir, and `setAssetBundleMock(words)` stubs the bundled word list. Wrap widgets with `makeTestApp` (adds a Scaffold) or `makeTestAppRaw` (widget supplies its own Scaffold); both accept `overrides` (e.g. `gridProvider.overrideWith(PracticeGrid.new)`) and inject `lightTheme` so the color theme extensions are present. Use `AppDatabase.forTesting(NativeDatabase.memory())` for in-memory DB tests, and `NotificationService().pluginForTesting = mockPlugin` to test reminder scheduling without the platform channel.

Gotchas worth knowing before you lose an hour to one:

- `showSnackBar` (`lib/util/toastbox.dart`) defers via `addPostFrameCallback`, so a widget test needs an extra `pump()` (plus an animation pump) before the snack-bar text is in the tree; and to advance a snack-bar's display timer you must `pump(Duration)` (real time), not `pumpAndSettle(Duration)` (which only sets the frame interval). A test that finishes a game and does not drain those timers fails the `'!timersPending'` assertion — intermittently, if the outcome depends on practice mode's random answer.
- **Never load the word list inside a `testWidgets` body.** `WordleService` parses via `compute()`, and an isolate's future never completes inside the fake-async zone — the test hangs until it times out with "did not complete". Do it in `setUp`, which runs in the real zone (see `view_custom_wordlist_test.dart`).
- Two singleton caches leak between tests in the same file: `rootBundle` memoises loaded assets and `WordleService` caches the parsed list. `setAssetBundleMock` clears the former; call `await WordleService().init()` after installing a new list to clear the latter. Without both, a group that installs its own word list silently keeps serving an earlier test's list.
- Don't assert scoring by re-deriving it the way the implementation does (the old `expect(scoring['in_word'], answer.contains(guess[i]))` mirrored a real bug and could never fail). Use hand-derived expected values.

**`dart run custom_lint` crashes if a stale `build/` directory is present**, with `PathNotFoundException: Directory listing failed` on some deep Gradle transform path — it walks `build/` looking for pubspecs. `flutter clean` fixes it; the failure says nothing about your code.

## Dependencies

`^` constraints already let pub pick the newest compatible version, so raising a lower bound in `pubspec.yaml` unlocks nothing on its own — if `flutter pub outdated` shows *Resolvable* equal to *Current*, something is capping it. As of the 2026-08 maintenance pass the caps are:

- **`custom_lint` 0.8.1** pins `analyzer ^8`, and no newer `custom_lint` exists. That caps `build_runner` (<2.15.2), `json_serializable` (<6.14.1), `freezed` (<3.2.5) and `drift_dev` (<2.34.1). Nothing moves here until custom_lint publishes an analyzer 10+ release.
- **Dart 3.11.4** (Flutter 3.41.6, pinned in CI) caps the whole Riverpod 4.x toolchain: `flutter_riverpod` <3.4.1, `riverpod_annotation` <4.0.5, `riverpod_generator` <4.0.6, `riverpod_lint` <3.1.6 all require Dart ≥3.12. Bumping Flutter unlocks these.
- **The Flutter SDK pins `meta` 1.17.0**, capping `flutter_native_splash` (<2.4.8).
- **`flutter_local_notifications` 19.x pins `timezone ^0.10.0`**, so `timezone` 0.11 needs the (large) fln 22 migration first.
- **`share_plus` 13, `package_info_plus` 10 and `file_picker` 12 all require `win32 ^6`** while the current versions pin `win32 ^5` — they move as one cluster or not at all. file_picker 12's only Dart-side break is `pickFiles` returning a non-nullable `List<PlatformFile>` (empty on cancel) instead of `FilePickerResult?`, but it also splits into federated platform packages, so the word-list and backup import flows need real device testing after that bump.

## Releases & CI

Releases are tag-driven via GitHub Actions (`.github/workflows/release.yml`). The single trigger is pushing a **semver tag** matching `*.*.*` (e.g. `2.1.0`, **no `v` prefix**). Two jobs run:

- **`changelog`** — checks out `main` (full history), then a bash step reconstructs a new `CHANGELOG.md` section from `git log <prev-tag>..<new-tag>`, bucketing commit subjects by conventional-commit type (`feat`→Added, `fix`→Fixed, `perf`→Performance, `docs`→Documentation, `refactor`/`i18n`/`style`/`build`/unprefixed→Changed; `chore`/`ci`/`test` dropped). It inserts the section directly **below the `<!-- BEGIN_VERSIONS -->` marker** in `CHANGELOG.md` and commits it back to `main` with `[skip ci]`. The step is idempotent (greps for an existing `## <tag>` header first). **The CHANGELOG section header format is `## <version>` with no brackets — if you change that style, update both the marker-insertion code and the idempotency grep in the workflow to match, or auto-updates will duplicate or mis-detect entries.**
- **`build`** — checks out the tag, sets up Java 17 + Flutter **pinned to `3.41.6`**, runs `build_runner`, reconstructs the release keystore from secrets, builds a single universal signed APK (`flutter build apk --release`), and publishes a GitHub Release (auto-generated notes) with `red_owl-<tag>.apk`.

Signing in CI needs four repo secrets: `KEYSTORE_BASE64` (base64 of `android/app/upload-keystore.jks`), `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`. The keystore and `android/key.properties` are gitignored (never in the repo); the `build` job writes `android/key.properties` from those secrets at build time. The tag is **not** validated against `pubspec.yaml`'s version — keep them in sync by hand. `CHANGELOG.md` is the user-facing history; the README's Changelog section is just a pointer to it.
