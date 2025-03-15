import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ExploreScreen extends HookConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('탐색'),
        centerTitle: false,
      ),
      body: const ExploreTab(),
    );
  }
}

class ExploreTab extends StatefulWidget {
  const ExploreTab({super.key});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: '장소, 태그 검색',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey.shade200,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const TagList(),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.trending_up),
              text: '트렌드',
            ),
            Tab(
              icon: Icon(Icons.people),
              text: '팔로잉',
            ),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              TrendingList(),
              FollowingFeed(),
            ],
          ),
        ),
      ],
    );
  }
}

class TagList extends StatelessWidget {
  const TagList({super.key});

  @override
  Widget build(BuildContext context) {
    final tags = ['#벚꽃', '#야경', '#카페', '#한강', '#전시회', '#데이트'];

    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: tags.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                tags[index],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final trendingSpots = [
      TrendingSpot(
        id: 1,
        rank: 1,
        image: 'assets/images/placeholder.jpg',
        title: '남산 서울타워',
        location: '서울 용산구',
        likes: 2400,
      ),
      TrendingSpot(
        id: 2,
        rank: 2,
        image: 'assets/images/placeholder.jpg',
        title: '경복궁',
        location: '서울 종로구',
        likes: 1800,
      ),
      TrendingSpot(
        id: 3,
        rank: 3,
        image: 'assets/images/placeholder.jpg',
        title: '한강 공원',
        location: '서울 영등포구',
        likes: 1600,
      ),
      TrendingSpot(
        id: 4,
        rank: 4,
        image: 'assets/images/placeholder.jpg',
        title: '북촌 한옥마을',
        location: '서울 종로구',
        likes: 1400,
      ),
      TrendingSpot(
        id: 5,
        rank: 5,
        image: 'assets/images/placeholder.jpg',
        title: '덕수궁',
        location: '서울 중구',
        likes: 1200,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: trendingSpots.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '지금 뜨는 장소',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        final spot = trendingSpots[index - 1];
        return TrendingSpotItem(spot: spot);
      },
    );
  }
}

class TrendingSpot {
  final int id;
  final int rank;
  final String image;
  final String title;
  final String location;
  final int likes;

  const TrendingSpot({
    required this.id,
    required this.rank,
    required this.image,
    required this.title,
    required this.location,
    required this.likes,
  });
}

class TrendingSpotItem extends StatelessWidget {
  final TrendingSpot spot;

  const TrendingSpotItem({super.key, required this.spot});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                child: Text(
                  '${spot.rank}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade300,
                  image: DecorationImage(
                    image: AssetImage(spot.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      spot.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          spot.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 12,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${spot.likes}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FollowingFeed extends StatelessWidget {
  const FollowingFeed({super.key});

  @override
  Widget build(BuildContext context) {
    final followingPosts = [
      FollowingPost(
        id: 1,
        user: User(
          name: '김민지',
          avatar: 'assets/images/placeholder.jpg',
        ),
        image: 'assets/images/placeholder.jpg',
        title: '서울숲 단풍',
        location: '서울 성동구',
        likes: 128,
      ),
      FollowingPost(
        id: 2,
        user: User(
          name: '이준호',
          avatar: 'assets/images/placeholder.jpg',
        ),
        image: 'assets/images/placeholder.jpg',
        title: '청계천 야경',
        location: '서울 중구',
        likes: 95,
      ),
      FollowingPost(
        id: 3,
        user: User(
          name: '박지영',
          avatar: 'assets/images/placeholder.jpg',
        ),
        image: 'assets/images/placeholder.jpg',
        title: '홍대 거리',
        location: '서울 마포구',
        likes: 210,
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: followingPosts.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              '팔로잉 피드',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        final post = followingPosts[index - 1];
        return FollowingPostCard(post: post);
      },
    );
  }
}

class User {
  final String name;
  final String avatar;

  const User({
    required this.name,
    required this.avatar,
  });
}

class FollowingPost {
  final int id;
  final User user;
  final String image;
  final String title;
  final String location;
  final int likes;

  const FollowingPost({
    required this.id,
    required this.user,
    required this.image,
    required this.title,
    required this.location,
    required this.likes,
  });
}

class FollowingPostCard extends StatelessWidget {
  final FollowingPost post;

  const FollowingPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(post.user.avatar),
                ),
                const SizedBox(width: 8),
                Text(
                  post.user.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              post.image,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.location,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post.likes}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
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
