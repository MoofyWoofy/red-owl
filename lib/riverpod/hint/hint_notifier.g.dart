// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hint_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Tracks whether today's once-per-day hint is still available.
///
/// The daily game offers a single hint per puzzle. Usage is recorded as the
/// current date in [SharedPreferencesKeys.hintUsedDate]; the hint becomes
/// available again automatically once the date rolls over to a new day.

@ProviderFor(HintNotifier)
final hintProvider = HintNotifierProvider._();

/// Tracks whether today's once-per-day hint is still available.
///
/// The daily game offers a single hint per puzzle. Usage is recorded as the
/// current date in [SharedPreferencesKeys.hintUsedDate]; the hint becomes
/// available again automatically once the date rolls over to a new day.
final class HintNotifierProvider extends $NotifierProvider<HintNotifier, bool> {
  /// Tracks whether today's once-per-day hint is still available.
  ///
  /// The daily game offers a single hint per puzzle. Usage is recorded as the
  /// current date in [SharedPreferencesKeys.hintUsedDate]; the hint becomes
  /// available again automatically once the date rolls over to a new day.
  HintNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hintNotifierHash();

  @$internal
  @override
  HintNotifier create() => HintNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hintNotifierHash() => r'c6ddc76e0361d046d61d787ec74c34e2fe9f5638';

/// Tracks whether today's once-per-day hint is still available.
///
/// The daily game offers a single hint per puzzle. Usage is recorded as the
/// current date in [SharedPreferencesKeys.hintUsedDate]; the hint becomes
/// available again automatically once the date rolls over to a new day.

abstract class _$HintNotifier extends $Notifier<bool> {
  bool build();
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
    element.handleCreate(ref, build);
  }
}
