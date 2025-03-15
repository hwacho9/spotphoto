import 'package:freezed_annotation/freezed_annotation.dart';

part 'photo_model.freezed.dart';
part 'photo_model.g.dart';

@freezed
class PhotoModel with _$PhotoModel {
  const factory PhotoModel({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    required String url,
    required String location,
    @Default([]) List<String> tags,
    String? description,
    @JsonKey(name: 'uploaded_at') required DateTime uploadedAt,
    @Default(0) int likeCount,
    @Default(false) bool isLiked,
    // Related user info (populated by join or separate query)
    String? username,
    String? userProfileUrl,
  }) = _PhotoModel;

  factory PhotoModel.fromJson(Map<String, dynamic> json) =>
      _$PhotoModelFromJson(json);
}
