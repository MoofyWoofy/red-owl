// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grid.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod notifier that owns and mutates the entire game board state.
///
/// On first access [build] rehydrates any in-progress game from
/// SharedPreferences. If the stored game is from a previous day it is
/// archived to the [History] database and a fresh empty grid is returned.
///
/// All user actions funnel through [onKeyboardPressed]:
/// - **Letter key** → adds a tile.
/// - **DELETE** → removes the last tile.
/// - **ENTER** → evaluates the current row, updates tiles and keyboard colors,
///   checks win/loss conditions, persists stats, and writes the history record.

@ProviderFor(Grid)
final gridProvider = GridProvider._();

/// Riverpod notifier that owns and mutates the entire game board state.
///
/// On first access [build] rehydrates any in-progress game from
/// SharedPreferences. If the stored game is from a previous day it is
/// archived to the [History] database and a fresh empty grid is returned.
///
/// All user actions funnel through [onKeyboardPressed]:
/// - **Letter key** → adds a tile.
/// - **DELETE** → removes the last tile.
/// - **ENTER** → evaluates the current row, updates tiles and keyboard colors,
///   checks win/loss conditions, persists stats, and writes the history record.
final class GridProvider extends $NotifierProvider<Grid, models.Grid> {
  /// Riverpod notifier that owns and mutates the entire game board state.
  ///
  /// On first access [build] rehydrates any in-progress game from
  /// SharedPreferences. If the stored game is from a previous day it is
  /// archived to the [History] database and a fresh empty grid is returned.
  ///
  /// All user actions funnel through [onKeyboardPressed]:
  /// - **Letter key** → adds a tile.
  /// - **DELETE** → removes the last tile.
  /// - **ENTER** → evaluates the current row, updates tiles and keyboard colors,
  ///   checks win/loss conditions, persists stats, and writes the history record.
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

String _$gridHash() => r'35f7515a6a8a00f42065e64a657e0b1c72e291a8';

/// Riverpod notifier that owns and mutates the entire game board state.
///
/// On first access [build] rehydrates any in-progress game from
/// SharedPreferences. If the stored game is from a previous day it is
/// archived to the [History] database and a fresh empty grid is returned.
///
/// All user actions funnel through [onKeyboardPressed]:
/// - **Letter key** → adds a tile.
/// - **DELETE** → removes the last tile.
/// - **ENTER** → evaluates the current row, updates tiles and keyboard colors,
///   checks win/loss conditions, persists stats, and writes the history record.

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
