import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_model.freezed.dart';
part 'follow_model.g.dart';

@freezed
class FollowModel with _$FollowModel {
  const factory FollowModel({
    required String id,
    @JsonKey(name: 'follower_id') required String followerId,
    @JsonKey(name: 'following_id') required String followingId,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // 추가 정보 (조인 쿼리에서 가져올 수 있음)
    String? followerUsername,
    String? followerProfileUrl,
    String? followingUsername,
    String? followingProfileUrl,
  }) = _FollowModel;

  factory FollowModel.fromJson(Map<String, dynamic> json) =>
      _$FollowModelFromJson(json);
}
