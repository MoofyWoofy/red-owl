// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tile {

/// The uppercase letter displayed in this tile (e.g. `'A'`).
 String get letter;/// Evaluation result assigned after the player submits a guess.
 LetterStatus get status;/// Whether the flip animation has already played for this tile.
/// Once true, the tile always shows its [status] color immediately
/// without re-animating on widget rebuilds.
 bool get hasFlipAnimationPlayed;
/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TileCopyWith<Tile> get copyWith => _$TileCopyWithImpl<Tile>(this as Tile, _$identity);

  /// Serializes this Tile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tile&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasFlipAnimationPlayed, hasFlipAnimationPlayed) || other.hasFlipAnimationPlayed == hasFlipAnimationPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,letter,status,hasFlipAnimationPlayed);

@override
String toString() {
  return 'Tile(letter: $letter, status: $status, hasFlipAnimationPlayed: $hasFlipAnimationPlayed)';
}


}

/// @nodoc
abstract mixin class $TileCopyWith<$Res>  {
  factory $TileCopyWith(Tile value, $Res Function(Tile) _then) = _$TileCopyWithImpl;
@useResult
$Res call({
 String letter, LetterStatus status, bool hasFlipAnimationPlayed
});




}
/// @nodoc
class _$TileCopyWithImpl<$Res>
    implements $TileCopyWith<$Res> {
  _$TileCopyWithImpl(this._self, this._then);

  final Tile _self;
  final $Res Function(Tile) _then;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? letter = null,Object? status = null,Object? hasFlipAnimationPlayed = null,}) {
  return _then(_self.copyWith(
letter: null == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LetterStatus,hasFlipAnimationPlayed: null == hasFlipAnimationPlayed ? _self.hasFlipAnimationPlayed : hasFlipAnimationPlayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Tile].
extension TilePatterns on Tile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tile value)  $default,){
final _that = this;
switch (_that) {
case _Tile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tile value)?  $default,){
final _that = this;
switch (_that) {
case _Tile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String letter,  LetterStatus status,  bool hasFlipAnimationPlayed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tile() when $default != null:
return $default(_that.letter,_that.status,_that.hasFlipAnimationPlayed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String letter,  LetterStatus status,  bool hasFlipAnimationPlayed)  $default,) {final _that = this;
switch (_that) {
case _Tile():
return $default(_that.letter,_that.status,_that.hasFlipAnimationPlayed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String letter,  LetterStatus status,  bool hasFlipAnimationPlayed)?  $default,) {final _that = this;
switch (_that) {
case _Tile() when $default != null:
return $default(_that.letter,_that.status,_that.hasFlipAnimationPlayed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tile implements Tile {
  const _Tile({required this.letter, required this.status, required this.hasFlipAnimationPlayed});
  factory _Tile.fromJson(Map<String, dynamic> json) => _$TileFromJson(json);

/// The uppercase letter displayed in this tile (e.g. `'A'`).
@override final  String letter;
/// Evaluation result assigned after the player submits a guess.
@override final  LetterStatus status;
/// Whether the flip animation has already played for this tile.
/// Once true, the tile always shows its [status] color immediately
/// without re-animating on widget rebuilds.
@override final  bool hasFlipAnimationPlayed;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TileCopyWith<_Tile> get copyWith => __$TileCopyWithImpl<_Tile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tile&&(identical(other.letter, letter) || other.letter == letter)&&(identical(other.status, status) || other.status == status)&&(identical(other.hasFlipAnimationPlayed, hasFlipAnimationPlayed) || other.hasFlipAnimationPlayed == hasFlipAnimationPlayed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,letter,status,hasFlipAnimationPlayed);

@override
String toString() {
  return 'Tile(letter: $letter, status: $status, hasFlipAnimationPlayed: $hasFlipAnimationPlayed)';
}


}

/// @nodoc
abstract mixin class _$TileCopyWith<$Res> implements $TileCopyWith<$Res> {
  factory _$TileCopyWith(_Tile value, $Res Function(_Tile) _then) = __$TileCopyWithImpl;
@override @useResult
$Res call({
 String letter, LetterStatus status, bool hasFlipAnimationPlayed
});




}
/// @nodoc
class __$TileCopyWithImpl<$Res>
    implements _$TileCopyWith<$Res> {
  __$TileCopyWithImpl(this._self, this._then);

  final _Tile _self;
  final $Res Function(_Tile) _then;

/// Create a copy of Tile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? letter = null,Object? status = null,Object? hasFlipAnimationPlayed = null,}) {
  return _then(_Tile(
letter: null == letter ? _self.letter : letter // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as LetterStatus,hasFlipAnimationPlayed: null == hasFlipAnimationPlayed ? _self.hasFlipAnimationPlayed : hasFlipAnimationPlayed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
