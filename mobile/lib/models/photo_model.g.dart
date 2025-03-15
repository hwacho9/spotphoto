// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PhotoModelImpl _$$PhotoModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String?,
      url: json['url'] as String?,
      location: json['location'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      description: json['description'] as String?,
      uploadedAt: json['uploaded_at'] == null
          ? null
          : DateTime.parse(json['uploaded_at'] as String),
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      isLiked: json['isLiked'] as bool? ?? false,
      username: json['username'] as String?,
      userProfileUrl: json['userProfileUrl'] as String?,
    );

Map<String, dynamic> _$$PhotoModelImplToJson(_$PhotoModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'url': instance.url,
      'location': instance.location,
      'tags': instance.tags,
      'description': instance.description,
      'uploaded_at': instance.uploadedAt?.toIso8601String(),
      'likeCount': instance.likeCount,
      'isLiked': instance.isLiked,
      'username': instance.username,
      'userProfileUrl': instance.userProfileUrl,
    };
