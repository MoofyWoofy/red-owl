# Red Owl — FAQ

Answers to the problems people actually run into. The first half is for
**players**; the second half is for **developers and maintainers** building,
signing and releasing the app.

- [For players](#for-players)
  - [Installing and updating](#installing-and-updating)
  - [Your data](#your-data)
  - [The daily word, streaks and game modes](#the-daily-word-streaks-and-game-modes)
  - [Custom word lists](#custom-word-lists)
  - [Daily reminder (Android)](#daily-reminder-android)
  - [Display and accessibility](#display-and-accessibility)
- [For developers and maintainers](#for-developers-and-maintainers)
  - [Signing, Google Play and GitHub APKs](#signing-google-play-and-github-apks)
  - [Build problems](#build-problems)
  - [Testing and devices](#testing-and-devices)
  - [Releasing](#releasing)

---

## For players

### Installing and updating

#### Google Play says "Can't install Red Owl" when I tap Update

Your installed copy came from somewhere other than Google Play — usually the
APK on the GitHub releases page — and Android will not let one replace the
other.

Every Android app is signed, and Android only accepts an update signed with the
**same key** as the copy already installed. The Google Play version is signed by
Google; the GitHub APK is signed by the developer's own key. They are the same
app, but to Android they are incompatible, so the update is refused. (Installing
an APK file over a Play copy fails the same way, with "App not installed" or
"package conflicts with an existing package".)

To switch sources without losing anything:

1. Open Red Owl → **Settings** → **Export Data**, and save the file somewhere
   you can reach (Drive, Downloads, email it to yourself). Say yes to including
   your word list if you use a custom one.
2. Uninstall Red Owl.
3. Install it from the source you want to keep using (Google Play is
   recommended — it updates itself).
4. Open Red Owl → **Settings** → **Import Data** and pick the file.

After that, stick to the one source. To see where your copy came from, open
Android **Settings → Apps → Red Owl** and scroll to **App details** ("App
installed from …").

#### Android blocks the GitHub APK as being from an unverified developer

Android now requires apps on certified devices to be registered to a verified
developer — including APKs installed outside the Play Store. Enforcement began
on 30 September 2026 in Brazil, Indonesia, Singapore and Thailand, and is
rolling out to other countries from 2027. Copies installed from Google Play are
not affected, so if an APK is blocked, install Red Owl from Google Play instead.

#### "App not installed" for other reasons

- **Not enough storage** — free up some space and try again.
- **Installing an older version over a newer one** — Android refuses
  downgrades. Uninstall first (export your data first).
- **A damaged download** — download the APK again.
- **Android too old** — Red Owl needs Android 7.0 or newer.

#### Does Red Owl need an internet connection?

No. Everything — the word of the day, your stats, the reminder — works offline.
There are no accounts, ads or tracking.

### Your data

#### Where are my stats stored? Can I move them to a new phone?

Only on your device. Nothing is uploaded anywhere, so uninstalling the app or
clearing its storage deletes your stats and history.

To move or back up your data, use **Settings → Export Data**. It saves one file
containing every setting, your stats, your full game history and (if you choose)
your custom word list. On the other device, **Settings → Import Data** restores
it. A game you are halfway through is not included.

Importing **replaces** the stats, history and settings on the device you import
into — it does not merge them.

Android's own device backup may also restore Red Owl's data when you reinstall
on the same Google account, but that is up to Android and not guaranteed —
export a file if the data matters to you.

#### "Import failed: invalid backup file"

The file is not a Red Owl backup, or it has been edited or damaged. Nothing was
changed — an import is checked in full before anything is written. Try the
original exported file.

### The daily word, streaks and game modes

#### When does the word change?

At midnight in your phone's time zone. Everyone using the built-in word list
gets the same word on the same date; it is worked out on the phone, with no
server involved. With a custom word list you get different words.

#### I had the app open at midnight — what happens to my game?

The board you were playing stays yesterday's puzzle, scored against yesterday's
word, and if you finish it, it is recorded under yesterday's date. As soon as
you leave the app and come back, today's puzzle starts. If yesterday's game was
left unfinished, it appears in your history as **incomplete** (yellow).

#### How do streaks work?

**Current streak** counts wins in a row and resets to zero when you lose a
game. Days you skip, and games left unfinished at midnight, do not reset it.
**Max streak** is the best current streak you have reached.

#### Practice, hard mode and hints

- **Practice** plays unlimited random words. It never counts towards your stats,
  streaks or history.
- **Hard mode** makes you reuse every hint you have been given: a green letter
  must stay in place and a yellow letter must appear in your next guess. It
  can't be switched on or off once you have started the day's game.
- **Hint** (light bulb) reveals the first letter you have not yet got green.
  There is one hint per day.

### Custom word lists

#### What format does the word list need?

A plain `.txt` file with **one word per line**:

- every word exactly **five letters, A–Z** — no accents, digits, spaces or
  punctuation (upper or lower case is fine);
- blank lines are ignored, and duplicates are removed;
- at most **5 MB**;
- at least **365 words** is recommended, otherwise words repeat within a year.

The list is used both for the daily answer **and** for the guesses the game
accepts, so any word missing from your list is rejected as "not in word list".

#### What do the import errors mean?

| Message | Meaning |
| --- | --- |
| Line *N*: "*word*" is not a valid 5-letter word | That line breaks the rules above. Nothing was imported. |
| File contains no words | The file is empty or only blank lines. |
| File is too large | It is over 5 MB. |
| File could not be read | Not a readable text file (for example a Word document renamed to `.txt`), or the picker could not open it. |

#### What happens to my current game when I import a list?

Importing a list starts a fresh board for today with a word from the new list.
Switching **Use custom word list** on or off while a game is in progress asks
first, because the board has to be reset. Switching it off goes back to the
built-in list; your imported list is kept for when you switch it on again.

### Daily reminder (Android)

#### The reminder doesn't show up

Check, in order:

1. **Notifications are allowed** — Android **Settings → Apps → Red Owl →
   Notifications**. If you tapped "Don't allow" when asked, the reminder cannot
   appear.
2. **Alarms & reminders is allowed** — **Settings → Apps → Red Owl → Alarms &
   reminders**. Without it the reminder still arrives, but Android may deliver
   it some time after the time you chose.
3. **Battery saving** — aggressive battery optimisation, mostly on non-Pixel
   phones, can delay or drop reminders. Set Red Owl's battery usage to
   *Unrestricted*.
4. **After moving to a new phone** — importing a backup re-creates the reminder,
   but the new phone still has to grant the notification permission. If it was
   refused, the toggle switches itself off; turn it back on.

#### Why does the reminder come even after I've played?

That is a limitation of how Android repeats a scheduled notification: it fires
every day at the chosen time and cannot skip individual days. Turn the reminder
off in Settings if you don't want it.

### Display and accessibility

- **Color-blind / high contrast** swaps green and yellow for **blue (right
  letter, right place)** and **orange (right letter, wrong place)**, in the
  game, on the keyboard and in your stats.
- **Text size** and **Animation speed** are in Settings. *Reduced* makes the
  animations finish almost instantly, and Red Owl switches to it automatically
  when Android's *Remove animations* setting is on.
- **Language** follows your phone (English or Dutch) unless you pick one in
  Settings.

---

## For developers and maintainers

See [AGENTS.md](AGENTS.md) for the architecture and the full list of
conventions; this section covers the problems that cost the most time.

### Signing, Google Play and GitHub APKs

#### Why can't a GitHub APK and a Play install update each other?

There are two signing keys:

| Key | Held by | Signs |
| --- | --- | --- |
| **Upload key** (`android/app/upload-keystore.jks`, alias `upload`) | the maintainer | local release builds, the AAB uploaded to Play, and the GitHub release APK built by CI |
| **App signing key** | Google (Play App Signing) | every APK Google Play delivers to devices |

Play re-signs each uploaded bundle with the app signing key, so the APK a phone
gets from Play is signed differently from the APK on GitHub. Android rejects an
update across keys (`INSTALL_FAILED_UPDATE_INCOMPATIBLE`), which Play reports as
"Can't install Red Owl". Players who switch sources have to uninstall first —
see [the player answer](#google-play-says-cant-install-red-owl-when-i-tap-update).

The fix is to publish one identity everywhere — for example by having CI attach
the **Play-signed universal APK** (Play Console → App bundle explorer, or the
Play Developer API's `generatedapks` endpoint) to the GitHub release instead of
an upload-key APK.

Compare signers with:

```bash
apksigner verify --print-certs app.apk          # an APK file
keytool -printcert -jarfile app-release.aab     # an AAB
```

#### How do I test a release build on a phone that has the Play version?

You can't side-load it over the Play copy (different key). Either upload the
AAB to Play's **internal testing** track (or Internal app sharing) and install
from there, or export your data and uninstall the Play copy first.

#### Keystore safety

Keep `upload-keystore.jks` and `android/key.properties` backed up somewhere
other than this machine. Both are gitignored, and the CI secrets
(`KEYSTORE_BASE64`, `KEYSTORE_PASSWORD`, `KEY_PASSWORD`, `KEY_ALIAS`) are only a
copy. If the upload key is lost, Play can reset it (Play Console → App
integrity), but anyone using the GitHub APK would have to reinstall.

#### Play rejects the upload / says the version code is used

`versionCode` (the `+N` in `pubspec.yaml`'s `version: X.Y.Z+N`) must be higher
than every bundle already uploaded, on any track. Bump it for every upload.

#### 16 KB memory page sizes

Play requires apps targeting Android 15+ to support 16 KB pages, and newer
devices use them. Current builds are compliant. To check a build:

```bash
# Zip alignment of native libraries
zipalign -c -P 16 -v 4 app-release.apk
# ELF segment alignment — every LOAD line must be 0x4000 or larger
llvm-readelf -lW lib/arm64-v8a/libsqlite3.so
```

`llvm-readelf` ships with the NDK
(`ndk/<version>/toolchains/llvm/prebuilt/<host>/bin`). To test on a device, use
an emulator image with **16 KB page size** in its name (e.g. `ps16k`). On it,
`adb shell dumpsys package dev.moofy.red_owl` should show `pageSizeCompat=0`.

### Build problems

#### "Gradle build failed due to Java/Gradle incompatibility" (Java 25)

Flutter builds Android with the JDK bundled in the newest Android Studio, which
is now Java 25. Gradle only runs on Java 25 from **9.1.0**; the wrapper is on
**9.3.1** for this reason. If you hit it on an older checkout, update
`android/gradle/wrapper/gradle-wrapper.properties`, or point Flutter at an older
JDK with `flutter config --jdk-dir=<path>`.

#### "Flutter support for your project's Android Gradle Plugin version (8.13.2) will soon be dropped"

Expected. The project is deliberately on AGP 8.13.2 (the last 8.x). Moving to
AGP 9 means rewriting `android/app/build.gradle` for the new DSL and is planned
together with the next Flutter upgrade.

#### `_$Something` or `somethingProvider` is undefined

Generated code is stale. Run
`dart run build_runner build --delete-conflicting-outputs`.

#### `context.l10n.newKey` is undefined after editing an ARB file

`build_runner` does not regenerate localizations. Run `flutter gen-l10n`.

#### "cannot find symbol" in `GeneratedPluginRegistrant.java`

A plugin was added, removed or renamed. Run `flutter clean`, then build again.

#### `flutter analyze` is clean but Riverpod lint warnings are missing

`riverpod_lint` only runs under `dart analyze`. Use that. The one
`scoped_providers_should_specify_dependencies` warning on the practice page is
expected.

#### `dart format` rewrote an entire file

The existing code predates the formatter's current ("tall") style, so
formatting an old file rewrites much more than you touched. Format new files
freely, but keep edits to existing files in their surrounding style so diffs
stay reviewable.

#### Git shows the Linux/macOS/Windows plugin registrants as modified

Those generated files are rewritten with LF line endings by `flutter pub get`
while Git checks them out with CRLF on Windows. `git diff` shows no content
change; leave them alone.

#### The daily reminder works in debug but fails in release

Release builds shrink resources, and the notification icon is only referenced
by name at runtime, so `res/raw/keep.xml` must keep `ic_stat_reminder`. Check it
has not been removed (`test/unit/android_manifest_test.dart` guards it).

### Testing and devices

#### A widget test hangs with "did not complete"

The word list was loaded inside a `testWidgets` body. Parsing uses `compute`,
whose isolate never completes inside the fake-async zone. Load it in `setUp`.

#### A test fails with a `!timersPending` assertion

A snack bar's timer was still pending. Advance real time with
`tester.pump(const Duration(seconds: 4))` — `pumpAndSettle(Duration)` only sets
the frame interval.

#### Integration tests fail at random or leak state between runs

`await app.main()` (it is asynchronous), and clear stored state with
`await SharedPreferencesAsync().clear()` — `setMockInitialValues` does nothing
on a real device.

#### `adb exec-out screencap` only shows the splash screen

Debug builds render Flutter content in a way `screencap` cannot capture.
Screenshot a release build, or use `IntegrationTestWidgetsFlutterBinding.takeScreenshot`
via `flutter drive`.

#### adb paths are mangled in Git Bash (`/sdcard` turns into a Windows path)

Run `export MSYS_NO_PATHCONV=1` before adb commands that take a device path.

### Releasing

#### How do I cut a release?

1. Bump `version: X.Y.Z+N` in `pubspec.yaml` and commit.
2. Build the bundle for Play: `flutter build appbundle --release`, and upload
   `build/app/outputs/bundle/release/app-release.aab`.
3. Tag the commit with the bare version — `2.3.1`, **not** `v2.3.1` — and push
   the tag. CI builds the signed GitHub APK, publishes the GitHub release and
   commits the new `CHANGELOG.md` section to `main`.

The tag is not checked against `pubspec.yaml`, so keep the two in sync. Pull
after CI finishes to pick up its changelog commit.

#### The release workflow didn't run, or the changelog entry is missing

The trigger only matches tags shaped like `X.Y.Z`; a `v` prefix will not
trigger it. Re-pushing a tag whose version is already in `CHANGELOG.md` is a
no-op for the changelog step.
