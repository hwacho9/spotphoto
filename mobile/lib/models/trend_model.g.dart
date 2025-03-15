// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TrendModelImpl _$$TrendModelImplFromJson(Map<String, dynamic> json) =>
    _$TrendModelImpl(
      id: json['id'] as String,
      location: json['location'] as String,
      searchCount: (json['search_count'] as num).toInt(),
      uploadCount: (json['upload_count'] as num).toInt(),
      likeCount: (json['like_count'] as num).toInt(),
      trendScore: (json['trend_score'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$TrendModelImplToJson(_$TrendModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'location': instance.location,
      'search_count': instance.searchCount,
      'upload_count': instance.uploadCount,
      'like_count': instance.likeCount,
      'trend_score': instance.trendScore,
      'date': instance.date.toIso8601String(),
    };
