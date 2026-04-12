import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

/// Fake [PathProviderPlatform] that returns a temporary directory.
class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.directory);
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

/// Fake SharedPreferencesAsync platform backed by in-memory storage.
base class FakeSharedPreferencesAsync
    extends SharedPreferencesAsyncPlatform {
  FakeSharedPreferencesAsync([Map<String, Object> initialData = const {}])
      : backend = InMemorySharedPreferencesAsync.withData(initialData);
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

/// Sets up both the legacy and async SharedPreferences platforms for testing.
void setSharedPreferencesMock([Map<String, Object> initialValues = const {}]) {
  SharedPreferences.setMockInitialValues(initialValues);
  SharedPreferencesAsyncPlatform.instance =
      FakeSharedPreferencesAsync(initialValues);
}

/// Installs a [FakePathProvider] backed by a fresh temporary directory.
/// Returns the directory so callers can write fixture files into it.
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

/// Mocks the asset bundle so rootBundle.loadString('assets/word_list.txt')
/// returns [wordList] joined by newlines.
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

/// Wraps [child] in ProviderScope + MaterialApp with localization.
/// Uses [lightTheme] by default so GameColors/HistoryColors theme
/// extensions are always available.
Widget makeTestApp({
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
      home: Scaffold(body: child),
    ),
  );
}

/// Same as [makeTestApp] but the child IS the home Scaffold, not wrapped.
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
