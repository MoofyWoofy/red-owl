// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Grid)
final gridProvider = GridProvider._();

final class GridProvider extends $NotifierProvider<Grid, models.Grid> {
  GridProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'gridProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$gridHash();

  @$internal
  @override
  Grid create() => Grid();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(models.Grid value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<models.Grid>(value),
    );
  }
}

String _$gridHash() => r'5d27f1c1fe8b0c0b076c1a4bbf8631a009f4a27f';

abstract class _$Grid extends $Notifier<models.Grid> {
  models.Grid build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<models.Grid, models.Grid>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<models.Grid, models.Grid>,
              models.Grid,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
