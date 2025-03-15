import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/services/photo_service.dart';
import 'package:mobile/services/bookmark_service.dart';
import 'package:mobile/core/widgets/photo_grid.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 스팟 앱'),
        centerTitle: false,
      ),
      body: const HomeTab(),
    );
  }
}

class HomeTab extends HookConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 목 데이터 생성
    final mockPhotos = useState<List<PhotoModel>>(_getMockPhotos());
    final isLoading = useState(false);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const TrendingBanner(),
            const SizedBox(height: 24),
            const Text(
              '인기 사진',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // 사진 그리드 (목 데이터 사용)
            if (isLoading.value)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              SizedBox(
                height: 1000, // 적절한 높이 설정
                child: PhotoGrid(
                  photos: mockPhotos.value,
                  onToggleBookmark: (photoId) {
                    // 목 데이터에서 북마크 토글
                    final updatedPhotos = mockPhotos.value.map((photo) {
                      if (photo.id == photoId) {
                        return photo.copyWith(isLiked: !photo.isLiked);
                      }
                      return photo;
                    }).toList();
                    mockPhotos.value = updatedPhotos;
                  },
                  onPhotoTap: (photo) {
                    context.push('/photo/${photo.id}');
                  },
                ),
              ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 목 데이터 생성 함수
  List<PhotoModel> _getMockPhotos() {
    return List.generate(
      10,
      (index) => PhotoModel(
        id: 'mock-${index + 1}',
        userId: 'user-${index % 3 + 1}',
        url: 'https://picsum.photos/seed/${index + 1}/500/500',
        location:
            '서울 ${index % 3 == 0 ? '강남구' : index % 3 == 1 ? '마포구' : '종로구'} 인기 장소 ${index + 1}',
        tags: ['인기', '서울', index % 2 == 0 ? '야경' : '풍경'],
        description: '아름다운 장소입니다. 사진 찍기 좋은 곳이에요!',
        uploadedAt: DateTime.now().subtract(Duration(days: index)),
        likeCount: (index + 1) * 10,
        isLiked: index % 3 == 0,
        username: '사용자${index % 3 + 1}',
      ),
    );
  }
}

class TrendingBanner extends StatelessWidget {
  const TrendingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
        image: const DecorationImage(
          image: AssetImage('assets/images/placeholder.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                '오늘의 핫스팟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '남산 서울타워 야경',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.white70,
                  size: 14,
                ),
                const SizedBox(width: 4),
                const Text(
                  '서울 용산구',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.favorite,
                  color: Colors.white70,
                  size: 14,
                ),
                const SizedBox(width: 4),
                const Text(
                  '2.4k',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
