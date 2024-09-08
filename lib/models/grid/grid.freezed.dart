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

Grid _$GridFromJson(Map<String, dynamic> json) {
  return _Grid.fromJson(json);
}

/// @nodoc
mixin _$Grid {
  /// current grid column.
  int get column => throw _privateConstructorUsedError;

  /// current grid row.
  int get row => throw _privateConstructorUsedError;

  /// List of all tiles in grid.
  List<Tile> get tiles => throw _privateConstructorUsedError;

  /// Keyboard status, green/yellow etc.
  Map<String, LetterStatus> get keyboardStatus =>
      throw _privateConstructorUsedError;

  /// Run flip animation (when checking word).
  bool get runFlipAnimation => throw _privateConstructorUsedError;

  /// Check if letter pressed is ENTER or DELETE.
  bool get isEnterOrDeletePressed => throw _privateConstructorUsedError;

  /// Did player win the game?
  bool get isGameWon => throw _privateConstructorUsedError;

  /// Is the game over?
  bool get isGameOver => throw _privateConstructorUsedError;

  /// Does the row have 5 character to check word?
  bool get notEnoughCharacters => throw _privateConstructorUsedError;

  /// Serializes this Grid to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

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
      Map<String, LetterStatus> keyboardStatus,
      bool runFlipAnimation,
      bool isEnterOrDeletePressed,
      bool isGameWon,
      bool isGameOver,
      bool notEnoughCharacters});
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
    Object? runFlipAnimation = null,
    Object? isEnterOrDeletePressed = null,
    Object? isGameWon = null,
    Object? isGameOver = null,
    Object? notEnoughCharacters = null,
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
      runFlipAnimation: null == runFlipAnimation
          ? _value.runFlipAnimation
          : runFlipAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnterOrDeletePressed: null == isEnterOrDeletePressed
          ? _value.isEnterOrDeletePressed
          : isEnterOrDeletePressed // ignore: cast_nullable_to_non_nullable
              as bool,
      isGameWon: null == isGameWon
          ? _value.isGameWon
          : isGameWon // ignore: cast_nullable_to_non_nullable
              as bool,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      notEnoughCharacters: null == notEnoughCharacters
          ? _value.notEnoughCharacters
          : notEnoughCharacters // ignore: cast_nullable_to_non_nullable
              as bool,
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
      Map<String, LetterStatus> keyboardStatus,
      bool runFlipAnimation,
      bool isEnterOrDeletePressed,
      bool isGameWon,
      bool isGameOver,
      bool notEnoughCharacters});
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
    Object? runFlipAnimation = null,
    Object? isEnterOrDeletePressed = null,
    Object? isGameWon = null,
    Object? isGameOver = null,
    Object? notEnoughCharacters = null,
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
          ? _value._tiles
          : tiles // ignore: cast_nullable_to_non_nullable
              as List<Tile>,
      keyboardStatus: null == keyboardStatus
          ? _value._keyboardStatus
          : keyboardStatus // ignore: cast_nullable_to_non_nullable
              as Map<String, LetterStatus>,
      runFlipAnimation: null == runFlipAnimation
          ? _value.runFlipAnimation
          : runFlipAnimation // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnterOrDeletePressed: null == isEnterOrDeletePressed
          ? _value.isEnterOrDeletePressed
          : isEnterOrDeletePressed // ignore: cast_nullable_to_non_nullable
              as bool,
      isGameWon: null == isGameWon
          ? _value.isGameWon
          : isGameWon // ignore: cast_nullable_to_non_nullable
              as bool,
      isGameOver: null == isGameOver
          ? _value.isGameOver
          : isGameOver // ignore: cast_nullable_to_non_nullable
              as bool,
      notEnoughCharacters: null == notEnoughCharacters
          ? _value.notEnoughCharacters
          : notEnoughCharacters // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GridImpl implements _Grid {
  const _$GridImpl(
      {required this.column,
      required this.row,
      required final List<Tile> tiles,
      required final Map<String, LetterStatus> keyboardStatus,
      required this.runFlipAnimation,
      required this.isEnterOrDeletePressed,
      required this.isGameWon,
      required this.isGameOver,
      required this.notEnoughCharacters})
      : _tiles = tiles,
        _keyboardStatus = keyboardStatus;

  factory _$GridImpl.fromJson(Map<String, dynamic> json) =>
      _$$GridImplFromJson(json);

  /// current grid column.
  @override
  final int column;

  /// current grid row.
  @override
  final int row;

  /// List of all tiles in grid.
  final List<Tile> _tiles;

  /// List of all tiles in grid.
  @override
  List<Tile> get tiles {
    if (_tiles is EqualUnmodifiableListView) return _tiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tiles);
  }

  /// Keyboard status, green/yellow etc.
  final Map<String, LetterStatus> _keyboardStatus;

  /// Keyboard status, green/yellow etc.
  @override
  Map<String, LetterStatus> get keyboardStatus {
    if (_keyboardStatus is EqualUnmodifiableMapView) return _keyboardStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_keyboardStatus);
  }

  /// Run flip animation (when checking word).
  @override
  final bool runFlipAnimation;

  /// Check if letter pressed is ENTER or DELETE.
  @override
  final bool isEnterOrDeletePressed;

  /// Did player win the game?
  @override
  final bool isGameWon;

  /// Is the game over?
  @override
  final bool isGameOver;

  /// Does the row have 5 character to check word?
  @override
  final bool notEnoughCharacters;

  @override
  String toString() {
    return 'Grid(column: $column, row: $row, tiles: $tiles, keyboardStatus: $keyboardStatus, runFlipAnimation: $runFlipAnimation, isEnterOrDeletePressed: $isEnterOrDeletePressed, isGameWon: $isGameWon, isGameOver: $isGameOver, notEnoughCharacters: $notEnoughCharacters)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GridImpl &&
            (identical(other.column, column) || other.column == column) &&
            (identical(other.row, row) || other.row == row) &&
            const DeepCollectionEquality().equals(other._tiles, _tiles) &&
            const DeepCollectionEquality()
                .equals(other._keyboardStatus, _keyboardStatus) &&
            (identical(other.runFlipAnimation, runFlipAnimation) ||
                other.runFlipAnimation == runFlipAnimation) &&
            (identical(other.isEnterOrDeletePressed, isEnterOrDeletePressed) ||
                other.isEnterOrDeletePressed == isEnterOrDeletePressed) &&
            (identical(other.isGameWon, isGameWon) ||
                other.isGameWon == isGameWon) &&
            (identical(other.isGameOver, isGameOver) ||
                other.isGameOver == isGameOver) &&
            (identical(other.notEnoughCharacters, notEnoughCharacters) ||
                other.notEnoughCharacters == notEnoughCharacters));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      column,
      row,
      const DeepCollectionEquality().hash(_tiles),
      const DeepCollectionEquality().hash(_keyboardStatus),
      runFlipAnimation,
      isEnterOrDeletePressed,
      isGameWon,
      isGameOver,
      notEnoughCharacters);

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GridImplCopyWith<_$GridImpl> get copyWith =>
      __$$GridImplCopyWithImpl<_$GridImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GridImplToJson(
      this,
    );
  }
}

abstract class _Grid implements Grid {
  const factory _Grid(
      {required final int column,
      required final int row,
      required final List<Tile> tiles,
      required final Map<String, LetterStatus> keyboardStatus,
      required final bool runFlipAnimation,
      required final bool isEnterOrDeletePressed,
      required final bool isGameWon,
      required final bool isGameOver,
      required final bool notEnoughCharacters}) = _$GridImpl;

  factory _Grid.fromJson(Map<String, dynamic> json) = _$GridImpl.fromJson;

  /// current grid column.
  @override
  int get column;

  /// current grid row.
  @override
  int get row;

  /// List of all tiles in grid.
  @override
  List<Tile> get tiles;

  /// Keyboard status, green/yellow etc.
  @override
  Map<String, LetterStatus> get keyboardStatus;

  /// Run flip animation (when checking word).
  @override
  bool get runFlipAnimation;

  /// Check if letter pressed is ENTER or DELETE.
  @override
  bool get isEnterOrDeletePressed;

  /// Did player win the game?
  @override
  bool get isGameWon;

  /// Is the game over?
  @override
  bool get isGameOver;

  /// Does the row have 5 character to check word?
  @override
  bool get notEnoughCharacters;

  /// Create a copy of Grid
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GridImplCopyWith<_$GridImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
