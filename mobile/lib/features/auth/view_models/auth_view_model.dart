import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/services/auth_service.dart';
import 'package:mobile/models/user_model.dart';
import 'package:flutter/foundation.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  AuthState build() {
    // 앱 시작 시 자동으로 인증 상태 확인 (비동기적으로 실행)
    Future.microtask(() => checkAuthStatus());
    return const AuthState();
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(email, password);
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      );
      debugPrint('로그인 성공: ${user.username}');
    } catch (e) {
      debugPrint('로그인 실패: $e');
      state = state.copyWith(
          isLoading: false, error: e.toString(), isAuthenticated: false);
      rethrow; // 에러를 다시 던져서 UI에서 처리할 수 있게 함
    }
  }

  Future<void> register(String email, String password, String username) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.register(email, password, username);
      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: true,
        error: null,
      );
      debugPrint('회원가입 성공: ${user.username}');
    } catch (e) {
      debugPrint('회원가입 실패: $e');
      state = state.copyWith(
          isLoading: false, error: e.toString(), isAuthenticated: false);
      rethrow; // 에러를 다시 던져서 UI에서 처리할 수 있게 함
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.logout();
      state = state.copyWith(
        isLoading: false,
        user: null,
        isAuthenticated: false,
        error: null,
      );
      debugPrint('로그아웃 성공');
    } catch (e) {
      debugPrint('로그아웃 실패: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final authService = ref.read(authServiceProvider);
      final user = await authService.getCurrentUser();

      state = state.copyWith(
        isLoading: false,
        user: user,
        isAuthenticated: user != null,
        error: null,
      );

      if (user != null) {
        debugPrint('인증된 사용자: ${user.username}');
      } else {
        debugPrint('인증되지 않은 상태');
      }
    } catch (e) {
      debugPrint('인증 상태 확인 실패: $e');
      state = state.copyWith(
          isLoading: false, error: e.toString(), isAuthenticated: false);
    }
  }

  // 스플래시 화면에서 사용할 메서드
  Future<bool> isAuthenticated() async {
    await checkAuthStatus();
    return state.isAuthenticated;
  }

  // 오류 상태 초기화
  void clearError() {
    state = state.copyWith(error: null);
  }
}

class AuthState {
  final bool isLoading;
  final String? error;
  final UserModel? user;
  final bool isAuthenticated;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.user,
    this.isAuthenticated = false,
  });

  bool get hasError => error != null;

  AuthState copyWith({
    bool? isLoading,
    String? error,
    UserModel? user,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // error는 null을 명시적으로 설정할 수 있도록 함
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}
