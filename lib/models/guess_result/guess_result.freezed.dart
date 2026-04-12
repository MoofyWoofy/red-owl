// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guess_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuessResult {

 String get guess;@JsonKey(name: "is_correct") bool get isCorrect;@JsonKey(name: "is_word_in_list") bool get isWordInList;@JsonKey(name: "character_info") List<CharacterInfo>? get characterInfo;
/// Create a copy of GuessResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GuessResultCopyWith<GuessResult> get copyWith => _$GuessResultCopyWithImpl<GuessResult>(this as GuessResult, _$identity);

  /// Serializes this GuessResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GuessResult&&(identical(other.guess, guess) || other.guess == guess)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isWordInList, isWordInList) || other.isWordInList == isWordInList)&&const DeepCollectionEquality().equals(other.characterInfo, characterInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,guess,isCorrect,isWordInList,const DeepCollectionEquality().hash(characterInfo));

@override
String toString() {
  return 'GuessResult(guess: $guess, isCorrect: $isCorrect, isWordInList: $isWordInList, characterInfo: $characterInfo)';
}


}

/// @nodoc
abstract mixin class $GuessResultCopyWith<$Res>  {
  factory $GuessResultCopyWith(GuessResult value, $Res Function(GuessResult) _then) = _$GuessResultCopyWithImpl;
@useResult
$Res call({
 String guess,@JsonKey(name: "is_correct") bool isCorrect,@JsonKey(name: "is_word_in_list") bool isWordInList,@JsonKey(name: "character_info") List<CharacterInfo>? characterInfo
});




}
/// @nodoc
class _$GuessResultCopyWithImpl<$Res>
    implements $GuessResultCopyWith<$Res> {
  _$GuessResultCopyWithImpl(this._self, this._then);

  final GuessResult _self;
  final $Res Function(GuessResult) _then;

/// Create a copy of GuessResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? guess = null,Object? isCorrect = null,Object? isWordInList = null,Object? characterInfo = freezed,}) {
  return _then(_self.copyWith(
guess: null == guess ? _self.guess : guess // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isWordInList: null == isWordInList ? _self.isWordInList : isWordInList // ignore: cast_nullable_to_non_nullable
as bool,characterInfo: freezed == characterInfo ? _self.characterInfo : characterInfo // ignore: cast_nullable_to_non_nullable
as List<CharacterInfo>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GuessResult].
extension GuessResultPatterns on GuessResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GuessResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GuessResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GuessResult value)  $default,){
final _that = this;
switch (_that) {
case _GuessResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GuessResult value)?  $default,){
final _that = this;
switch (_that) {
case _GuessResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String guess, @JsonKey(name: "is_correct")  bool isCorrect, @JsonKey(name: "is_word_in_list")  bool isWordInList, @JsonKey(name: "character_info")  List<CharacterInfo>? characterInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GuessResult() when $default != null:
return $default(_that.guess,_that.isCorrect,_that.isWordInList,_that.characterInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String guess, @JsonKey(name: "is_correct")  bool isCorrect, @JsonKey(name: "is_word_in_list")  bool isWordInList, @JsonKey(name: "character_info")  List<CharacterInfo>? characterInfo)  $default,) {final _that = this;
switch (_that) {
case _GuessResult():
return $default(_that.guess,_that.isCorrect,_that.isWordInList,_that.characterInfo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String guess, @JsonKey(name: "is_correct")  bool isCorrect, @JsonKey(name: "is_word_in_list")  bool isWordInList, @JsonKey(name: "character_info")  List<CharacterInfo>? characterInfo)?  $default,) {final _that = this;
switch (_that) {
case _GuessResult() when $default != null:
return $default(_that.guess,_that.isCorrect,_that.isWordInList,_that.characterInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GuessResult implements GuessResult {
  const _GuessResult({required this.guess, @JsonKey(name: "is_correct") required this.isCorrect, @JsonKey(name: "is_word_in_list") required this.isWordInList, @JsonKey(name: "character_info") required final  List<CharacterInfo>? characterInfo}): _characterInfo = characterInfo;
  factory _GuessResult.fromJson(Map<String, dynamic> json) => _$GuessResultFromJson(json);

@override final  String guess;
@override@JsonKey(name: "is_correct") final  bool isCorrect;
@override@JsonKey(name: "is_word_in_list") final  bool isWordInList;
 final  List<CharacterInfo>? _characterInfo;
@override@JsonKey(name: "character_info") List<CharacterInfo>? get characterInfo {
  final value = _characterInfo;
  if (value == null) return null;
  if (_characterInfo is EqualUnmodifiableListView) return _characterInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GuessResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GuessResultCopyWith<_GuessResult> get copyWith => __$GuessResultCopyWithImpl<_GuessResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GuessResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GuessResult&&(identical(other.guess, guess) || other.guess == guess)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.isWordInList, isWordInList) || other.isWordInList == isWordInList)&&const DeepCollectionEquality().equals(other._characterInfo, _characterInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,guess,isCorrect,isWordInList,const DeepCollectionEquality().hash(_characterInfo));

@override
String toString() {
  return 'GuessResult(guess: $guess, isCorrect: $isCorrect, isWordInList: $isWordInList, characterInfo: $characterInfo)';
}


}

/// @nodoc
abstract mixin class _$GuessResultCopyWith<$Res> implements $GuessResultCopyWith<$Res> {
  factory _$GuessResultCopyWith(_GuessResult value, $Res Function(_GuessResult) _then) = __$GuessResultCopyWithImpl;
@override @useResult
$Res call({
 String guess,@JsonKey(name: "is_correct") bool isCorrect,@JsonKey(name: "is_word_in_list") bool isWordInList,@JsonKey(name: "character_info") List<CharacterInfo>? characterInfo
});




}
/// @nodoc
class __$GuessResultCopyWithImpl<$Res>
    implements _$GuessResultCopyWith<$Res> {
  __$GuessResultCopyWithImpl(this._self, this._then);

  final _GuessResult _self;
  final $Res Function(_GuessResult) _then;

/// Create a copy of GuessResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? guess = null,Object? isCorrect = null,Object? isWordInList = null,Object? characterInfo = freezed,}) {
  return _then(_GuessResult(
guess: null == guess ? _self.guess : guess // ignore: cast_nullable_to_non_nullable
as String,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,isWordInList: null == isWordInList ? _self.isWordInList : isWordInList // ignore: cast_nullable_to_non_nullable
as bool,characterInfo: freezed == characterInfo ? _self._characterInfo : characterInfo // ignore: cast_nullable_to_non_nullable
as List<CharacterInfo>?,
  ));
}


}


/// @nodoc
mixin _$CharacterInfo {

 String get char; CharacterScoring get scoring;
/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterInfoCopyWith<CharacterInfo> get copyWith => _$CharacterInfoCopyWithImpl<CharacterInfo>(this as CharacterInfo, _$identity);

  /// Serializes this CharacterInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterInfo&&(identical(other.char, char) || other.char == char)&&(identical(other.scoring, scoring) || other.scoring == scoring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,char,scoring);

@override
String toString() {
  return 'CharacterInfo(char: $char, scoring: $scoring)';
}


}

/// @nodoc
abstract mixin class $CharacterInfoCopyWith<$Res>  {
  factory $CharacterInfoCopyWith(CharacterInfo value, $Res Function(CharacterInfo) _then) = _$CharacterInfoCopyWithImpl;
@useResult
$Res call({
 String char, CharacterScoring scoring
});


$CharacterScoringCopyWith<$Res> get scoring;

}
/// @nodoc
class _$CharacterInfoCopyWithImpl<$Res>
    implements $CharacterInfoCopyWith<$Res> {
  _$CharacterInfoCopyWithImpl(this._self, this._then);

  final CharacterInfo _self;
  final $Res Function(CharacterInfo) _then;

/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? char = null,Object? scoring = null,}) {
  return _then(_self.copyWith(
char: null == char ? _self.char : char // ignore: cast_nullable_to_non_nullable
as String,scoring: null == scoring ? _self.scoring : scoring // ignore: cast_nullable_to_non_nullable
as CharacterScoring,
  ));
}
/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterScoringCopyWith<$Res> get scoring {
  
  return $CharacterScoringCopyWith<$Res>(_self.scoring, (value) {
    return _then(_self.copyWith(scoring: value));
  });
}
}


/// Adds pattern-matching-related methods to [CharacterInfo].
extension CharacterInfoPatterns on CharacterInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterInfo value)  $default,){
final _that = this;
switch (_that) {
case _CharacterInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterInfo value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String char,  CharacterScoring scoring)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterInfo() when $default != null:
return $default(_that.char,_that.scoring);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String char,  CharacterScoring scoring)  $default,) {final _that = this;
switch (_that) {
case _CharacterInfo():
return $default(_that.char,_that.scoring);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String char,  CharacterScoring scoring)?  $default,) {final _that = this;
switch (_that) {
case _CharacterInfo() when $default != null:
return $default(_that.char,_that.scoring);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterInfo implements CharacterInfo {
  const _CharacterInfo({required this.char, required this.scoring});
  factory _CharacterInfo.fromJson(Map<String, dynamic> json) => _$CharacterInfoFromJson(json);

@override final  String char;
@override final  CharacterScoring scoring;

/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterInfoCopyWith<_CharacterInfo> get copyWith => __$CharacterInfoCopyWithImpl<_CharacterInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterInfo&&(identical(other.char, char) || other.char == char)&&(identical(other.scoring, scoring) || other.scoring == scoring));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,char,scoring);

@override
String toString() {
  return 'CharacterInfo(char: $char, scoring: $scoring)';
}


}

/// @nodoc
abstract mixin class _$CharacterInfoCopyWith<$Res> implements $CharacterInfoCopyWith<$Res> {
  factory _$CharacterInfoCopyWith(_CharacterInfo value, $Res Function(_CharacterInfo) _then) = __$CharacterInfoCopyWithImpl;
@override @useResult
$Res call({
 String char, CharacterScoring scoring
});


@override $CharacterScoringCopyWith<$Res> get scoring;

}
/// @nodoc
class __$CharacterInfoCopyWithImpl<$Res>
    implements _$CharacterInfoCopyWith<$Res> {
  __$CharacterInfoCopyWithImpl(this._self, this._then);

  final _CharacterInfo _self;
  final $Res Function(_CharacterInfo) _then;

/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? char = null,Object? scoring = null,}) {
  return _then(_CharacterInfo(
char: null == char ? _self.char : char // ignore: cast_nullable_to_non_nullable
as String,scoring: null == scoring ? _self.scoring : scoring // ignore: cast_nullable_to_non_nullable
as CharacterScoring,
  ));
}

/// Create a copy of CharacterInfo
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CharacterScoringCopyWith<$Res> get scoring {
  
  return $CharacterScoringCopyWith<$Res>(_self.scoring, (value) {
    return _then(_self.copyWith(scoring: value));
  });
}
}


/// @nodoc
mixin _$CharacterScoring {

@JsonKey(name: "in_word") bool get inWord;@JsonKey(name: "correct_idx") bool get correctIndex;
/// Create a copy of CharacterScoring
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CharacterScoringCopyWith<CharacterScoring> get copyWith => _$CharacterScoringCopyWithImpl<CharacterScoring>(this as CharacterScoring, _$identity);

  /// Serializes this CharacterScoring to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CharacterScoring&&(identical(other.inWord, inWord) || other.inWord == inWord)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inWord,correctIndex);

@override
String toString() {
  return 'CharacterScoring(inWord: $inWord, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class $CharacterScoringCopyWith<$Res>  {
  factory $CharacterScoringCopyWith(CharacterScoring value, $Res Function(CharacterScoring) _then) = _$CharacterScoringCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "in_word") bool inWord,@JsonKey(name: "correct_idx") bool correctIndex
});




}
/// @nodoc
class _$CharacterScoringCopyWithImpl<$Res>
    implements $CharacterScoringCopyWith<$Res> {
  _$CharacterScoringCopyWithImpl(this._self, this._then);

  final CharacterScoring _self;
  final $Res Function(CharacterScoring) _then;

/// Create a copy of CharacterScoring
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inWord = null,Object? correctIndex = null,}) {
  return _then(_self.copyWith(
inWord: null == inWord ? _self.inWord : inWord // ignore: cast_nullable_to_non_nullable
as bool,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CharacterScoring].
extension CharacterScoringPatterns on CharacterScoring {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CharacterScoring value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CharacterScoring() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CharacterScoring value)  $default,){
final _that = this;
switch (_that) {
case _CharacterScoring():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CharacterScoring value)?  $default,){
final _that = this;
switch (_that) {
case _CharacterScoring() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "in_word")  bool inWord, @JsonKey(name: "correct_idx")  bool correctIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CharacterScoring() when $default != null:
return $default(_that.inWord,_that.correctIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "in_word")  bool inWord, @JsonKey(name: "correct_idx")  bool correctIndex)  $default,) {final _that = this;
switch (_that) {
case _CharacterScoring():
return $default(_that.inWord,_that.correctIndex);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "in_word")  bool inWord, @JsonKey(name: "correct_idx")  bool correctIndex)?  $default,) {final _that = this;
switch (_that) {
case _CharacterScoring() when $default != null:
return $default(_that.inWord,_that.correctIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CharacterScoring implements CharacterScoring {
  const _CharacterScoring({@JsonKey(name: "in_word") required this.inWord, @JsonKey(name: "correct_idx") required this.correctIndex});
  factory _CharacterScoring.fromJson(Map<String, dynamic> json) => _$CharacterScoringFromJson(json);

@override@JsonKey(name: "in_word") final  bool inWord;
@override@JsonKey(name: "correct_idx") final  bool correctIndex;

/// Create a copy of CharacterScoring
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CharacterScoringCopyWith<_CharacterScoring> get copyWith => __$CharacterScoringCopyWithImpl<_CharacterScoring>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CharacterScoringToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CharacterScoring&&(identical(other.inWord, inWord) || other.inWord == inWord)&&(identical(other.correctIndex, correctIndex) || other.correctIndex == correctIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inWord,correctIndex);

@override
String toString() {
  return 'CharacterScoring(inWord: $inWord, correctIndex: $correctIndex)';
}


}

/// @nodoc
abstract mixin class _$CharacterScoringCopyWith<$Res> implements $CharacterScoringCopyWith<$Res> {
  factory _$CharacterScoringCopyWith(_CharacterScoring value, $Res Function(_CharacterScoring) _then) = __$CharacterScoringCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "in_word") bool inWord,@JsonKey(name: "correct_idx") bool correctIndex
});




}
/// @nodoc
class __$CharacterScoringCopyWithImpl<$Res>
    implements _$CharacterScoringCopyWith<$Res> {
  __$CharacterScoringCopyWithImpl(this._self, this._then);

  final _CharacterScoring _self;
  final $Res Function(_CharacterScoring) _then;

/// Create a copy of CharacterScoring
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inWord = null,Object? correctIndex = null,}) {
  return _then(_CharacterScoring(
inWord: null == inWord ? _self.inWord : inWord // ignore: cast_nullable_to_non_nullable
as bool,correctIndex: null == correctIndex ? _self.correctIndex : correctIndex // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
