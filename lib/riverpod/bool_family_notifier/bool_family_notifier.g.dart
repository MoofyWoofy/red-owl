// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_family_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BoolFamilyNotifier)
final boolFamilyProvider = BoolFamilyNotifierFamily._();

final class BoolFamilyNotifierProvider
    extends $NotifierProvider<BoolFamilyNotifier, bool> {
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
