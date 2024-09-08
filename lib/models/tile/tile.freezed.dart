// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Tile _$TileFromJson(Map<String, dynamic> json) {
  return _Tile.fromJson(json);
}

/// @nodoc
mixin _$Tile {
  /// Letter
  String get letter => throw _privateConstructorUsedError;

  /// Tile status
  LetterStatus get status => throw _privateConstructorUsedError;

  /// did tile play Flip animation before
  bool get hasFlipAnimationPlayed => throw _privateConstructorUsedError;

  /// Serializes this Tile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Tile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TileCopyWith<Tile> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TileCopyWith<$Res> {
  factory $TileCopyWith(Tile value, $Res Function(Tile) then) =
      _$TileCopyWithImpl<$Res, Tile>;
  @useResult
  $Res call({String letter, LetterStatus status, bool hasFlipAnimationPlayed});
}

/// @nodoc
class _$TileCopyWithImpl<$Res, $Val extends Tile>
    implements $TileCopyWith<$Res> {
  _$TileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Tile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? letter = null,
    Object? status = null,
    Object? hasFlipAnimationPlayed = null,
  }) {
    return _then(_value.copyWith(
      letter: null == letter
          ? _value.letter
          : letter // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LetterStatus,
      hasFlipAnimationPlayed: null == hasFlipAnimationPlayed
          ? _value.hasFlipAnimationPlayed
          : hasFlipAnimationPlayed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TileImplCopyWith<$Res> implements $TileCopyWith<$Res> {
  factory _$$TileImplCopyWith(
          _$TileImpl value, $Res Function(_$TileImpl) then) =
      __$$TileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String letter, LetterStatus status, bool hasFlipAnimationPlayed});
}

/// @nodoc
class __$$TileImplCopyWithImpl<$Res>
    extends _$TileCopyWithImpl<$Res, _$TileImpl>
    implements _$$TileImplCopyWith<$Res> {
  __$$TileImplCopyWithImpl(_$TileImpl _value, $Res Function(_$TileImpl) _then)
      : super(_value, _then);

  /// Create a copy of Tile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? letter = null,
    Object? status = null,
    Object? hasFlipAnimationPlayed = null,
  }) {
    return _then(_$TileImpl(
      letter: null == letter
          ? _value.letter
          : letter // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as LetterStatus,
      hasFlipAnimationPlayed: null == hasFlipAnimationPlayed
          ? _value.hasFlipAnimationPlayed
          : hasFlipAnimationPlayed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TileImpl implements _Tile {
  const _$TileImpl(
      {required this.letter,
      required this.status,
      required this.hasFlipAnimationPlayed});

  factory _$TileImpl.fromJson(Map<String, dynamic> json) =>
      _$$TileImplFromJson(json);

  /// Letter
  @override
  final String letter;

  /// Tile status
  @override
  final LetterStatus status;

  /// did tile play Flip animation before
  @override
  final bool hasFlipAnimationPlayed;

  @override
  String toString() {
    return 'Tile(letter: $letter, status: $status, hasFlipAnimationPlayed: $hasFlipAnimationPlayed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TileImpl &&
            (identical(other.letter, letter) || other.letter == letter) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hasFlipAnimationPlayed, hasFlipAnimationPlayed) ||
                other.hasFlipAnimationPlayed == hasFlipAnimationPlayed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, letter, status, hasFlipAnimationPlayed);

  /// Create a copy of Tile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TileImplCopyWith<_$TileImpl> get copyWith =>
      __$$TileImplCopyWithImpl<_$TileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TileImplToJson(
      this,
    );
  }
}

abstract class _Tile implements Tile {
  const factory _Tile(
      {required final String letter,
      required final LetterStatus status,
      required final bool hasFlipAnimationPlayed}) = _$TileImpl;

  factory _Tile.fromJson(Map<String, dynamic> json) = _$TileImpl.fromJson;

  /// Letter
  @override
  String get letter;

  /// Tile status
  @override
  LetterStatus get status;

  /// did tile play Flip animation before
  @override
  bool get hasFlipAnimationPlayed;

  /// Create a copy of Tile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TileImplCopyWith<_$TileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
