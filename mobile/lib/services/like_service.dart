import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/repositories/like_repository.dart';

part 'like_service.g.dart';

@riverpod
LikeService likeService(LikeServiceRef ref) {
  final likeRepository = ref.watch(likeRepositoryProvider);
  return LikeService(likeRepository);
}

/// 좋아요 관련 비즈니스 로직을 처리하는 서비스
class LikeService {
  final LikeRepository _likeRepository;

  LikeService(this._likeRepository);

  /// 특정 사진의 좋아요 수를 가져옵니다.
  Future<int> getPhotoLikeCount(String photoId) async {
    return await _likeRepository.getPhotoLikeCount(photoId);
  }

  /// 사진이 좋아요되었는지 확인합니다.
  Future<bool> isPhotoLiked(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      return false; // 로그인하지 않은 경우 좋아요되지 않은 것으로 처리
    }

    return await _likeRepository.isPhotoLiked(user.id, photoId);
  }

  /// 좋아요 상태를 토글합니다.
  Future<bool> toggleLike(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    final isLiked = await _likeRepository.isPhotoLiked(user.id, photoId);

    if (isLiked) {
      await _likeRepository.unlikePhoto(user.id, photoId);
      return false;
    } else {
      await _likeRepository.likePhoto(user.id, photoId);
      return true;
    }
  }
}
