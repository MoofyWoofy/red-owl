// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'font_scale_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier holding the user's text-size preference as a scale code.
///
/// `App` (in `main.dart`) watches this and wraps the app in a [MediaQuery]
/// whose `textScaler` uses [fontScaleValueOf], so all text honours the choice.
/// The game tiles use a `FittedBox`, so larger scales never overflow the grid.

@ProviderFor(FontScaleNotifier)
final fontScaleProvider = FontScaleNotifierProvider._();

/// Riverpod notifier holding the user's text-size preference as a scale code.
///
/// `App` (in `main.dart`) watches this and wraps the app in a [MediaQuery]
/// whose `textScaler` uses [fontScaleValueOf], so all text honours the choice.
/// The game tiles use a `FittedBox`, so larger scales never overflow the grid.
final class FontScaleNotifierProvider
    extends $NotifierProvider<FontScaleNotifier, String> {
  /// Riverpod notifier holding the user's text-size preference as a scale code.
  ///
  /// `App` (in `main.dart`) watches this and wraps the app in a [MediaQuery]
  /// whose `textScaler` uses [fontScaleValueOf], so all text honours the choice.
  /// The game tiles use a `FittedBox`, so larger scales never overflow the grid.
  FontScaleNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fontScaleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fontScaleNotifierHash();

  @$internal
  @override
  FontScaleNotifier create() => FontScaleNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$fontScaleNotifierHash() => r'651295f252c1b635d45905af690396a99fb008e1';

/// Riverpod notifier holding the user's text-size preference as a scale code.
///
/// `App` (in `main.dart`) watches this and wraps the app in a [MediaQuery]
/// whose `textScaler` uses [fontScaleValueOf], so all text honours the choice.
/// The game tiles use a `FittedBox`, so larger scales never overflow the grid.

abstract class _$FontScaleNotifier extends $Notifier<String> {
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
