import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/services/photo_service.dart';
import 'package:mobile/services/bookmark_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'profile_view_model.freezed.dart';
part 'profile_view_model.g.dart';

@freezed
class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default([]) List<PhotoModel> userPhotos,
    @Default([]) List<PhotoModel> bookmarkedPhotos,
    @Default(0) int selectedTabIndex,
    String? error,
  }) = _ProfileState;
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late final PhotoService _photoService;
  late final BookmarkService _bookmarkService;

  @override
  ProfileState build() {
    _photoService = ref.watch(photoServiceProvider);
    _bookmarkService = ref.watch(bookmarkServiceProvider);
    return const ProfileState();
  }

  /// 사용자의 사진과 북마크한 사진을 로드합니다.
  Future<void> loadUserContent(String userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // 병렬로 데이터 로드
      final userPhotos = await _photoService.getUserPhotos(userId);
      final bookmarkedPhotos = await _bookmarkService.getUserBookmarkedPhotos();

      state = state.copyWith(
        isLoading: false,
        userPhotos: userPhotos,
        bookmarkedPhotos: bookmarkedPhotos,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '사용자 콘텐츠를 불러오는 중 오류가 발생했습니다: $e',
      );
    }
  }

  /// 선택된 탭 인덱스를 변경합니다.
  void setSelectedTabIndex(int index) {
    state = state.copyWith(selectedTabIndex: index);
  }

  /// 사진을 북마크합니다.
  Future<void> toggleBookmark(String photoId) async {
    try {
      await _bookmarkService.toggleBookmark(photoId);

      // 북마크 목록 새로고침
      final bookmarkedPhotos = await _bookmarkService.getUserBookmarkedPhotos();

      // 내 사진 목록에서도 북마크 상태 업데이트
      final updatedUserPhotos = state.userPhotos.map((photo) {
        if (photo.id == photoId) {
          // 북마크 상태 확인
          final isBookmarked = bookmarkedPhotos.any((p) => p.id == photoId);
          return photo.copyWith(isLiked: isBookmarked);
        }
        return photo;
      }).toList();

      state = state.copyWith(
        bookmarkedPhotos: bookmarkedPhotos,
        userPhotos: updatedUserPhotos,
      );
    } catch (e) {
      state = state.copyWith(
        error: '북마크 처리 중 오류가 발생했습니다: $e',
      );
    }
  }
}
