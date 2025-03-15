import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/user_model.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return UserRepository(supabase);
}

/// 사용자 관련 데이터베이스 작업을 담당하는 Repository
class UserRepository {
  final SupabaseClient _supabaseClient;

  UserRepository(this._supabaseClient);

  /// 사용자 프로필 정보를 가져옵니다.
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      print('Failed to get user profile: $e');
      return null;
    }
  }

  /// 현재 로그인한 사용자의 프로필 정보를 가져옵니다.
  Future<UserModel?> getCurrentUserProfile() async {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) return null;

    return getUserProfile(user.id);
  }

  /// 사용자 이름으로 사용자를 검색합니다.
  Future<List<UserModel>> searchUsersByUsername(String query) async {
    try {
      if (query.isEmpty) {
        return [];
      }

      // 이름에 query가 포함된 사용자 검색 (대소문자 구분 없음)
      final response = await _supabaseClient
          .from('users')
          .select()
          .ilike('username', '%$query%')
          .limit(20);

      return response.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      print('Failed to search users: $e');
      return [];
    }
  }

  /// 인기 있는 사용자 목록을 가져옵니다 (팔로워가 많은 순).
  Future<List<UserModel>> getPopularUsers({int limit = 10}) async {
    try {
      // 서브쿼리를 사용하여 팔로워 수가 많은 사용자를 가져옵니다
      final response = await _supabaseClient
          .from('users')
          .select('*, followers:follows!follower_id(count)')
          .limit(limit)
          .order('followers', ascending: false);

      return response.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      print('Failed to get popular users: $e');
      return [];
    }
  }

  /// 사용자 추천 목록을 가져옵니다.
  Future<List<UserModel>> getSuggestedUsers({int limit = 5}) async {
    try {
      // 현재 로그인한 사용자
      final currentUser = _supabaseClient.auth.currentUser;
      if (currentUser == null) {
        return await getPopularUsers(limit: limit);
      }

      // 현재 사용자가 팔로우하지 않는 사용자 중에서 가장 인기 있는 사용자 추천
      final followingIds = await _getFollowingIds(currentUser.id);

      // 현재 사용자와 이미 팔로우하는 사용자를 제외하고 추천
      final response = await _supabaseClient
          .from('users')
          .select()
          .not('id', 'in', [currentUser.id, ...followingIds])
          .limit(limit)
          .order('created_at', ascending: false);

      return response.map((user) => UserModel.fromJson(user)).toList();
    } catch (e) {
      print('Failed to get suggested users: $e');
      return [];
    }
  }

  /// 현재 사용자가 팔로우하는 사용자 ID 목록을 가져옵니다.
  Future<List<String>> _getFollowingIds(String userId) async {
    try {
      final response = await _supabaseClient
          .from('follows')
          .select('following_id')
          .eq('follower_id', userId);

      return response
          .map<String>((item) => item['following_id'] as String)
          .toList();
    } catch (e) {
      print('Failed to get following IDs: $e');
      return [];
    }
  }
}
