// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrendModel _$TrendModelFromJson(Map<String, dynamic> json) {
  return _TrendModel.fromJson(json);
}

/// @nodoc
mixin _$TrendModel {
  String get id => throw _privateConstructorUsedError;
  String get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'search_count')
  int get searchCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'upload_count')
  int get uploadCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'like_count')
  int get likeCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'trend_score')
  double get trendScore => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this TrendModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrendModelCopyWith<TrendModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrendModelCopyWith<$Res> {
  factory $TrendModelCopyWith(
          TrendModel value, $Res Function(TrendModel) then) =
      _$TrendModelCopyWithImpl<$Res, TrendModel>;
  @useResult
  $Res call(
      {String id,
      String location,
      @JsonKey(name: 'search_count') int searchCount,
      @JsonKey(name: 'upload_count') int uploadCount,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'trend_score') double trendScore,
      DateTime date});
}

/// @nodoc
class _$TrendModelCopyWithImpl<$Res, $Val extends TrendModel>
    implements $TrendModelCopyWith<$Res> {
  _$TrendModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? searchCount = null,
    Object? uploadCount = null,
    Object? likeCount = null,
    Object? trendScore = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      searchCount: null == searchCount
          ? _value.searchCount
          : searchCount // ignore: cast_nullable_to_non_nullable
              as int,
      uploadCount: null == uploadCount
          ? _value.uploadCount
          : uploadCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      trendScore: null == trendScore
          ? _value.trendScore
          : trendScore // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrendModelImplCopyWith<$Res>
    implements $TrendModelCopyWith<$Res> {
  factory _$$TrendModelImplCopyWith(
          _$TrendModelImpl value, $Res Function(_$TrendModelImpl) then) =
      __$$TrendModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String location,
      @JsonKey(name: 'search_count') int searchCount,
      @JsonKey(name: 'upload_count') int uploadCount,
      @JsonKey(name: 'like_count') int likeCount,
      @JsonKey(name: 'trend_score') double trendScore,
      DateTime date});
}

/// @nodoc
class __$$TrendModelImplCopyWithImpl<$Res>
    extends _$TrendModelCopyWithImpl<$Res, _$TrendModelImpl>
    implements _$$TrendModelImplCopyWith<$Res> {
  __$$TrendModelImplCopyWithImpl(
      _$TrendModelImpl _value, $Res Function(_$TrendModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrendModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? location = null,
    Object? searchCount = null,
    Object? uploadCount = null,
    Object? likeCount = null,
    Object? trendScore = null,
    Object? date = null,
  }) {
    return _then(_$TrendModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      location: null == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String,
      searchCount: null == searchCount
          ? _value.searchCount
          : searchCount // ignore: cast_nullable_to_non_nullable
              as int,
      uploadCount: null == uploadCount
          ? _value.uploadCount
          : uploadCount // ignore: cast_nullable_to_non_nullable
              as int,
      likeCount: null == likeCount
          ? _value.likeCount
          : likeCount // ignore: cast_nullable_to_non_nullable
              as int,
      trendScore: null == trendScore
          ? _value.trendScore
          : trendScore // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrendModelImpl implements _TrendModel {
  const _$TrendModelImpl(
      {required this.id,
      required this.location,
      @JsonKey(name: 'search_count') required this.searchCount,
      @JsonKey(name: 'upload_count') required this.uploadCount,
      @JsonKey(name: 'like_count') required this.likeCount,
      @JsonKey(name: 'trend_score') required this.trendScore,
      required this.date});

  factory _$TrendModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrendModelImplFromJson(json);

  @override
  final String id;
  @override
  final String location;
  @override
  @JsonKey(name: 'search_count')
  final int searchCount;
  @override
  @JsonKey(name: 'upload_count')
  final int uploadCount;
  @override
  @JsonKey(name: 'like_count')
  final int likeCount;
  @override
  @JsonKey(name: 'trend_score')
  final double trendScore;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'TrendModel(id: $id, location: $location, searchCount: $searchCount, uploadCount: $uploadCount, likeCount: $likeCount, trendScore: $trendScore, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrendModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.searchCount, searchCount) ||
                other.searchCount == searchCount) &&
            (identical(other.uploadCount, uploadCount) ||
                other.uploadCount == uploadCount) &&
            (identical(other.likeCount, likeCount) ||
                other.likeCount == likeCount) &&
            (identical(other.trendScore, trendScore) ||
                other.trendScore == trendScore) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, location, searchCount,
      uploadCount, likeCount, trendScore, date);

  /// Create a copy of TrendModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrendModelImplCopyWith<_$TrendModelImpl> get copyWith =>
      __$$TrendModelImplCopyWithImpl<_$TrendModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrendModelImplToJson(
      this,
    );
  }
}

abstract class _TrendModel implements TrendModel {
  const factory _TrendModel(
      {required final String id,
      required final String location,
      @JsonKey(name: 'search_count') required final int searchCount,
      @JsonKey(name: 'upload_count') required final int uploadCount,
      @JsonKey(name: 'like_count') required final int likeCount,
      @JsonKey(name: 'trend_score') required final double trendScore,
      required final DateTime date}) = _$TrendModelImpl;

  factory _TrendModel.fromJson(Map<String, dynamic> json) =
      _$TrendModelImpl.fromJson;

  @override
  String get id;
  @override
  String get location;
  @override
  @JsonKey(name: 'search_count')
  int get searchCount;
  @override
  @JsonKey(name: 'upload_count')
  int get uploadCount;
  @override
  @JsonKey(name: 'like_count')
  int get likeCount;
  @override
  @JsonKey(name: 'trend_score')
  double get trendScore;
  @override
  DateTime get date;

  /// Create a copy of TrendModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrendModelImplCopyWith<_$TrendModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
