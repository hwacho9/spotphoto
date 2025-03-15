import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/repositories/photo_repository.dart';
import 'package:mobile/repositories/trend_repository.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  Future<List<PhotoModel>> build() async {
    return _fetchHomePhotos();
  }

  Future<List<PhotoModel>> _fetchHomePhotos() async {
    final photoRepository = ref.read(photoRepositoryProvider);
    final trendRepository = ref.read(trendRepositoryProvider);

    try {
      // Get trending photos
      final trendingPhotos = await trendRepository.getTrendingPhotos();

      // Get recommended photos
      final recommendedPhotos = await photoRepository.getRecommendedPhotos();

      // Combine and return
      return [...trendingPhotos, ...recommendedPhotos];
    } catch (e) {
      // Log error
      throw Exception('Failed to load home photos: $e');
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final photos = await _fetchHomePhotos();
      state = AsyncValue.data(photos);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}
