// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'follow_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FollowModel _$FollowModelFromJson(Map<String, dynamic> json) {
  return _FollowModel.fromJson(json);
}

/// @nodoc
mixin _$FollowModel {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'follower_id')
  String get followerId => throw _privateConstructorUsedError;
  @JsonKey(name: 'following_id')
  String get followingId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt =>
      throw _privateConstructorUsedError; // 추가 정보 (조인 쿼리에서 가져올 수 있음)
  String? get followerUsername => throw _privateConstructorUsedError;
  String? get followerProfileUrl => throw _privateConstructorUsedError;
  String? get followingUsername => throw _privateConstructorUsedError;
  String? get followingProfileUrl => throw _privateConstructorUsedError;

  /// Serializes this FollowModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FollowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FollowModelCopyWith<FollowModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FollowModelCopyWith<$Res> {
  factory $FollowModelCopyWith(
          FollowModel value, $Res Function(FollowModel) then) =
      _$FollowModelCopyWithImpl<$Res, FollowModel>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'follower_id') String followerId,
      @JsonKey(name: 'following_id') String followingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? followerUsername,
      String? followerProfileUrl,
      String? followingUsername,
      String? followingProfileUrl});
}

/// @nodoc
class _$FollowModelCopyWithImpl<$Res, $Val extends FollowModel>
    implements $FollowModelCopyWith<$Res> {
  _$FollowModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FollowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followingId = null,
    Object? createdAt = null,
    Object? followerUsername = freezed,
    Object? followerProfileUrl = freezed,
    Object? followingUsername = freezed,
    Object? followingProfileUrl = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followingId: null == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      followerUsername: freezed == followerUsername
          ? _value.followerUsername
          : followerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      followerProfileUrl: freezed == followerProfileUrl
          ? _value.followerProfileUrl
          : followerProfileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followingUsername: freezed == followingUsername
          ? _value.followingUsername
          : followingUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      followingProfileUrl: freezed == followingProfileUrl
          ? _value.followingProfileUrl
          : followingProfileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FollowModelImplCopyWith<$Res>
    implements $FollowModelCopyWith<$Res> {
  factory _$$FollowModelImplCopyWith(
          _$FollowModelImpl value, $Res Function(_$FollowModelImpl) then) =
      __$$FollowModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'follower_id') String followerId,
      @JsonKey(name: 'following_id') String followingId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? followerUsername,
      String? followerProfileUrl,
      String? followingUsername,
      String? followingProfileUrl});
}

/// @nodoc
class __$$FollowModelImplCopyWithImpl<$Res>
    extends _$FollowModelCopyWithImpl<$Res, _$FollowModelImpl>
    implements _$$FollowModelImplCopyWith<$Res> {
  __$$FollowModelImplCopyWithImpl(
      _$FollowModelImpl _value, $Res Function(_$FollowModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of FollowModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? followerId = null,
    Object? followingId = null,
    Object? createdAt = null,
    Object? followerUsername = freezed,
    Object? followerProfileUrl = freezed,
    Object? followingUsername = freezed,
    Object? followingProfileUrl = freezed,
  }) {
    return _then(_$FollowModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      followerId: null == followerId
          ? _value.followerId
          : followerId // ignore: cast_nullable_to_non_nullable
              as String,
      followingId: null == followingId
          ? _value.followingId
          : followingId // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      followerUsername: freezed == followerUsername
          ? _value.followerUsername
          : followerUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      followerProfileUrl: freezed == followerProfileUrl
          ? _value.followerProfileUrl
          : followerProfileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      followingUsername: freezed == followingUsername
          ? _value.followingUsername
          : followingUsername // ignore: cast_nullable_to_non_nullable
              as String?,
      followingProfileUrl: freezed == followingProfileUrl
          ? _value.followingProfileUrl
          : followingProfileUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FollowModelImpl implements _FollowModel {
  const _$FollowModelImpl(
      {required this.id,
      @JsonKey(name: 'follower_id') required this.followerId,
      @JsonKey(name: 'following_id') required this.followingId,
      @JsonKey(name: 'created_at') required this.createdAt,
      this.followerUsername,
      this.followerProfileUrl,
      this.followingUsername,
      this.followingProfileUrl});

  factory _$FollowModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$FollowModelImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'follower_id')
  final String followerId;
  @override
  @JsonKey(name: 'following_id')
  final String followingId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
// 추가 정보 (조인 쿼리에서 가져올 수 있음)
  @override
  final String? followerUsername;
  @override
  final String? followerProfileUrl;
  @override
  final String? followingUsername;
  @override
  final String? followingProfileUrl;

  @override
  String toString() {
    return 'FollowModel(id: $id, followerId: $followerId, followingId: $followingId, createdAt: $createdAt, followerUsername: $followerUsername, followerProfileUrl: $followerProfileUrl, followingUsername: $followingUsername, followingProfileUrl: $followingProfileUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FollowModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.followerId, followerId) ||
                other.followerId == followerId) &&
            (identical(other.followingId, followingId) ||
                other.followingId == followingId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.followerUsername, followerUsername) ||
                other.followerUsername == followerUsername) &&
            (identical(other.followerProfileUrl, followerProfileUrl) ||
                other.followerProfileUrl == followerProfileUrl) &&
            (identical(other.followingUsername, followingUsername) ||
                other.followingUsername == followingUsername) &&
            (identical(other.followingProfileUrl, followingProfileUrl) ||
                other.followingProfileUrl == followingProfileUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      followerId,
      followingId,
      createdAt,
      followerUsername,
      followerProfileUrl,
      followingUsername,
      followingProfileUrl);

  /// Create a copy of FollowModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FollowModelImplCopyWith<_$FollowModelImpl> get copyWith =>
      __$$FollowModelImplCopyWithImpl<_$FollowModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FollowModelImplToJson(
      this,
    );
  }
}

abstract class _FollowModel implements FollowModel {
  const factory _FollowModel(
      {required final String id,
      @JsonKey(name: 'follower_id') required final String followerId,
      @JsonKey(name: 'following_id') required final String followingId,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      final String? followerUsername,
      final String? followerProfileUrl,
      final String? followingUsername,
      final String? followingProfileUrl}) = _$FollowModelImpl;

  factory _FollowModel.fromJson(Map<String, dynamic> json) =
      _$FollowModelImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'follower_id')
  String get followerId;
  @override
  @JsonKey(name: 'following_id')
  String get followingId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt; // 추가 정보 (조인 쿼리에서 가져올 수 있음)
  @override
  String? get followerUsername;
  @override
  String? get followerProfileUrl;
  @override
  String? get followingUsername;
  @override
  String? get followingProfileUrl;

  /// Create a copy of FollowModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FollowModelImplCopyWith<_$FollowModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
