import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile/features/home/view_models/home_view_model.dart';
import 'package:mobile/features/auth/view_models/auth_view_model.dart';

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

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            TrendingBanner(),
            SizedBox(height: 24),
            Text(
              '내 주변 인기 스팟',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            MasonryGrid(),
            SizedBox(height: 16),
          ],
        ),
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

class MasonryGrid extends StatelessWidget {
  const MasonryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final photos = [
      Photo(
        id: 1,
        image: 'assets/images/placeholder.jpg',
        title: '경복궁 야경',
        location: '서울 종로구',
        likes: 1240,
        height: 200,
      ),
      Photo(
        id: 2,
        image: 'assets/images/placeholder.jpg',
        title: '한강 공원 석양',
        location: '서울 영등포구',
        likes: 890,
        height: 150,
      ),
      Photo(
        id: 3,
        image: 'assets/images/placeholder.jpg',
        title: '북촌 한옥마을',
        location: '서울 종로구',
        likes: 1560,
        height: 250,
      ),
      Photo(
        id: 4,
        image: 'assets/images/placeholder.jpg',
        title: '덕수궁 돌담길',
        location: '서울 중구',
        likes: 760,
        height: 175,
      ),
      Photo(
        id: 5,
        image: 'assets/images/placeholder.jpg',
        title: '서울숲 산책로',
        location: '서울 성동구',
        likes: 980,
        height: 225,
      ),
      Photo(
        id: 6,
        image: 'assets/images/placeholder.jpg',
        title: '청계천 야경',
        location: '서울 중구',
        likes: 1120,
        height: 160,
      ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              for (var i = 0; i < photos.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PhotoCard(photo: photos[i]),
                ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              for (var i = 1; i < photos.length; i += 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PhotoCard(photo: photos[i]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class Photo {
  final int id;
  final String image;
  final String title;
  final String location;
  final int likes;
  final double height;

  const Photo({
    required this.id,
    required this.image,
    required this.title,
    required this.location,
    required this.likes,
    required this.height,
  });
}

class PhotoCard extends StatelessWidget {
  final Photo photo;

  const PhotoCard({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: photo.height,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: AssetImage(photo.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.bookmark_outline,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: () {},
                    constraints: const BoxConstraints(
                      minHeight: 32,
                      minWidth: 32,
                    ),
                    padding: EdgeInsets.zero,
                    iconSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  photo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          photo.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          photo.likes.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
