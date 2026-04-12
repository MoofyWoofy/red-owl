import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:red_owl/config/shared.dart' show lightTheme;
import 'package:red_owl/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

/// Fake [PathProviderPlatform] backed by a caller-supplied [Directory].
///
/// Registers itself as the active platform instance via
/// [PathProviderPlatform.instance] so that `path_provider` calls such as
/// [getApplicationDocumentsDirectory] resolve to the provided temp directory
/// instead of a real OS path.
///
/// Mixed in with [MockPlatformInterfaceMixin] to satisfy the plugin interface
/// contract that normally prevents non-production implementations.
class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.directory);

  /// The temporary directory returned for every platform path query.
  final Directory directory;

  @override
  Future<String?> getApplicationDocumentsPath() async => directory.path;
  @override
  Future<String?> getApplicationSupportPath() async => directory.path;
  @override
  Future<String?> getTemporaryPath() async => directory.path;
  @override
  Future<String?> getApplicationCachePath() async => directory.path;
  @override
  Future<String?> getDownloadsPath() async => directory.path;
  @override
  Future<String?> getLibraryPath() async => directory.path;
  @override
  Future<List<String>?> getExternalStoragePaths({
    StorageDirectory? type,
  }) async =>
      [directory.path];
  @override
  Future<String?> getExternalStoragePath() async => directory.path;
}

/// Fake [SharedPreferencesAsyncPlatform] backed by an in-memory store.
///
/// [SharedPreferencesWithCache] (used by [SharedPreferenceService]) reads
/// through the async platform interface, not the legacy synchronous one.
/// The standard `SharedPreferences.setMockInitialValues` only patches the
/// legacy interface, so tests that exercise [SharedPreferenceService] also
/// need this class to be installed as [SharedPreferencesAsyncPlatform.instance].
///
/// Uses [InMemorySharedPreferencesAsync.withData] so the initial values are
/// available synchronously as soon as [SharedPreferencesWithCache.create]
/// resolves — no extra async priming step needed.
base class FakeSharedPreferencesAsync
    extends SharedPreferencesAsyncPlatform {
  FakeSharedPreferencesAsync([Map<String, Object> initialData = const {}])
      : backend = InMemorySharedPreferencesAsync.withData(initialData);

  /// Underlying in-memory store; all methods delegate to this.
  final InMemorySharedPreferencesAsync backend;

  @override
  Future<bool> clear(
      ClearPreferencesParameters parameters,
      SharedPreferencesOptions options) =>
      backend.clear(parameters, options);
  @override
  Future<bool?> getBool(String key, SharedPreferencesOptions options) =>
      backend.getBool(key, options);
  @override
  Future<double?> getDouble(String key, SharedPreferencesOptions options) =>
      backend.getDouble(key, options);
  @override
  Future<int?> getInt(String key, SharedPreferencesOptions options) =>
      backend.getInt(key, options);
  @override
  Future<Set<String>> getKeys(
      GetPreferencesParameters parameters,
      SharedPreferencesOptions options) =>
      backend.getKeys(parameters, options);
  @override
  Future<Map<String, Object>> getPreferences(
      GetPreferencesParameters parameters,
      SharedPreferencesOptions options) =>
      backend.getPreferences(parameters, options);
  @override
  Future<String?> getString(String key, SharedPreferencesOptions options) =>
      backend.getString(key, options);
  @override
  Future<List<String>?> getStringList(
      String key, SharedPreferencesOptions options) =>
      backend.getStringList(key, options);
  @override
  Future<bool> setBool(
      String key, bool value, SharedPreferencesOptions options) =>
      backend.setBool(key, value, options);
  @override
  Future<bool> setDouble(
      String key, double value, SharedPreferencesOptions options) =>
      backend.setDouble(key, value, options);
  @override
  Future<bool> setInt(
      String key, int value, SharedPreferencesOptions options) =>
      backend.setInt(key, value, options);
  @override
  Future<bool> setString(
      String key, String value, SharedPreferencesOptions options) =>
      backend.setString(key, value, options);
  @override
  Future<bool> setStringList(
      String key, List<String> value, SharedPreferencesOptions options) =>
      backend.setStringList(key, value, options);
}

/// Installs both the legacy and async SharedPreferences fakes so that both
/// [SharedPreferences] and [SharedPreferencesWithCache] return [initialValues].
///
/// Call this in `setUp` before calling `SharedPreferenceService().init()`.
void setSharedPreferencesMock([Map<String, Object> initialValues = const {}]) {
  // Legacy interface used by SharedPreferences.getInstance().
  SharedPreferences.setMockInitialValues(initialValues);
  // Async interface used by SharedPreferencesWithCache.create().
  SharedPreferencesAsyncPlatform.instance =
      FakeSharedPreferencesAsync(initialValues);
}

/// Creates a temporary directory, registers a [FakePathProvider] pointing to
/// it, and schedules its deletion via [addTearDown].
///
/// Returns the directory so test code can place fixture files inside it
/// (e.g. a custom word list).
Future<Directory> installFakePathProvider() async {
  final dir = await Directory.systemTemp.createTemp('red_owl_test_');
  PathProviderPlatform.instance = FakePathProvider(dir);
  addTearDown(() async {
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  });
  return dir;
}

/// Installs a fake asset bundle that responds to `assets/word_list.txt`
/// with the given [wordList] joined by newlines.
///
/// Pass `null` for [wordList] to remove any previously installed handler and
/// restore the real asset bundle behaviour.
///
/// Implemented by intercepting the `flutter/assets` platform message channel
/// — the same channel [rootBundle] uses internally.
void setAssetBundleMock(List<String>? wordList) {
  final binding = TestDefaultBinaryMessengerBinding.instance;
  binding.defaultBinaryMessenger.setMockMessageHandler(
    'flutter/assets',
    wordList == null
        ? null
        : (message) async {
            final key = utf8.decode(message!.buffer.asUint8List());
            if (key == 'assets/word_list.txt') {
              final bytes = utf8.encode(wordList.join('\n'));
              return ByteData.view(Uint8List.fromList(bytes).buffer);
            }
            return null;
          },
  );
}

/// Wraps [child] in [ProviderScope] + [MaterialApp] + [Scaffold].
///
/// [child] is placed as the body of a [Scaffold] so it has a full Material
/// context (theme extensions, localization, media query, etc.).
///
/// Use this for testing individual widgets that expect a scaffold parent.
/// Use [makeTestAppRaw] when the widget IS the scaffold (e.g. a full page).
Widget makeTestApp({
  required Widget child,
  List<Override> overrides = const [],
  ThemeData? theme,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      // Always use the light theme so GameColors/HistoryColors extensions
      // are available in every test without additional setup.
      theme: theme ?? lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: Scaffold(body: child),
    ),
  );
}

/// Same as [makeTestApp] but [child] is used as the [MaterialApp.home]
/// directly (not wrapped in an extra [Scaffold]).
///
/// Use this for full-page widgets that supply their own [Scaffold].
Widget makeTestAppRaw({
  required Widget child,
  List<Override> overrides = const [],
  ThemeData? theme,
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: theme ?? lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    ),
  );
}
