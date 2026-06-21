# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

<!-- New release sections are inserted directly below this marker by the release workflow. Do not remove it. -->
<!-- BEGIN_VERSIONS -->

## 2.0.0

A large stability, accessibility and feature release.

### Added
- Practice / unlimited mode that plays endless rounds against random words without touching your stats.
- Hard mode with the standard "every revealed hint must be reused" ruleset.
- Once-per-day hint that reveals a single correct letter.
- Opt-in daily reminder notification at a time you choose (Android, off by default).
- NYT-style emoji result grid sharing, plus streak-milestone celebration prompts on a winning day.
- Data backup/restore — export and import settings, stats and history as a versioned JSON document from Settings.
- Stats: separate wins count, average guesses, a reset-all-statistics action, and a per-game history filter (all / last 30 days / custom range).
- Accessibility: semantic labels on tiles and keys, a win/loss screen-reader live-region announcement, and full keyboard/focus operability.
- Right-to-left layout support.
- UI language selector and a color-blind / high-contrast palette toggle in Settings.
- Adjustable text size and animation speed preferences.
- Animated Stats content and a friendlier empty state for the history list.
- Custom word-list import hardening: clear error messages, automatic de-duplication, a too-small-list warning, and a 5 MB file-size cap.

### Changed
- The tile reveal now finalizes from the current grid state, so letters typed while a row is flipping are preserved.
- Settings reads the grid provider in its callback instead of watching it.
- A single `AppDatabase` connection is now shared via a singleton.
- Dates are shown in the user's regional format and the custom word-list page title is localized.
- Dependencies upgraded within existing constraints.

### Fixed
- Reveal-animation crash: leaving the game during the tile flip or win bounce no longer calls `AnimationController.forward()` after dispose.
- The centred snackbar and the history date-range filter no longer touch a widget that has been disposed.
- Blank lines in a word list are now ignored.
- Null-safe handling of the history `FutureBuilder` result.
- The hardware keyboard now plays the game.
- Custom word lists are normalised to trimmed lower-case.
- Dropped a stray trailing comma in the English win-rate label and removed leftover debug code from the grid notifier.

### Performance
- The word list is parsed on a background isolate to keep the UI thread free.
- The daily-reminder plugin now initialises after the first frame instead of blocking it.
- Keyboard-key rebuilds are narrowed with a provider `select`, and the word list is cached in `WordleService`.

## 1.3.0

### Added
- Comprehensive test suite — 141 tests across unit, widget and integration layers.
- Detailed doc comments across all source, widget and test files.

### Changed
- Upgraded to Flutter SDK 3.8 and the matching Android toolchain, fixing all resulting build breaks.
- Bumped the Android Java/Kotlin target from 1.8 to 17.

## 1.2.0

### Added
- Slide transition animation for page routes.

### Changed
- Updated the Gradle version.
- The backspace key color now matches the letter keys.

## 1.1.3

### Added
- Localization support, including a Dutch translation.

### Changed
- Dates are stored as a date type instead of a string.
- Added a shadow to the letter tiles.

## 1.1.2

### Added
- In-app help for the game and history pages.

### Changed
- Split out the custom color definitions.

## 1.1.1

### Added
- Ability to share your stats.
- Privacy policy in the About dialog.

## 1.1.0

### Added
- Android release signing.
- An `incomplete` game state recorded in the database for unfinished days.

### Changed
- The app version is now derived from `pubspec.yaml`.

## 1.0.0

Initial release.

### Added
- Core Wordle gameplay: a 5×6 guess grid with an on-screen keyboard.
- Pop-in, flip, bounce and shake animations, with snackbar game-status feedback.
- Persistent in-progress game state stored in shared preferences.
- Light/dark theme with persistence, plus a settings page.
- Stats page and per-game history recorded when a game ends.
- Custom word lists with import-time validation.
- Fully offline operation — no network calls.
- About + license page, splash screen and app icon.
