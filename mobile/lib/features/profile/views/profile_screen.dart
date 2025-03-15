import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/features/profile/view_models/profile_view_model.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/core/widgets/photo_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/services/follow_service.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileViewModel = ref.watch(profileViewModelProvider);
    final currentUser = Supabase.instance.client.auth.currentUser;

    // 화면이 처음 로드될 때 사용자 콘텐츠 로드
    useEffect(() {
      if (currentUser != null) {
        Future.microtask(() => ref
            .read(profileViewModelProvider.notifier)
            .loadUserContent(currentUser.id));
      }
      return null;
    }, []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('프로필'),
        centerTitle: true,
      ),
      body: currentUser == null
          ? const _NotLoggedInView()
          : DefaultTabController(
              length: 2,
              child: _ProfileContent(
                profileState: profileViewModel,
                onToggleBookmark: (photoId) => ref
                    .read(profileViewModelProvider.notifier)
                    .toggleBookmark(photoId),
              ),
            ),
    );
  }
}

class _NotLoggedInView extends StatelessWidget {
  const _NotLoggedInView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          const Text(
            '로그인이 필요합니다',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // 로그인 화면으로 이동
            },
            child: const Text('로그인하기'),
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends HookConsumerWidget {
  final ProfileState profileState;
  final Function(String) onToggleBookmark;

  const _ProfileContent({
    required this.profileState,
    required this.onToggleBookmark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = Supabase.instance.client.auth.currentUser;
    final tabController = DefaultTabController.of(context);
    final selectedTabIndex = useState(0);

    // 팔로워, 팔로잉 카운트를 위한 상태 변수
    final followerCount = useState(0);
    final followingCount = useState(0);
    final isLoading = useState(false);

    // 팔로워, 팔로잉 카운트 로드
    useEffect(() {
      if (user != null) {
        isLoading.value = true;
        Future.wait([
          ref.read(followServiceProvider).getFollowerCount(user.id),
          ref.read(followServiceProvider).getFollowingCount(user.id),
        ]).then((results) {
          if (results.length == 2) {
            followerCount.value = results[0];
            followingCount.value = results[1];
          }
          isLoading.value = false;
        }).catchError((error) {
          print('팔로워/팔로잉 카운트 로드 실패: $error');
          isLoading.value = false;
        });
      }
      return null;
    }, [user?.id]);

    // 탭 컨트롤러 리스너 설정
    useEffect(() {
      void listener() {
        if (tabController != null) {
          selectedTabIndex.value = tabController.index;
          ref
              .read(profileViewModelProvider.notifier)
              .setSelectedTabIndex(tabController.index);
        }
      }

      if (tabController != null) {
        tabController.addListener(listener);
        return () => tabController.removeListener(listener);
      }
      return null;
    }, [tabController]);

    return Column(
      children: [
        // 프로필 정보
        _ProfileHeader(
          user: user,
          photoCount: profileState.userPhotos.length,
          followerCount: followerCount.value,
          followingCount: followingCount.value,
        ),

        // 프로필 편집 버튼
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 프로필 편집 화면으로 이동
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              child: const Text('프로필 편집'),
            ),
          ),
        ),

        // 내 사진/북마크 버튼
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  tabController?.animateTo(0);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedTabIndex.value == 0
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.grid_on),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  tabController?.animateTo(1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: selectedTabIndex.value == 1
                            ? Colors.black
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: const Icon(Icons.bookmark_border),
                ),
              ),
            ),
          ],
        ),

        // 탭 콘텐츠
        Expanded(
          child: TabBarView(
            children: [
              // 내 사진 탭
              _PhotosTab(
                photos: profileState.userPhotos,
                onToggleBookmark: onToggleBookmark,
                isLoading: profileState.isLoading,
                error: profileState.error,
              ),
              // 북마크 탭
              _BookmarksTab(
                photos: profileState.bookmarkedPhotos,
                onToggleBookmark: onToggleBookmark,
                isLoading: profileState.isLoading,
                error: profileState.error,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final User? user;
  final int photoCount;
  final int followerCount;
  final int followingCount;

  const _ProfileHeader({
    required this.user,
    required this.photoCount,
    required this.followerCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 프로필 이미지
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade200,
            child: Text(
              user?.email?.substring(0, 1).toUpperCase() ?? 'U',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),

          // 사용자 이름
          Text(
            user?.email?.split('@').first ?? '사용자',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          // 팔로워, 팔로잉, 스팟 카운트
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatColumn(context, followerCount, '팔로워'),
              _buildStatColumn(context, photoCount, '사진'),
              _buildStatColumn(context, followingCount, '팔로잉'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, int number, String label) {
    return Column(
      children: [
        Text(
          number.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _PhotosTab extends HookConsumerWidget {
  final List<PhotoModel> photos;
  final Function(String) onToggleBookmark;
  final bool isLoading;
  final String? error;

  const _PhotosTab({
    required this.photos,
    required this.onToggleBookmark,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  // 다시 로드
                  ref
                      .read(profileViewModelProvider.notifier)
                      .loadUserContent(user.id);
                }
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (photos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.photo_library, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '아직 업로드한 사진이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PhotoGrid(
        photos: photos,
        onToggleBookmark: onToggleBookmark,
        isMyPhotos: true,
      ),
    );
  }
}

class _BookmarksTab extends HookConsumerWidget {
  final List<PhotoModel> photos;
  final Function(String) onToggleBookmark;
  final bool isLoading;
  final String? error;

  const _BookmarksTab({
    required this.photos,
    required this.onToggleBookmark,
    this.isLoading = false,
    this.error,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              error!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final user = Supabase.instance.client.auth.currentUser;
                if (user != null) {
                  // 다시 로드
                  ref
                      .read(profileViewModelProvider.notifier)
                      .loadUserContent(user.id);
                }
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (photos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              '아직 북마크한 사진이 없습니다',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: PhotoGrid(
        photos: photos,
        onToggleBookmark: onToggleBookmark,
      ),
    );
  }
}
