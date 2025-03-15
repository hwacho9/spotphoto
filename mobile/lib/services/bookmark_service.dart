import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/repositories/bookmark_repository.dart';

part 'bookmark_service.g.dart';

@riverpod
BookmarkService bookmarkService(BookmarkServiceRef ref) {
  final bookmarkRepository = ref.watch(bookmarkRepositoryProvider);
  return BookmarkService(bookmarkRepository);
}

/// 북마크 관련 비즈니스 로직을 처리하는 서비스
class BookmarkService {
  final BookmarkRepository _bookmarkRepository;

  BookmarkService(this._bookmarkRepository);

  /// 사용자의 북마크한 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getUserBookmarkedPhotos() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    return await _bookmarkRepository.getUserBookmarkedPhotos(user.id);
  }

  /// 사진이 북마크되었는지 확인합니다.
  Future<bool> isPhotoBookmarked(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false; // 로그인하지 않은 경우 북마크되지 않은 것으로 처리
    }

    return await _bookmarkRepository.isPhotoBookmarked(user.id, photoId);
  }

  /// 특정 사진의 북마크 수를 가져옵니다.
  Future<int> getPhotoBookmarkCount(String photoId) async {
    return await _bookmarkRepository.getPhotoBookmarkCount(photoId);
  }

  /// 사진을 북마크합니다.
  Future<void> bookmarkPhoto(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    await _bookmarkRepository.bookmarkPhoto(user.id, photoId);
  }

  /// 사진 북마크를 취소합니다.
  Future<void> unbookmarkPhoto(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    await _bookmarkRepository.unbookmarkPhoto(user.id, photoId);
  }

  /// 북마크 상태를 토글합니다.
  Future<bool> toggleBookmark(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    final isBookmarked = await isPhotoBookmarked(photoId);

    if (isBookmarked) {
      await unbookmarkPhoto(photoId);
      return false;
    } else {
      await bookmarkPhoto(photoId);
      return true;
    }
  }
}
