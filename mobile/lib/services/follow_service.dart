import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/repositories/follow_repository.dart';

part 'follow_service.g.dart';

@riverpod
FollowService followService(FollowServiceRef ref) {
  final followRepository = ref.watch(followRepositoryProvider);
  return FollowService(followRepository);
}

/// 팔로우 관련 비즈니스 로직을 처리하는 서비스
class FollowService {
  final FollowRepository _followRepository;

  FollowService(this._followRepository);

  /// 특정 사용자의 팔로워 목록을 가져옵니다.
  Future<List<UserModel>> getFollowers(String userId) async {
    return await _followRepository.getFollowers(userId);
  }

  /// 특정 사용자의 팔로잉 목록을 가져옵니다.
  Future<List<UserModel>> getFollowings(String userId) async {
    return await _followRepository.getFollowings(userId);
  }

  /// 특정 사용자의 팔로워 수를 가져옵니다.
  Future<int> getFollowerCount(String userId) async {
    return await _followRepository.getFollowerCount(userId);
  }

  /// 특정 사용자의 팔로잉 수를 가져옵니다.
  Future<int> getFollowingCount(String userId) async {
    return await _followRepository.getFollowingCount(userId);
  }

  /// 팔로우 여부를 확인합니다.
  Future<bool> isFollowing(String followingId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false;
    }

    return await _followRepository.isFollowing(user.id, followingId);
  }

  /// 팔로우 상태를 토글합니다.
  Future<bool> toggleFollow(String followingId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    // 자기 자신을 팔로우할 수 없음
    if (user.id == followingId) {
      throw Exception('자기 자신을 팔로우할 수 없습니다');
    }

    final isFollowing =
        await _followRepository.isFollowing(user.id, followingId);

    if (isFollowing) {
      await _followRepository.unfollow(user.id, followingId);
      return false;
    } else {
      await _followRepository.follow(user.id, followingId);
      return true;
    }
  }
}
