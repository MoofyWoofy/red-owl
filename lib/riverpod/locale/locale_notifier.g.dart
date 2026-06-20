// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier holding the app's UI [Locale] override.
///
/// A `null` value means "use the system locale" (no explicit override), which
/// lets [MaterialApp] fall back to the device language. A non-null [Locale]
/// forces the UI into that language regardless of the device setting.
///
/// The choice is persisted under [SharedPreferencesKeys.localeCode] so it
/// survives restarts. `App` (in `main.dart`) watches this provider and passes
/// the value to `MaterialApp.locale`.

@ProviderFor(LocaleNotifier)
final localeProvider = LocaleNotifierProvider._();

/// Riverpod notifier holding the app's UI [Locale] override.
///
/// A `null` value means "use the system locale" (no explicit override), which
/// lets [MaterialApp] fall back to the device language. A non-null [Locale]
/// forces the UI into that language regardless of the device setting.
///
/// The choice is persisted under [SharedPreferencesKeys.localeCode] so it
/// survives restarts. `App` (in `main.dart`) watches this provider and passes
/// the value to `MaterialApp.locale`.
final class LocaleNotifierProvider
    extends $NotifierProvider<LocaleNotifier, Locale?> {
  /// Riverpod notifier holding the app's UI [Locale] override.
  ///
  /// A `null` value means "use the system locale" (no explicit override), which
  /// lets [MaterialApp] fall back to the device language. A non-null [Locale]
  /// forces the UI into that language regardless of the device setting.
  ///
  /// The choice is persisted under [SharedPreferencesKeys.localeCode] so it
  /// survives restarts. `App` (in `main.dart`) watches this provider and passes
  /// the value to `MaterialApp.locale`.
  LocaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localeNotifierHash();

  @$internal
  @override
  LocaleNotifier create() => LocaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Locale? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Locale?>(value),
    );
  }
}

String _$localeNotifierHash() => r'e77c77d80ccd28bdd1688cc0775e285a30d3668a';

/// Riverpod notifier holding the app's UI [Locale] override.
///
/// A `null` value means "use the system locale" (no explicit override), which
/// lets [MaterialApp] fall back to the device language. A non-null [Locale]
/// forces the UI into that language regardless of the device setting.
///
/// The choice is persisted under [SharedPreferencesKeys.localeCode] so it
/// survives restarts. `App` (in `main.dart`) watches this provider and passes
/// the value to `MaterialApp.locale`.

abstract class _$LocaleNotifier extends $Notifier<Locale?> {
  Locale? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Locale?, Locale?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Locale?, Locale?>,
              Locale?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
