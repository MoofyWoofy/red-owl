// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'motion_speed_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier holding the user's animation-speed preference.
///
/// `App` (in `main.dart`) watches this together with the system
/// "remove animations" accessibility flag and assigns the resulting factor to
/// the global `timeDilation`, so every [AnimationController]-driven animation
/// (tile flips, shakes, page transitions) is sped up, slowed down, or snapped.

@ProviderFor(MotionSpeedNotifier)
final motionSpeedProvider = MotionSpeedNotifierProvider._();

/// Riverpod notifier holding the user's animation-speed preference.
///
/// `App` (in `main.dart`) watches this together with the system
/// "remove animations" accessibility flag and assigns the resulting factor to
/// the global `timeDilation`, so every [AnimationController]-driven animation
/// (tile flips, shakes, page transitions) is sped up, slowed down, or snapped.
final class MotionSpeedNotifierProvider
    extends $NotifierProvider<MotionSpeedNotifier, String> {
  /// Riverpod notifier holding the user's animation-speed preference.
  ///
  /// `App` (in `main.dart`) watches this together with the system
  /// "remove animations" accessibility flag and assigns the resulting factor to
  /// the global `timeDilation`, so every [AnimationController]-driven animation
  /// (tile flips, shakes, page transitions) is sped up, slowed down, or snapped.
  MotionSpeedNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'motionSpeedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$motionSpeedNotifierHash();

  @$internal
  @override
  MotionSpeedNotifier create() => MotionSpeedNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$motionSpeedNotifierHash() =>
    r'ae4a40f798f0b26e29089e9dedc34a0cb89c592d';

/// Riverpod notifier holding the user's animation-speed preference.
///
/// `App` (in `main.dart`) watches this together with the system
/// "remove animations" accessibility flag and assigns the resulting factor to
/// the global `timeDilation`, so every [AnimationController]-driven animation
/// (tile flips, shakes, page transitions) is sped up, slowed down, or snapped.

abstract class _$MotionSpeedNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
