// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'grid.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Grid {

/// Zero-based column index of the tile that will receive the next key press.
/// Resets to 0 after ENTER or DELETE.
 int get column;/// Zero-based row index of the current guess (0–5).
/// Incremented after each valid guess is submitted.
 int get row;/// All tiles that have been placed so far.
/// Length grows as the player types letters and shrinks on DELETE.
/// A full board has exactly 30 tiles (5 columns × 6 rows).
 List<Tile> get tiles;/// Per-key evaluation status used to colour the on-screen keyboard.
/// Mirrors the QWERTY layout from [keyboardStatus].
 Map<String, LetterStatus> get keyboardStatus;/// True while the tile flip animation should be (re-)started.
/// Set to false once all tiles in the row have animated.
 bool get runFlipAnimation;/// True when the last key pressed was ENTER or DELETE.
/// Suppresses the pop-in animation on the next rebuild.
 bool get isEnterOrDeletePressed;/// Whether the player solved the puzzle in the current session.
 bool get isGameWon;/// Whether the game has ended (either won or all 6 rows used up).
 bool get isGameOver;/// True when the player presses ENTER on a row with fewer than 5 letters.
/// Triggers the shake animation on the current row.
 bool get notEnoughCharacters;/// Whether this board should be persisted to SharedPreferences after each
/// move. The daily game persists (so it survives restarts); the practice
/// board sets this to `false` so it never overwrites the saved daily game.
/// Defaults to `true`, so existing serialized grids deserialize unchanged.
 bool get persistState;
/// Create a copy of Grid
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GridCopyWith<Grid> get copyWith => _$GridCopyWithImpl<Grid>(this as Grid, _$identity);

  /// Serializes this Grid to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Grid&&(identical(other.column, column) || other.column == column)&&(identical(other.row, row) || other.row == row)&&const DeepCollectionEquality().equals(other.tiles, tiles)&&const DeepCollectionEquality().equals(other.keyboardStatus, keyboardStatus)&&(identical(other.runFlipAnimation, runFlipAnimation) || other.runFlipAnimation == runFlipAnimation)&&(identical(other.isEnterOrDeletePressed, isEnterOrDeletePressed) || other.isEnterOrDeletePressed == isEnterOrDeletePressed)&&(identical(other.isGameWon, isGameWon) || other.isGameWon == isGameWon)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.notEnoughCharacters, notEnoughCharacters) || other.notEnoughCharacters == notEnoughCharacters)&&(identical(other.persistState, persistState) || other.persistState == persistState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,column,row,const DeepCollectionEquality().hash(tiles),const DeepCollectionEquality().hash(keyboardStatus),runFlipAnimation,isEnterOrDeletePressed,isGameWon,isGameOver,notEnoughCharacters,persistState);

@override
String toString() {
  return 'Grid(column: $column, row: $row, tiles: $tiles, keyboardStatus: $keyboardStatus, runFlipAnimation: $runFlipAnimation, isEnterOrDeletePressed: $isEnterOrDeletePressed, isGameWon: $isGameWon, isGameOver: $isGameOver, notEnoughCharacters: $notEnoughCharacters, persistState: $persistState)';
}


}

/// @nodoc
abstract mixin class $GridCopyWith<$Res>  {
  factory $GridCopyWith(Grid value, $Res Function(Grid) _then) = _$GridCopyWithImpl;
@useResult
$Res call({
 int column, int row, List<Tile> tiles, Map<String, LetterStatus> keyboardStatus, bool runFlipAnimation, bool isEnterOrDeletePressed, bool isGameWon, bool isGameOver, bool notEnoughCharacters, bool persistState
});




}
/// @nodoc
class _$GridCopyWithImpl<$Res>
    implements $GridCopyWith<$Res> {
  _$GridCopyWithImpl(this._self, this._then);

  final Grid _self;
  final $Res Function(Grid) _then;

/// Create a copy of Grid
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? column = null,Object? row = null,Object? tiles = null,Object? keyboardStatus = null,Object? runFlipAnimation = null,Object? isEnterOrDeletePressed = null,Object? isGameWon = null,Object? isGameOver = null,Object? notEnoughCharacters = null,Object? persistState = null,}) {
  return _then(_self.copyWith(
column: null == column ? _self.column : column // ignore: cast_nullable_to_non_nullable
as int,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,tiles: null == tiles ? _self.tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<Tile>,keyboardStatus: null == keyboardStatus ? _self.keyboardStatus : keyboardStatus // ignore: cast_nullable_to_non_nullable
as Map<String, LetterStatus>,runFlipAnimation: null == runFlipAnimation ? _self.runFlipAnimation : runFlipAnimation // ignore: cast_nullable_to_non_nullable
as bool,isEnterOrDeletePressed: null == isEnterOrDeletePressed ? _self.isEnterOrDeletePressed : isEnterOrDeletePressed // ignore: cast_nullable_to_non_nullable
as bool,isGameWon: null == isGameWon ? _self.isGameWon : isGameWon // ignore: cast_nullable_to_non_nullable
as bool,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,notEnoughCharacters: null == notEnoughCharacters ? _self.notEnoughCharacters : notEnoughCharacters // ignore: cast_nullable_to_non_nullable
as bool,persistState: null == persistState ? _self.persistState : persistState // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Grid].
extension GridPatterns on Grid {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Grid value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Grid() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Grid value)  $default,){
final _that = this;
switch (_that) {
case _Grid():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Grid value)?  $default,){
final _that = this;
switch (_that) {
case _Grid() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int column,  int row,  List<Tile> tiles,  Map<String, LetterStatus> keyboardStatus,  bool runFlipAnimation,  bool isEnterOrDeletePressed,  bool isGameWon,  bool isGameOver,  bool notEnoughCharacters,  bool persistState)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Grid() when $default != null:
return $default(_that.column,_that.row,_that.tiles,_that.keyboardStatus,_that.runFlipAnimation,_that.isEnterOrDeletePressed,_that.isGameWon,_that.isGameOver,_that.notEnoughCharacters,_that.persistState);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int column,  int row,  List<Tile> tiles,  Map<String, LetterStatus> keyboardStatus,  bool runFlipAnimation,  bool isEnterOrDeletePressed,  bool isGameWon,  bool isGameOver,  bool notEnoughCharacters,  bool persistState)  $default,) {final _that = this;
switch (_that) {
case _Grid():
return $default(_that.column,_that.row,_that.tiles,_that.keyboardStatus,_that.runFlipAnimation,_that.isEnterOrDeletePressed,_that.isGameWon,_that.isGameOver,_that.notEnoughCharacters,_that.persistState);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int column,  int row,  List<Tile> tiles,  Map<String, LetterStatus> keyboardStatus,  bool runFlipAnimation,  bool isEnterOrDeletePressed,  bool isGameWon,  bool isGameOver,  bool notEnoughCharacters,  bool persistState)?  $default,) {final _that = this;
switch (_that) {
case _Grid() when $default != null:
return $default(_that.column,_that.row,_that.tiles,_that.keyboardStatus,_that.runFlipAnimation,_that.isEnterOrDeletePressed,_that.isGameWon,_that.isGameOver,_that.notEnoughCharacters,_that.persistState);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Grid implements Grid {
  const _Grid({required this.column, required this.row, required final  List<Tile> tiles, required final  Map<String, LetterStatus> keyboardStatus, required this.runFlipAnimation, required this.isEnterOrDeletePressed, required this.isGameWon, required this.isGameOver, required this.notEnoughCharacters, this.persistState = true}): _tiles = tiles,_keyboardStatus = keyboardStatus;
  factory _Grid.fromJson(Map<String, dynamic> json) => _$GridFromJson(json);

/// Zero-based column index of the tile that will receive the next key press.
/// Resets to 0 after ENTER or DELETE.
@override final  int column;
/// Zero-based row index of the current guess (0–5).
/// Incremented after each valid guess is submitted.
@override final  int row;
/// All tiles that have been placed so far.
/// Length grows as the player types letters and shrinks on DELETE.
/// A full board has exactly 30 tiles (5 columns × 6 rows).
 final  List<Tile> _tiles;
/// All tiles that have been placed so far.
/// Length grows as the player types letters and shrinks on DELETE.
/// A full board has exactly 30 tiles (5 columns × 6 rows).
@override List<Tile> get tiles {
  if (_tiles is EqualUnmodifiableListView) return _tiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tiles);
}

/// Per-key evaluation status used to colour the on-screen keyboard.
/// Mirrors the QWERTY layout from [keyboardStatus].
 final  Map<String, LetterStatus> _keyboardStatus;
/// Per-key evaluation status used to colour the on-screen keyboard.
/// Mirrors the QWERTY layout from [keyboardStatus].
@override Map<String, LetterStatus> get keyboardStatus {
  if (_keyboardStatus is EqualUnmodifiableMapView) return _keyboardStatus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_keyboardStatus);
}

/// True while the tile flip animation should be (re-)started.
/// Set to false once all tiles in the row have animated.
@override final  bool runFlipAnimation;
/// True when the last key pressed was ENTER or DELETE.
/// Suppresses the pop-in animation on the next rebuild.
@override final  bool isEnterOrDeletePressed;
/// Whether the player solved the puzzle in the current session.
@override final  bool isGameWon;
/// Whether the game has ended (either won or all 6 rows used up).
@override final  bool isGameOver;
/// True when the player presses ENTER on a row with fewer than 5 letters.
/// Triggers the shake animation on the current row.
@override final  bool notEnoughCharacters;
/// Whether this board should be persisted to SharedPreferences after each
/// move. The daily game persists (so it survives restarts); the practice
/// board sets this to `false` so it never overwrites the saved daily game.
/// Defaults to `true`, so existing serialized grids deserialize unchanged.
@override@JsonKey() final  bool persistState;

/// Create a copy of Grid
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GridCopyWith<_Grid> get copyWith => __$GridCopyWithImpl<_Grid>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GridToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Grid&&(identical(other.column, column) || other.column == column)&&(identical(other.row, row) || other.row == row)&&const DeepCollectionEquality().equals(other._tiles, _tiles)&&const DeepCollectionEquality().equals(other._keyboardStatus, _keyboardStatus)&&(identical(other.runFlipAnimation, runFlipAnimation) || other.runFlipAnimation == runFlipAnimation)&&(identical(other.isEnterOrDeletePressed, isEnterOrDeletePressed) || other.isEnterOrDeletePressed == isEnterOrDeletePressed)&&(identical(other.isGameWon, isGameWon) || other.isGameWon == isGameWon)&&(identical(other.isGameOver, isGameOver) || other.isGameOver == isGameOver)&&(identical(other.notEnoughCharacters, notEnoughCharacters) || other.notEnoughCharacters == notEnoughCharacters)&&(identical(other.persistState, persistState) || other.persistState == persistState));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,column,row,const DeepCollectionEquality().hash(_tiles),const DeepCollectionEquality().hash(_keyboardStatus),runFlipAnimation,isEnterOrDeletePressed,isGameWon,isGameOver,notEnoughCharacters,persistState);

@override
String toString() {
  return 'Grid(column: $column, row: $row, tiles: $tiles, keyboardStatus: $keyboardStatus, runFlipAnimation: $runFlipAnimation, isEnterOrDeletePressed: $isEnterOrDeletePressed, isGameWon: $isGameWon, isGameOver: $isGameOver, notEnoughCharacters: $notEnoughCharacters, persistState: $persistState)';
}


}

/// @nodoc
abstract mixin class _$GridCopyWith<$Res> implements $GridCopyWith<$Res> {
  factory _$GridCopyWith(_Grid value, $Res Function(_Grid) _then) = __$GridCopyWithImpl;
@override @useResult
$Res call({
 int column, int row, List<Tile> tiles, Map<String, LetterStatus> keyboardStatus, bool runFlipAnimation, bool isEnterOrDeletePressed, bool isGameWon, bool isGameOver, bool notEnoughCharacters, bool persistState
});




}
/// @nodoc
class __$GridCopyWithImpl<$Res>
    implements _$GridCopyWith<$Res> {
  __$GridCopyWithImpl(this._self, this._then);

  final _Grid _self;
  final $Res Function(_Grid) _then;

/// Create a copy of Grid
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? column = null,Object? row = null,Object? tiles = null,Object? keyboardStatus = null,Object? runFlipAnimation = null,Object? isEnterOrDeletePressed = null,Object? isGameWon = null,Object? isGameOver = null,Object? notEnoughCharacters = null,Object? persistState = null,}) {
  return _then(_Grid(
column: null == column ? _self.column : column // ignore: cast_nullable_to_non_nullable
as int,row: null == row ? _self.row : row // ignore: cast_nullable_to_non_nullable
as int,tiles: null == tiles ? _self._tiles : tiles // ignore: cast_nullable_to_non_nullable
as List<Tile>,keyboardStatus: null == keyboardStatus ? _self._keyboardStatus : keyboardStatus // ignore: cast_nullable_to_non_nullable
as Map<String, LetterStatus>,runFlipAnimation: null == runFlipAnimation ? _self.runFlipAnimation : runFlipAnimation // ignore: cast_nullable_to_non_nullable
as bool,isEnterOrDeletePressed: null == isEnterOrDeletePressed ? _self.isEnterOrDeletePressed : isEnterOrDeletePressed // ignore: cast_nullable_to_non_nullable
as bool,isGameWon: null == isGameWon ? _self.isGameWon : isGameWon // ignore: cast_nullable_to_non_nullable
as bool,isGameOver: null == isGameOver ? _self.isGameOver : isGameOver // ignore: cast_nullable_to_non_nullable
as bool,notEnoughCharacters: null == notEnoughCharacters ? _self.notEnoughCharacters : notEnoughCharacters // ignore: cast_nullable_to_non_nullable
as bool,persistState: null == persistState ? _self.persistState : persistState // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
