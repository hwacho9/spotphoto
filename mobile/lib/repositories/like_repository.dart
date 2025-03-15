import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/like_model.dart';

part 'like_repository.g.dart';

@riverpod
LikeRepository likeRepository(LikeRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return LikeRepository(supabase);
}

/// 좋아요 관련 데이터베이스 작업을 담당하는 Repository
class LikeRepository {
  final SupabaseClient _supabaseClient;

  LikeRepository(this._supabaseClient);

  /// 특정 사진의 좋아요 수를 가져옵니다.
  Future<int> getPhotoLikeCount(String photoId) async {
    try {
      final response =
          await _supabaseClient.from('likes').count().eq('photo_id', photoId);

      // count 메서드는 정수 값을 반환
      return response;
    } catch (e) {
      // 오류 발생 시 0을 반환하고 로그 기록
      print('Failed to get photo like count: $e');
      return 0;
    }
  }

  /// 사진이 좋아요되었는지 확인합니다.
  Future<bool> isPhotoLiked(String userId, String photoId) async {
    try {
      final response = await _supabaseClient
          .from('likes')
          .select('id')
          .eq('user_id', userId)
          .eq('photo_id', photoId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check if photo is liked: $e');
    }
  }

  /// 사진에 좋아요를 추가합니다.
  Future<void> likePhoto(String userId, String photoId) async {
    try {
      // 이미 좋아요되어 있는지 확인
      final isAlreadyLiked = await isPhotoLiked(userId, photoId);
      if (isAlreadyLiked) {
        return; // 이미 좋아요되어 있으면 아무 작업도 하지 않음
      }

      await _supabaseClient.from('likes').insert({
        'user_id': userId,
        'photo_id': photoId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to like photo: $e');
    }
  }

  /// 사진 좋아요를 취소합니다.
  Future<void> unlikePhoto(String userId, String photoId) async {
    try {
      await _supabaseClient
          .from('likes')
          .delete()
          .match({'user_id': userId, 'photo_id': photoId});
    } catch (e) {
      throw Exception('Failed to unlike photo: $e');
    }
  }
}
