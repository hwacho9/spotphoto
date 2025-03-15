import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoGrid extends StatelessWidget {
  final List<PhotoModel> photos;
  final Function(String) onToggleBookmark;
  final bool showUserInfo;
  final void Function(PhotoModel)? onPhotoTap;
  final bool isMyPhotos;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onToggleBookmark,
    this.showUserInfo = true,
    this.onPhotoTap,
    this.isMyPhotos = false,
  });

  @override
  Widget build(BuildContext context) {
    // 사진이 없을 경우 빈 화면 표시
    if (photos.isEmpty) {
      return const Center(child: Text('사진이 없습니다'));
    }

    // 기존 MasonryGridView 대신 일반 GridView.builder 사용
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        // null 체크 - 잘못된 항목이면 빈 컨테이너 반환
        if (index >= photos.length || photos[index] == null) {
          return const SizedBox.shrink();
        }

        final photo = photos[index];
        return PhotoGridItem(
          photo: photo,
          onTap: () {
            if (onPhotoTap != null) {
              onPhotoTap!(photo);
            } else {
              context.push('/photo/${photo.id}');
            }
          },
          onToggleBookmark: () => onToggleBookmark(photo.id),
          showUserInfo: showUserInfo,
          isMyPhoto: isMyPhotos,
        );
      },
    );
  }
}

// 원래 private class였던 _PhotoGridItem을 public으로 변경
class PhotoGridItem extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback onTap;
  final VoidCallback onToggleBookmark;
  final bool showUserInfo;
  final bool isMyPhoto;

  const PhotoGridItem({
    super.key,
    required this.photo,
    required this.onTap,
    required this.onToggleBookmark,
    required this.showUserInfo,
    this.isMyPhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    try {
      // 이미지 URL 처리
      String? imageUrl = photo.url;

      return GestureDetector(
        onTap: onTap,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 이미지 부분
              _buildImageSection(imageUrl, context),

              // 정보 오버레이
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildInfoOverlay(context),
              ),

              // 북마크 버튼 (내 사진이 아닐 때만 표시)
              if (!isMyPhoto) _buildBookmarkButton(context),
            ],
          ),
        ),
      );
    } catch (e) {
      // 오류 발생 시 기본 UI 표시
      log('Error in PhotoGridItem: $e');
      return Card(
        elevation: 2,
        child: Container(
          padding: const EdgeInsets.all(8),
          alignment: Alignment.center,
          child: const Icon(Icons.error, color: Colors.red),
        ),
      );
    }
  }

  Widget _buildImageSection(String? imageUrl, BuildContext context) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // URL이 이미 완전한 URL인지 확인
    if (!imageUrl.startsWith('http')) {
      try {
        // Supabase 스토리지 URL 생성
        final supabase = Supabase.instance.client;
        String path = imageUrl;
        String bucket = 'photos';
        if (path.startsWith('$bucket/')) {
          path = path.substring(bucket.length + 1);
        }
        imageUrl = supabase.storage.from(bucket).getPublicUrl(path);
      } catch (e) {
        log('Error generating image URL: $e');
        return Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      }
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: Colors.grey[200],
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.grey,
          ),
        ),
      ),
      errorWidget: (context, url, error) {
        log('Error loading image: $url, Error: $error');
        return Container(
          color: Colors.grey[200],
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
      cacheKey: photo.id,
    );
  }

  Widget _buildInfoOverlay(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 위치 정보
          if (photo.location != null && photo.location!.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    photo.location ?? '위치 정보 없음',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

          // 작성자 정보
          if (photo.username != null && showUserInfo) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 12,
                  color: Colors.white70,
                ),
                const SizedBox(width: 4),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    photo.username!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: 4),

          // 좋아요 수와 북마크 수
          FutureBuilder<int>(
              future: _getBookmarkCount(),
              builder: (context, snapshot) {
                final bookmarkCount = snapshot.data ?? 0;

                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 좋아요 수
                    const Icon(
                      Icons.favorite,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      (photo.likeCount ?? 0).toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 북마크 수
                    const Icon(
                      Icons.bookmark,
                      size: 12,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$bookmarkCount',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  // 북마크 카운트를 가져오는 메서드
  Future<int> _getBookmarkCount() async {
    try {
      final supabase = Supabase.instance.client;
      final response =
          await supabase.from('bookmarks').count().eq('photo_id', photo.id);

      return response;
    } catch (e) {
      log('Error getting bookmark count: $e');
      return 0;
    }
  }

  Widget _buildBookmarkButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: FutureBuilder<bool>(
          future: _isPhotoBookmarked(),
          builder: (context, snapshot) {
            final isBookmarked = snapshot.data ?? false;

            return Container(
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
              ),
              child: IconButton(
                icon: Icon(
                  isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: onToggleBookmark,
                constraints: const BoxConstraints(
                  minHeight: 24,
                  minWidth: 24,
                ),
                padding: EdgeInsets.zero,
                iconSize: 18,
              ),
            );
          }),
    );
  }

  // 사진이 북마크되었는지 확인하는 메서드
  Future<bool> _isPhotoBookmarked() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      if (user == null) return false;

      final response = await supabase
          .from('bookmarks')
          .select('id')
          .eq('user_id', user.id)
          .eq('photo_id', photo.id)
          .maybeSingle();

      return response != null;
    } catch (e) {
      log('Error checking if photo is bookmarked: $e');
      return false;
    }
  }
}
