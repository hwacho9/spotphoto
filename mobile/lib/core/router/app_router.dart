import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:mobile/features/auth/views/login_screen.dart';
import 'package:mobile/features/auth/views/register_screen.dart';
import 'package:mobile/features/home/views/home_screen.dart';
import 'package:mobile/features/explore/views/explore_screen.dart';
import 'package:mobile/features/map/views/map_screen.dart';
import 'package:mobile/features/profile/views/profile_screen.dart';
import 'package:mobile/features/upload/views/upload_screen.dart';
import 'package:mobile/features/splash/views/splash_screen.dart';
import 'package:mobile/features/photo/views/photo_detail_screen.dart';
import 'package:mobile/core/widgets/bottom_nav_bar.dart';
import 'package:mobile/features/auth/view_models/auth_view_model.dart';

part 'app_router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final authState = ref.watch(authViewModelProvider);

  return GoRouter(
    initialLocation: '/splash',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,

    // 인증 상태에 따른 리디렉션 처리
    redirect: (context, state) {
      // 현재 경로
      final currentPath = state.uri.path;

      // 스플래시 화면은 항상 접근 가능
      if (currentPath == '/splash') {
        return null;
      }

      // 로딩 중에는 리디렉션하지 않음
      if (authState.isLoading) {
        return null;
      }

      // 인증이 필요한 경로들
      final isProtectedRoute = currentPath == '/' ||
          currentPath == '/explore' ||
          currentPath == '/map' ||
          currentPath == '/profile' ||
          currentPath == '/upload' ||
          currentPath.startsWith('/photo/');

      // 인증이 필요하지 않은 경로들
      final isAuthRoute = currentPath == '/login' || currentPath == '/register';

      // 인증되지 않은 상태에서 보호된 경로에 접근하려는 경우
      if (!authState.isAuthenticated && isProtectedRoute) {
        return '/login';
      }

      // 이미 인증된 상태에서 인증 경로에 접근하려는 경우
      if (authState.isAuthenticated && isAuthRoute) {
        return '/';
      }

      // 리디렉션 필요 없음
      return null;
    },

    routes: [
      // 스플래시 화면
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // 사진 상세 화면
      GoRoute(
        path: '/photo/:id',
        name: 'photo_detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final photoId = state.pathParameters['id']!;
          return PhotoDetailScreen(photoId: photoId);
        },
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          // Home tab
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),

          // Explore tab
          GoRoute(
            path: '/explore',
            name: 'explore',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ExploreScreen(),
            ),
          ),

          // Map tab
          GoRoute(
            path: '/map',
            name: 'map',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapScreen(),
            ),
          ),

          // Profile tab
          GoRoute(
            path: '/profile',
            name: 'profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // Upload route (accessed via floating action button)
      GoRoute(
        path: '/upload',
        name: 'upload',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const UploadScreen(),
      ),
    ],
  );
}
