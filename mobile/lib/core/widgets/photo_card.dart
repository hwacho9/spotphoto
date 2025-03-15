import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/services/like_service.dart';
import 'package:mobile/services/bookmark_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PhotoCard extends ConsumerStatefulWidget {
  final PhotoModel photo;
  final bool showActions;
  final VoidCallback? onImageTap;

  const PhotoCard({
    super.key,
    required this.photo,
    this.showActions = true,
    this.onImageTap,
  });

  @override
  ConsumerState<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends ConsumerState<PhotoCard> {
  late bool isLiked;
  late bool isBookmarked;
  late int likeCount;
  late int bookmarkCount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // 초기 값 설정
    isLiked = widget.photo.isLiked ?? false;
    likeCount = widget.photo.likeCount ?? 0;
    isBookmarked = false; // 초기값은 false로 설정
    bookmarkCount = 0; // 초기값은 0으로 설정

    // 비동기로 북마크 상태와 카운트 로드
    _loadBookmarkStatus();
    _loadBookmarkCount();
  }

  Future<void> _loadBookmarkStatus() async {
    try {
      final bookmarkService = ref.read(bookmarkServiceProvider);
      final status = await bookmarkService.isPhotoBookmarked(widget.photo.id);
      if (mounted) {
        setState(() {
          isBookmarked = status;
        });
      }
    } catch (e) {
      log('Failed to load bookmark status: $e');
    }
  }

  Future<void> _loadBookmarkCount() async {
    try {
      final bookmarkService = ref.read(bookmarkServiceProvider);
      final count =
          await bookmarkService.getPhotoBookmarkCount(widget.photo.id);
      if (mounted) {
        setState(() {
          bookmarkCount = count;
        });
      }
    } catch (e) {
      log('Failed to load bookmark count: $e');
    }
  }

  Future<void> _toggleLike() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final likeService = ref.read(likeServiceProvider);
      final result = await likeService.toggleLike(widget.photo.id);

      if (mounted) {
        setState(() {
          isLiked = result;
          likeCount = isLiked ? likeCount + 1 : likeCount - 1;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Failed to toggle like: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('좋아요 처리 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _toggleBookmark() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      final bookmarkService = ref.read(bookmarkServiceProvider);
      final result = await bookmarkService.toggleBookmark(widget.photo.id);

      if (mounted) {
        setState(() {
          isBookmarked = result;
          bookmarkCount = isBookmarked ? bookmarkCount + 1 : bookmarkCount - 1;
          isLoading = false;
        });
      }
    } catch (e) {
      log('Failed to toggle bookmark: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('북마크 처리 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사진 헤더 (작성자 정보)
          _buildPhotoHeader(),

          // 이미지
          _buildImageSection(),

          // 액션 버튼들 (좋아요, 북마크 등)
          if (widget.showActions) _buildActionButtons(),

          // 좋아요 카운트
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              '좋아요 $likeCount개',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          // 사진 설명
          if (widget.photo.description != null &&
              widget.photo.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Text(
                widget.photo.description!,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // 위치 정보
          if (widget.photo.location != null &&
              widget.photo.location!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      widget.photo.location!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhotoHeader() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.grey[200],
            backgroundImage: widget.photo.userProfileUrl != null &&
                    widget.photo.userProfileUrl!.isNotEmpty
                ? CachedNetworkImageProvider(widget.photo.userProfileUrl!)
                : null,
            child: widget.photo.userProfileUrl == null ||
                    widget.photo.userProfileUrl!.isEmpty
                ? const Icon(Icons.person, size: 16, color: Colors.grey)
                : null,
          ),
          const SizedBox(width: 12),

          // 사용자 이름
          Expanded(
            child: Text(
              widget.photo.username ?? '알 수 없는 사용자',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // 메뉴 버튼
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // 메뉴 표시
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            iconSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    String? imageUrl = widget.photo.url;

    // URL 처리
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      try {
        final supabase = Supabase.instance.client;
        final String path = imageUrl;
        final String bucket = 'photos';
        imageUrl = supabase.storage.from(bucket).getPublicUrl(path);
      } catch (e) {
        log('Error generating image URL: $e');
        imageUrl = null;
      }
    }

    return GestureDetector(
      onTap: widget.onImageTap,
      child: AspectRatio(
        aspectRatio: 1,
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) {
                  log('Error loading image: $error');
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          // 좋아요 버튼
          IconButton(
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : null,
            ),
            onPressed: _toggleLike,
          ),

          // 댓글 버튼
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              // 댓글 화면으로 이동
            },
          ),

          // 공유 버튼
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 공유 기능
            },
          ),

          const Spacer(),

          // 북마크 버튼
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
    );
  }
}
