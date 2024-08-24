// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Grid {
  int get column => throw _privateConstructorUsedError;
  int get row => throw _privateConstructorUsedError;
  List<Tile> get tiles => throw _privateConstructorUsedError;
  Map<String, LetterStatus> get keyboardStatus =>
      throw _privateConstructorUsedError;

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GridCopyWith<Grid> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GridCopyWith<$Res> {
  factory $GridCopyWith(Grid value, $Res Function(Grid) then) =
      _$GridCopyWithImpl<$Res, Grid>;
  @useResult
  $Res call(
      {int column,
      int row,
      List<Tile> tiles,
      Map<String, LetterStatus> keyboardStatus});
}

/// @nodoc
class _$GridCopyWithImpl<$Res, $Val extends Grid>
    implements $GridCopyWith<$Res> {
  _$GridCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? column = null,
    Object? row = null,
    Object? tiles = null,
    Object? keyboardStatus = null,
  }) {
    return _then(_value.copyWith(
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      tiles: null == tiles
          ? _value.tiles
          : tiles // ignore: cast_nullable_to_non_nullable
              as List<Tile>,
      keyboardStatus: null == keyboardStatus
          ? _value.keyboardStatus
          : keyboardStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, LetterStatus>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GridImplCopyWith<$Res> implements $GridCopyWith<$Res> {
  factory _$$GridImplCopyWith(
          _$GridImpl value, $Res Function(_$GridImpl) then) =
      __$$GridImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int column,
      int row,
      List<Tile> tiles,
      Map<String, LetterStatus> keyboardStatus});
}

/// @nodoc
class __$$GridImplCopyWithImpl<$Res>
    extends _$GridCopyWithImpl<$Res, _$GridImpl>
    implements _$$GridImplCopyWith<$Res> {
  __$$GridImplCopyWithImpl(_$GridImpl _value, $Res Function(_$GridImpl) _then)
      : super(_value, _then);

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? column = null,
    Object? row = null,
    Object? tiles = null,
    Object? keyboardStatus = null,
  }) {
    return _then(_$GridImpl(
      column: null == column
          ? _value.column
          : column // ignore: cast_nullable_to_non_nullable
              as int,
      row: null == row
          ? _value.row
          : row // ignore: cast_nullable_to_non_nullable
              as int,
      tiles: null == tiles
          ? _value.tiles
          : tiles // ignore: cast_nullable_to_non_nullable
              as List<Tile>,
      keyboardStatus: null == keyboardStatus
          ? _value.keyboardStatus
          : keyboardStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, LetterStatus>,
    ));
  }
}

/// @nodoc

class _$GridImpl implements _Grid {
  const _$GridImpl(
      {required this.column,
      required this.row,
      required this.tiles,
      required this.keyboardStatus});

  @override
  final int column;
  @override
  final int row;
  @override
  final List<Tile> tiles;
  @override
  final Map<String, LetterStatus> keyboardStatus;

  @override
  String toString() {
    return 'Grid(column: $column, row: $row, tiles: $tiles, keyboardStatus: $keyboardStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GridImpl &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.row, row) || other.row == row) &&
            const DeepCollectionEquality().equals(other.tiles, tiles) &&
            const DeepCollectionEquality()
                .equals(other.keyboardStatus, keyboardStatus));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      column,
      row,
      const DeepCollectionEquality().hash(tiles),
      const DeepCollectionEquality().hash(keyboardStatus));

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GridImplCopyWith<_$GridImpl> get copyWith =>
      __$$GridImplCopyWithImpl<_$GridImpl>(this, _$identity);
}

abstract class _Grid implements Grid {
  const factory _Grid(
      {required final int column,
      required final int row,
      required final List<Tile> tiles,
      required final Map<String, LetterStatus> keyboardStatus}) = _$GridImpl;

  @override
  int get column;
  @override
  int get row;
  @override
  List<Tile> get tiles;
  @override
  Map<String, LetterStatus> get keyboardStatus;

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GridImplCopyWith<_$GridImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
