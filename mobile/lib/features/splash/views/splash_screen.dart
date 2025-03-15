import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 화면이 빌드된 후 인증 상태 확인
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuthState(context);
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 앱 로고 또는 아이콘
            Icon(
              Icons.photo_camera,
              size: 80,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            const SizedBox(height: 24),
            // 앱 이름
            Text(
              '사진 스팟 앱',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            const SizedBox(height: 48),
            // 로딩 인디케이터
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );
  }

  // 인증 상태 확인 및 리디렉션
  Future<void> _checkAuthState(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2)); // 스플래시 화면을 잠시 보여줌

    final currentUser = Supabase.instance.client.auth.currentUser;

    if (!context.mounted) return;

    if (currentUser != null) {
      // 로그인된 상태면 홈 화면으로 이동
      context.go('/');
    } else {
      // 로그인되지 않은 상태면 로그인 화면으로 이동
      context.go('/login');
    }
  }
}
