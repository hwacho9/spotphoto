import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/follow_model.dart';
import 'package:mobile/models/user_model.dart';

part 'follow_repository.g.dart';

@riverpod
FollowRepository followRepository(FollowRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return FollowRepository(supabase);
}

/// 팔로우 관련 데이터베이스 작업을 담당하는 Repository
class FollowRepository {
  final SupabaseClient _supabaseClient;

  FollowRepository(this._supabaseClient);

  /// 특정 사용자의 팔로워 목록을 가져옵니다.
  Future<List<UserModel>> getFollowers(String userId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .select('*, users!follower_id(*)')
          .eq('following_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((follow) => UserModel.fromJson(follow['users']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get followers: $e');
    }
  }

  /// 특정 사용자의 팔로잉 목록을 가져옵니다.
  Future<List<UserModel>> getFollowings(String userId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .select('*, users!following_id(*)')
          .eq('follower_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((follow) => UserModel.fromJson(follow['users']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get followings: $e');
    }
  }

  /// 특정 사용자의 팔로워 수를 가져옵니다.
  Future<int> getFollowerCount(String userId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .count()
          .eq('following_id', userId);

      // count 메서드는 정수 값을 반환
      return response;
    } catch (e) {
      // 오류 발생 시 0을 반환하고 로그 기록
      print('Failed to get follower count: $e');
      return 0;
    }
  }

  /// 특정 사용자의 팔로잉 수를 가져옵니다.
  Future<int> getFollowingCount(String userId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .count()
          .eq('follower_id', userId);

      // count 메서드는 정수 값을 반환
      return response;
    } catch (e) {
      // 오류 발생 시 0을 반환하고 로그 기록
      print('Failed to get following count: $e');
      return 0;
    }
  }

  /// 팔로우 여부를 확인합니다.
  Future<bool> isFollowing(String followerId, String followingId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .select('id')
          .eq('follower_id', followerId)
          .eq('following_id', followingId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check if following: $e');
    }
  }

  /// 팔로우합니다.
  Future<void> follow(String followerId, String followingId) async {
    try {
      // 이미 팔로우 중인지 확인
      final isAlreadyFollowing = await isFollowing(followerId, followingId);
      if (isAlreadyFollowing) {
        return; // 이미 팔로우 중이면 아무 작업도 하지 않음
      }

      await _supabaseClient.from('follows').insert({
        'follower_id': followerId,
        'following_id': followingId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to follow: $e');
    }
  }

  /// 언팔로우합니다.
  Future<void> unfollow(String followerId, String followingId) async {
    try {
      await _supabaseClient.from('follows').delete().match({
        'follower_id': followerId,
        'following_id': followingId,
      });
    } catch (e) {
      throw Exception('Failed to unfollow: $e');
    }
  }
}
