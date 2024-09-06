// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bool_family_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$boolFamilyNotifierHash() =>
    r'7ffa5893b23a1eb63d1b266bd1e9a5d12c09e7c4';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$BoolFamilyNotifier extends BuildlessAutoDisposeNotifier<bool> {
  late final BoolFamilyProviderIDs id;
  late final SharedPreferencesKeys sharedPrefsKey;

  bool build({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  });
}

/// See also [BoolFamilyNotifier].
@ProviderFor(BoolFamilyNotifier)
const boolFamilyNotifierProvider = BoolFamilyNotifierFamily();

/// See also [BoolFamilyNotifier].
class BoolFamilyNotifierFamily extends Family<bool> {
  /// See also [BoolFamilyNotifier].
  const BoolFamilyNotifierFamily();

  /// See also [BoolFamilyNotifier].
  BoolFamilyNotifierProvider call({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) {
    return BoolFamilyNotifierProvider(
      id: id,
      sharedPrefsKey: sharedPrefsKey,
    );
  }

  @override
  BoolFamilyNotifierProvider getProviderOverride(
    covariant BoolFamilyNotifierProvider provider,
  ) {
    return call(
      id: provider.id,
      sharedPrefsKey: provider.sharedPrefsKey,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'boolFamilyNotifierProvider';
}

/// See also [BoolFamilyNotifier].
class BoolFamilyNotifierProvider
    extends AutoDisposeNotifierProviderImpl<BoolFamilyNotifier, bool> {
  /// See also [BoolFamilyNotifier].
  BoolFamilyNotifierProvider({
    required BoolFamilyProviderIDs id,
    required SharedPreferencesKeys sharedPrefsKey,
  }) : this._internal(
          () => BoolFamilyNotifier()
            ..id = id
            ..sharedPrefsKey = sharedPrefsKey,
          from: boolFamilyNotifierProvider,
          name: r'boolFamilyNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$boolFamilyNotifierHash,
          dependencies: BoolFamilyNotifierFamily._dependencies,
          allTransitiveDependencies:
              BoolFamilyNotifierFamily._allTransitiveDependencies,
          id: id,
          sharedPrefsKey: sharedPrefsKey,
        );

  BoolFamilyNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
    required this.sharedPrefsKey,
  }) : super.internal();

  final BoolFamilyProviderIDs id;
  final SharedPreferencesKeys sharedPrefsKey;

  @override
  bool runNotifierBuild(
    covariant BoolFamilyNotifier notifier,
  ) {
    return notifier.build(
      id: id,
      sharedPrefsKey: sharedPrefsKey,
    );
  }

  @override
  Override overrideWith(BoolFamilyNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: BoolFamilyNotifierProvider._internal(
        () => create()
          ..id = id
          ..sharedPrefsKey = sharedPrefsKey,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
        sharedPrefsKey: sharedPrefsKey,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<BoolFamilyNotifier, bool> createElement() {
    return _BoolFamilyNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BoolFamilyNotifierProvider &&
        other.id == id &&
        other.sharedPrefsKey == sharedPrefsKey;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);
    hash = _SystemHash.combine(hash, sharedPrefsKey.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin BoolFamilyNotifierRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `id` of this provider.
  BoolFamilyProviderIDs get id;

  /// The parameter `sharedPrefsKey` of this provider.
  SharedPreferencesKeys get sharedPrefsKey;
}

class _BoolFamilyNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<BoolFamilyNotifier, bool>
    with BoolFamilyNotifierRef {
  _BoolFamilyNotifierProviderElement(super.provider);

  @override
  BoolFamilyProviderIDs get id => (origin as BoolFamilyNotifierProvider).id;
  @override
  SharedPreferencesKeys get sharedPrefsKey =>
      (origin as BoolFamilyNotifierProvider).sharedPrefsKey;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
