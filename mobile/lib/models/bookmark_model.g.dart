// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BookmarkModelImpl _$$BookmarkModelImplFromJson(Map<String, dynamic> json) =>
    _$BookmarkModelImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      photoId: json['photo_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      photo: json['photo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$BookmarkModelImplToJson(_$BookmarkModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'photo_id': instance.photoId,
      'created_at': instance.createdAt.toIso8601String(),
      'photo': instance.photo,
    };
