// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_family_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod family notifier for boolean settings backed by SharedPreferences.
///
/// A single notifier class handles any number of boolean toggles by taking
/// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
/// family parameters. This avoids duplicating notifier code for every toggle.
///
/// On first access the [build] method reads the persisted value and returns
/// a sensible default if none is stored. [updateBoolean] persists the new
/// value and updates the Riverpod state so the UI rebuilds reactively.

@ProviderFor(BoolFamilyNotifier)
final boolFamilyProvider = BoolFamilyNotifierFamily._();

/// Riverpod family notifier for boolean settings backed by SharedPreferences.
///
/// A single notifier class handles any number of boolean toggles by taking
/// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
/// family parameters. This avoids duplicating notifier code for every toggle.
///
/// On first access the [build] method reads the persisted value and returns
/// a sensible default if none is stored. [updateBoolean] persists the new
/// value and updates the Riverpod state so the UI rebuilds reactively.
final class BoolFamilyNotifierProvider
    extends $NotifierProvider<BoolFamilyNotifier, bool> {
  /// Riverpod family notifier for boolean settings backed by SharedPreferences.
  ///
  /// A single notifier class handles any number of boolean toggles by taking
  /// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
  /// family parameters. This avoids duplicating notifier code for every toggle.
  ///
  /// On first access the [build] method reads the persisted value and returns
  /// a sensible default if none is stored. [updateBoolean] persists the new
  /// value and updates the Riverpod state so the UI rebuilds reactively.
  BoolFamilyNotifierProvider._({
    required BoolFamilyNotifierFamily super.from,
    required ({BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey})
    super.argument,
  }) : super(
         retry: null,
         name: r'boolFamilyProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$boolFamilyNotifierHash();

  @override
  String toString() {
    return r'boolFamilyProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  BoolFamilyNotifier create() => BoolFamilyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is BoolFamilyNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$boolFamilyNotifierHash() =>
    r'd77308a8283feef24263eae722bed7ec6496eb86';

/// Riverpod family notifier for boolean settings backed by SharedPreferences.
///
/// A single notifier class handles any number of boolean toggles by taking
/// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
/// family parameters. This avoids duplicating notifier code for every toggle.
///
/// On first access the [build] method reads the persisted value and returns
/// a sensible default if none is stored. [updateBoolean] persists the new
/// value and updates the Riverpod state so the UI rebuilds reactively.

final class BoolFamilyNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          BoolFamilyNotifier,
          bool,
          bool,
          bool,
          ({BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey})
        > {
  BoolFamilyNotifierFamily._()
    : super(
        retry: null,
        name: r'boolFamilyProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Riverpod family notifier for boolean settings backed by SharedPreferences.
  ///
  /// A single notifier class handles any number of boolean toggles by taking
  /// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
  /// family parameters. This avoids duplicating notifier code for every toggle.
  ///
  /// On first access the [build] method reads the persisted value and returns
  /// a sensible default if none is stored. [updateBoolean] persists the new
  /// value and updates the Riverpod state so the UI rebuilds reactively.

  BoolFamilyNotifierProvider call({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) => BoolFamilyNotifierProvider._(
    argument: (id: id, sharedPrefsKey: sharedPrefsKey),
    from: this,
  );

  @override
  String toString() => r'boolFamilyProvider';
}

/// Riverpod family notifier for boolean settings backed by SharedPreferences.
///
/// A single notifier class handles any number of boolean toggles by taking
/// [id] (a stable [BoolFamilyProviderIDs] value) and [sharedPrefsKey] as
/// family parameters. This avoids duplicating notifier code for every toggle.
///
/// On first access the [build] method reads the persisted value and returns
/// a sensible default if none is stored. [updateBoolean] persists the new
/// value and updates the Riverpod state so the UI rebuilds reactively.

abstract class _$BoolFamilyNotifier extends $Notifier<bool> {
  late final _$args =
      ref.$arg
          as ({BoolFamilyProviderIDs id, SharedPreferencesKeys sharedPrefsKey});
  BoolFamilyProviderIDs get id => _$args.id;
  SharedPreferencesKeys get sharedPrefsKey => _$args.sharedPrefsKey;

  bool build({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(
      ref,
      () => build(id: _$args.id, sharedPrefsKey: _$args.sharedPrefsKey),
    );
  }
}
