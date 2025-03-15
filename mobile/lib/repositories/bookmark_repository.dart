import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/bookmark_model.dart';
import 'package:mobile/models/photo_model.dart';

part 'bookmark_repository.g.dart';

@riverpod
BookmarkRepository bookmarkRepository(BookmarkRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return BookmarkRepository(supabase);
}

/// 북마크 관련 데이터베이스 작업을 담당하는 Repository
class BookmarkRepository {
  final SupabaseClient _supabaseClient;

  BookmarkRepository(this._supabaseClient);

  /// 사용자의 북마크 목록을 가져옵니다.
  Future<List<BookmarkModel>> getUserBookmarks(String userId) async {
    try {
      final response = await _supabaseClient
          .from('bookmarks')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((bookmark) => BookmarkModel.fromJson(bookmark))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookmarks: $e');
    }
  }

  /// 사용자의 북마크한 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getUserBookmarkedPhotos(String userId) async {
    try {
      final response = await _supabaseClient
          .from('bookmarks')
          .select('*, photos:photo_id(*)')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return response
          .map((bookmark) => PhotoModel.fromJson(bookmark['photos']))
          .toList();
    } catch (e) {
      throw Exception('Failed to get user bookmarked photos: $e');
    }
  }

  /// 사진이 북마크되었는지 확인합니다.
  Future<bool> isPhotoBookmarked(String userId, String photoId) async {
    try {
      final response = await _supabaseClient
          .from('bookmarks')
          .select('id')
          .eq('user_id', userId)
          .eq('photo_id', photoId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      throw Exception('Failed to check if photo is bookmarked: $e');
    }
  }

  /// 특정 사진의 북마크 수를 가져옵니다.
  Future<int> getPhotoBookmarkCount(String photoId) async {
    try {
      final response = await _supabaseClient
          .from('bookmarks')
          .count()
          .eq('photo_id', photoId);

      // count 메서드는 정수 값을 반환
      return response;
    } catch (e) {
      // 오류 발생 시 0을 반환하고 로그 기록
      print('Failed to get photo bookmark count: $e');
      return 0;
    }
  }

  /// 사진을 북마크합니다.
  Future<void> bookmarkPhoto(String userId, String photoId) async {
    try {
      // 이미 북마크되어 있는지 확인
      final isAlreadyBookmarked = await isPhotoBookmarked(userId, photoId);
      if (isAlreadyBookmarked) {
        return; // 이미 북마크되어 있으면 아무 작업도 하지 않음
      }

      await _supabaseClient.from('bookmarks').insert({
        'user_id': userId,
        'photo_id': photoId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to bookmark photo: $e');
    }
  }

  /// 사진 북마크를 취소합니다.
  Future<void> unbookmarkPhoto(String userId, String photoId) async {
    try {
      await _supabaseClient
          .from('bookmarks')
          .delete()
          .match({'user_id': userId, 'photo_id': photoId});
    } catch (e) {
      throw Exception('Failed to unbookmark photo: $e');
    }
  }
}
