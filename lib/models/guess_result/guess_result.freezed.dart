// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guess_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

GuessResult _$GuessResultFromJson(Map<String, dynamic> json) {
  return _GuessResult.fromJson(json);
}

/// @nodoc
mixin _$GuessResult {
  String get guess => throw _privateConstructorUsedError;
  @JsonKey(name: "is_correct")
  bool get isCorrect => throw _privateConstructorUsedError;
  @JsonKey(name: "is_word_in_list")
  bool get isWordInList => throw _privateConstructorUsedError;
  @JsonKey(name: "character_info")
  List<CharacterInfo>? get characterInfo => throw _privateConstructorUsedError;

  /// Serializes this GuessResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GuessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GuessResultCopyWith<GuessResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GuessResultCopyWith<$Res> {
  factory $GuessResultCopyWith(
          GuessResult value, $Res Function(GuessResult) then) =
      _$GuessResultCopyWithImpl<$Res, GuessResult>;
  @useResult
  $Res call(
      {String guess,
      @JsonKey(name: "is_correct") bool isCorrect,
      @JsonKey(name: "is_word_in_list") bool isWordInList,
      @JsonKey(name: "character_info") List<CharacterInfo>? characterInfo});
}

/// @nodoc
class _$GuessResultCopyWithImpl<$Res, $Val extends GuessResult>
    implements $GuessResultCopyWith<$Res> {
  _$GuessResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GuessResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guess = null,
    Object? isCorrect = null,
    Object? isWordInList = null,
    Object? characterInfo = freezed,
  }) {
    return _then(_value.copyWith(
      guess: null == guess
          ? _value.guess
          : guess // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isWordInList: null == isWordInList
          ? _value.isWordInList
          : isWordInList // ignore: cast_nullable_to_non_nullable
              as bool,
      characterInfo: freezed == characterInfo
          ? _value.characterInfo
          : characterInfo // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GuessResultImplCopyWith<$Res>
    implements $GuessResultCopyWith<$Res> {
  factory _$$GuessResultImplCopyWith(
          _$GuessResultImpl value, $Res Function(_$GuessResultImpl) then) =
      __$$GuessResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String guess,
      @JsonKey(name: "is_correct") bool isCorrect,
      @JsonKey(name: "is_word_in_list") bool isWordInList,
      @JsonKey(name: "character_info") List<CharacterInfo>? characterInfo});
}

/// @nodoc
class __$$GuessResultImplCopyWithImpl<$Res>
    extends _$GuessResultCopyWithImpl<$Res, _$GuessResultImpl>
    implements _$$GuessResultImplCopyWith<$Res> {
  __$$GuessResultImplCopyWithImpl(
      _$GuessResultImpl _value, $Res Function(_$GuessResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of GuessResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guess = null,
    Object? isCorrect = null,
    Object? isWordInList = null,
    Object? characterInfo = freezed,
  }) {
    return _then(_$GuessResultImpl(
      guess: null == guess
          ? _value.guess
          : guess // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      isWordInList: null == isWordInList
          ? _value.isWordInList
          : isWordInList // ignore: cast_nullable_to_non_nullable
              as bool,
      characterInfo: freezed == characterInfo
          ? _value._characterInfo
          : characterInfo // ignore: cast_nullable_to_non_nullable
              as List<CharacterInfo>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GuessResultImpl implements _GuessResult {
  const _$GuessResultImpl(
      {required this.guess,
      @JsonKey(name: "is_correct") required this.isCorrect,
      @JsonKey(name: "is_word_in_list") required this.isWordInList,
      @JsonKey(name: "character_info")
      required final List<CharacterInfo>? characterInfo})
      : _characterInfo = characterInfo;

  factory _$GuessResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$GuessResultImplFromJson(json);

  @override
  final String guess;
  @override
  @JsonKey(name: "is_correct")
  final bool isCorrect;
  @override
  @JsonKey(name: "is_word_in_list")
  final bool isWordInList;
  final List<CharacterInfo>? _characterInfo;
  @override
  @JsonKey(name: "character_info")
  List<CharacterInfo>? get characterInfo {
    final value = _characterInfo;
    if (value == null) return null;
    if (_characterInfo is EqualUnmodifiableListView) return _characterInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'GuessResult(guess: $guess, isCorrect: $isCorrect, isWordInList: $isWordInList, characterInfo: $characterInfo)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GuessResultImpl &&
            (identical(other.guess, guess) || other.guess == guess) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.isWordInList, isWordInList) ||
                other.isWordInList == isWordInList) &&
            const DeepCollectionEquality()
                .equals(other._characterInfo, _characterInfo));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, guess, isCorrect, isWordInList,
      const DeepCollectionEquality().hash(_characterInfo));

  /// Create a copy of GuessResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GuessResultImplCopyWith<_$GuessResultImpl> get copyWith =>
      __$$GuessResultImplCopyWithImpl<_$GuessResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GuessResultImplToJson(
      this,
    );
  }
}

abstract class _GuessResult implements GuessResult {
  const factory _GuessResult(
      {required final String guess,
      @JsonKey(name: "is_correct") required final bool isCorrect,
      @JsonKey(name: "is_word_in_list") required final bool isWordInList,
      @JsonKey(name: "character_info")
      required final List<CharacterInfo>? characterInfo}) = _$GuessResultImpl;

  factory _GuessResult.fromJson(Map<String, dynamic> json) =
      _$GuessResultImpl.fromJson;

  @override
  String get guess;
  @override
  @JsonKey(name: "is_correct")
  bool get isCorrect;
  @override
  @JsonKey(name: "is_word_in_list")
  bool get isWordInList;
  @override
  @JsonKey(name: "character_info")
  List<CharacterInfo>? get characterInfo;

  /// Create a copy of GuessResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GuessResultImplCopyWith<_$GuessResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CharacterInfo _$CharacterInfoFromJson(Map<String, dynamic> json) {
  return _CharacterInfo.fromJson(json);
}

/// @nodoc
mixin _$CharacterInfo {
  String get char => throw _privateConstructorUsedError;
  CharacterScoring get scoring => throw _privateConstructorUsedError;

  /// Serializes this CharacterInfo to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterInfoCopyWith<CharacterInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterInfoCopyWith<$Res> {
  factory $CharacterInfoCopyWith(
          CharacterInfo value, $Res Function(CharacterInfo) then) =
      _$CharacterInfoCopyWithImpl<$Res, CharacterInfo>;
  @useResult
  $Res call({String char, CharacterScoring scoring});

  $CharacterScoringCopyWith<$Res> get scoring;
}

/// @nodoc
class _$CharacterInfoCopyWithImpl<$Res, $Val extends CharacterInfo>
    implements $CharacterInfoCopyWith<$Res> {
  _$CharacterInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? char = null,
    Object? scoring = null,
  }) {
    return _then(_value.copyWith(
      char: null == char
          ? _value.char
          : char // ignore: cast_nullable_to_non_nullable
              as String,
      scoring: null == scoring
          ? _value.scoring
          : scoring // ignore: cast_nullable_to_non_nullable
              as CharacterScoring,
    ) as $Val);
  }

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CharacterScoringCopyWith<$Res> get scoring {
    return $CharacterScoringCopyWith<$Res>(_value.scoring, (value) {
      return _then(_value.copyWith(scoring: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CharacterInfoImplCopyWith<$Res>
    implements $CharacterInfoCopyWith<$Res> {
  factory _$$CharacterInfoImplCopyWith(
          _$CharacterInfoImpl value, $Res Function(_$CharacterInfoImpl) then) =
      __$$CharacterInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String char, CharacterScoring scoring});

  @override
  $CharacterScoringCopyWith<$Res> get scoring;
}

/// @nodoc
class __$$CharacterInfoImplCopyWithImpl<$Res>
    extends _$CharacterInfoCopyWithImpl<$Res, _$CharacterInfoImpl>
    implements _$$CharacterInfoImplCopyWith<$Res> {
  __$$CharacterInfoImplCopyWithImpl(
      _$CharacterInfoImpl _value, $Res Function(_$CharacterInfoImpl) _then)
      : super(_value, _then);

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? char = null,
    Object? scoring = null,
  }) {
    return _then(_$CharacterInfoImpl(
      char: null == char
          ? _value.char
          : char // ignore: cast_nullable_to_non_nullable
              as String,
      scoring: null == scoring
          ? _value.scoring
          : scoring // ignore: cast_nullable_to_non_nullable
              as CharacterScoring,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterInfoImpl implements _CharacterInfo {
  const _$CharacterInfoImpl({required this.char, required this.scoring});

  factory _$CharacterInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterInfoImplFromJson(json);

  @override
  final String char;
  @override
  final CharacterScoring scoring;

  @override
  String toString() {
    return 'CharacterInfo(char: $char, scoring: $scoring)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterInfoImpl &&
            (identical(other.char, char) || other.char == char) &&
            (identical(other.scoring, scoring) || other.scoring == scoring));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, char, scoring);

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      __$$CharacterInfoImplCopyWithImpl<_$CharacterInfoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterInfoImplToJson(
      this,
    );
  }
}

abstract class _CharacterInfo implements CharacterInfo {
  const factory _CharacterInfo(
      {required final String char,
      required final CharacterScoring scoring}) = _$CharacterInfoImpl;

  factory _CharacterInfo.fromJson(Map<String, dynamic> json) =
      _$CharacterInfoImpl.fromJson;

  @override
  String get char;
  @override
  CharacterScoring get scoring;

  /// Create a copy of CharacterInfo
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterInfoImplCopyWith<_$CharacterInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CharacterScoring _$CharacterScoringFromJson(Map<String, dynamic> json) {
  return _CharacterScoring.fromJson(json);
}

/// @nodoc
mixin _$CharacterScoring {
  @JsonKey(name: "in_word")
  bool get inWord => throw _privateConstructorUsedError;
  @JsonKey(name: "correct_idx")
  bool get correctIndex => throw _privateConstructorUsedError;

  /// Serializes this CharacterScoring to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CharacterScoring
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CharacterScoringCopyWith<CharacterScoring> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CharacterScoringCopyWith<$Res> {
  factory $CharacterScoringCopyWith(
          CharacterScoring value, $Res Function(CharacterScoring) then) =
      _$CharacterScoringCopyWithImpl<$Res, CharacterScoring>;
  @useResult
  $Res call(
      {@JsonKey(name: "in_word") bool inWord,
      @JsonKey(name: "correct_idx") bool correctIndex});
}

/// @nodoc
class _$CharacterScoringCopyWithImpl<$Res, $Val extends CharacterScoring>
    implements $CharacterScoringCopyWith<$Res> {
  _$CharacterScoringCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CharacterScoring
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inWord = null,
    Object? correctIndex = null,
  }) {
    return _then(_value.copyWith(
      inWord: null == inWord
          ? _value.inWord
          : inWord // ignore: cast_nullable_to_non_nullable
              as bool,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CharacterScoringImplCopyWith<$Res>
    implements $CharacterScoringCopyWith<$Res> {
  factory _$$CharacterScoringImplCopyWith(_$CharacterScoringImpl value,
          $Res Function(_$CharacterScoringImpl) then) =
      __$$CharacterScoringImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "in_word") bool inWord,
      @JsonKey(name: "correct_idx") bool correctIndex});
}

/// @nodoc
class __$$CharacterScoringImplCopyWithImpl<$Res>
    extends _$CharacterScoringCopyWithImpl<$Res, _$CharacterScoringImpl>
    implements _$$CharacterScoringImplCopyWith<$Res> {
  __$$CharacterScoringImplCopyWithImpl(_$CharacterScoringImpl _value,
      $Res Function(_$CharacterScoringImpl) _then)
      : super(_value, _then);

  /// Create a copy of CharacterScoring
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? inWord = null,
    Object? correctIndex = null,
  }) {
    return _then(_$CharacterScoringImpl(
      inWord: null == inWord
          ? _value.inWord
          : inWord // ignore: cast_nullable_to_non_nullable
              as bool,
      correctIndex: null == correctIndex
          ? _value.correctIndex
          : correctIndex // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CharacterScoringImpl implements _CharacterScoring {
  const _$CharacterScoringImpl(
      {@JsonKey(name: "in_word") required this.inWord,
      @JsonKey(name: "correct_idx") required this.correctIndex});

  factory _$CharacterScoringImpl.fromJson(Map<String, dynamic> json) =>
      _$$CharacterScoringImplFromJson(json);

  @override
  @JsonKey(name: "in_word")
  final bool inWord;
  @override
  @JsonKey(name: "correct_idx")
  final bool correctIndex;

  @override
  String toString() {
    return 'CharacterScoring(inWord: $inWord, correctIndex: $correctIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CharacterScoringImpl &&
            (identical(other.inWord, inWord) || other.inWord == inWord) &&
            (identical(other.correctIndex, correctIndex) ||
                other.correctIndex == correctIndex));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, inWord, correctIndex);

  /// Create a copy of CharacterScoring
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CharacterScoringImplCopyWith<_$CharacterScoringImpl> get copyWith =>
      __$$CharacterScoringImplCopyWithImpl<_$CharacterScoringImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CharacterScoringImplToJson(
      this,
    );
  }
}

abstract class _CharacterScoring implements CharacterScoring {
  const factory _CharacterScoring(
          {@JsonKey(name: "in_word") required final bool inWord,
          @JsonKey(name: "correct_idx") required final bool correctIndex}) =
      _$CharacterScoringImpl;

  factory _CharacterScoring.fromJson(Map<String, dynamic> json) =
      _$CharacterScoringImpl.fromJson;

  @override
  @JsonKey(name: "in_word")
  bool get inWord;
  @override
  @JsonKey(name: "correct_idx")
  bool get correctIndex;

  /// Create a copy of CharacterScoring
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CharacterScoringImplCopyWith<_$CharacterScoringImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
