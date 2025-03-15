import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String username,
    required String email,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(0) int spotCount,
    @Default(false) bool isFollowing,
    String? profileImageUrl,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
