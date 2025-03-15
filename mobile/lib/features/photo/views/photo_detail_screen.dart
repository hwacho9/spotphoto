import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/services/photo_service.dart';
import 'package:mobile/services/bookmark_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoDetailScreen extends HookConsumerWidget {
  final String photoId;

  const PhotoDetailScreen({
    super.key,
    required this.photoId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photoService = ref.watch(photoServiceProvider);
    final bookmarkService = ref.watch(bookmarkServiceProvider);
    final photoAsync = useState<PhotoModel?>(null);
    final isLoading = useState(true);
    final error = useState<String?>(null);
    final isBookmarked = useState(false);

    // 사진 정보 로드
    useEffect(() {
      Future<void> loadPhoto() async {
        try {
          isLoading.value = true;
          error.value = null;

          // 실제 API 호출 대신 목 데이터 사용
          if (photoId.startsWith('mock-')) {
            // 목 데이터 사용
            final mockIndex = int.tryParse(photoId.split('-').last) ?? 1;
            photoAsync.value = PhotoModel(
              id: photoId,
              userId: 'user-${mockIndex % 3 + 1}',
              url: 'https://picsum.photos/seed/$mockIndex/500/500',
              location:
                  '서울 ${mockIndex % 3 == 0 ? '강남구' : mockIndex % 3 == 1 ? '마포구' : '종로구'} 인기 장소 $mockIndex',
              tags: ['인기', '서울', mockIndex % 2 == 0 ? '야경' : '풍경'],
              description: '아름다운 장소입니다. 사진 찍기 좋은 곳이에요!',
              uploadedAt: DateTime.now().subtract(Duration(days: mockIndex)),
              likeCount: mockIndex * 10,
              isLiked: mockIndex % 3 == 0,
              username: '사용자${mockIndex % 3 + 1}',
            );
            isBookmarked.value = mockIndex % 3 == 0;
          } else {
            // 실제 API 호출
            try {
              final photo = await photoService.getPhotoById(photoId);
              photoAsync.value = photo;

              // 북마크 상태 확인
              final bookmarks = await bookmarkService.getUserBookmarkedPhotos();
              isBookmarked.value = bookmarks.any((p) => p.id == photoId);
            } catch (e) {
              log('Error loading photo: $e');
              error.value = '사진을 불러오는 중 오류가 발생했습니다: $e';
            }
          }

          isLoading.value = false;
        } catch (e) {
          isLoading.value = false;
          error.value = '사진을 불러오는 중 오류가 발생했습니다: $e';
          log('Error loading photo: $e');
        }
      }

      loadPhoto();
      return null;
    }, [photoId]);

    // 로딩 중
    if (isLoading.value) {
      return Scaffold(
        appBar: AppBar(title: const Text('사진 상세')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 오류 발생
    if (error.value != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('사진 상세')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                error.value!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // 다시 로드
                  Navigator.of(context).pop();
                },
                child: const Text('돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    final photo = photoAsync.value;
    if (photo == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('사진 상세')),
        body: const Center(child: Text('사진을 찾을 수 없습니다')),
      );
    }

    // 이미지 URL 처리
    String? imageUrl = photo.url;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      try {
        // Supabase 스토리지 URL 생성
        final supabase = Supabase.instance.client;

        // URL에서 버킷 이름과 경로 추출
        String path = imageUrl;
        String bucket = 'photos';

        // 경로에 버킷 이름이 포함되어 있는 경우 제거
        if (path.startsWith('$bucket/')) {
          path = path.substring(bucket.length + 1);
        }

        // 공개 URL 생성
        imageUrl = supabase.storage.from(bucket).getPublicUrl(path);
        log('Generated image URL: $imageUrl');
      } catch (e) {
        log('Error generating image URL: $e');
        imageUrl = null;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('사진 상세'),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked.value ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: () async {
              try {
                await bookmarkService.toggleBookmark(photoId);
                isBookmarked.value = !isBookmarked.value;
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('북마크 처리 중 오류가 발생했습니다: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 공유 기능 구현
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 사진 이미지
            imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    placeholder: (context, url) => AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) {
                      log('Error loading image: $url, Error: $error');
                      return AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.broken_image_outlined,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),

            // 사진 정보
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 위치
                  Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          photo.location ?? '위치 정보 없음',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // 설명
                  if (photo.description != null &&
                      photo.description!.isNotEmpty) ...[
                    Text(
                      photo.description!,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 태그
                  if (photo.tags.isNotEmpty) ...[
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: photo.tags.map((tag) {
                        return Chip(
                          label: Text('#$tag'),
                          backgroundColor: Colors.grey[200],
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // 업로드 정보
                  Text(
                    '업로드: ${_formatDate(photo.uploadedAt ?? DateTime.now())}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),

                  // 좋아요 정보
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(
                        '${photo.likeCount} 좋아요',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),

                  // 사용자 정보
                  if (photo.username != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(
                          photo.username!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 날짜 포맷 함수
  String _formatDate(DateTime date) {
    return '${date.year}년 ${date.month}월 ${date.day}일';
  }
}
