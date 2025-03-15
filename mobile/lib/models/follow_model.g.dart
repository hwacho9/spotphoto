// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FollowModelImpl _$$FollowModelImplFromJson(Map<String, dynamic> json) =>
    _$FollowModelImpl(
      id: json['id'] as String,
      followerId: json['follower_id'] as String,
      followingId: json['following_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      followerUsername: json['followerUsername'] as String?,
      followerProfileUrl: json['followerProfileUrl'] as String?,
      followingUsername: json['followingUsername'] as String?,
      followingProfileUrl: json['followingProfileUrl'] as String?,
    );

Map<String, dynamic> _$$FollowModelImplToJson(_$FollowModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'follower_id': instance.followerId,
      'following_id': instance.followingId,
      'created_at': instance.createdAt.toIso8601String(),
      'followerUsername': instance.followerUsername,
      'followerProfileUrl': instance.followerProfileUrl,
      'followingUsername': instance.followingUsername,
      'followingProfileUrl': instance.followingProfileUrl,
    };
