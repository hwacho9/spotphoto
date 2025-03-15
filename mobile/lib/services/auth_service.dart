import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/user_model.dart';
import 'package:flutter/foundation.dart';

part 'auth_service.g.dart';

@riverpod
AuthService authService(AuthServiceRef ref) {
  final supabase = Supabase.instance.client;
  return AuthService(supabase);
}

class AuthService {
  final SupabaseClient _supabaseClient;

  AuthService(this._supabaseClient);

  Future<UserModel> login(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('로그인에 실패했습니다.');
      }

      return await _getUserProfile(response.user!.id);
    } on AuthException catch (e) {
      if (e.statusCode == 400) {
        throw Exception('이메일 또는 비밀번호가 올바르지 않습니다.');
      } else {
        throw Exception('로그인에 실패했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('로그인에 실패했습니다: $e');
    }
  }

  Future<UserModel> register(
      String email, String password, String username) async {
    try {
      // 이미 등록된 이메일인지 확인
      final existingUsers = await _supabaseClient
          .from('users')
          .select('email')
          .eq('email', email);

      if (existingUsers.isNotEmpty) {
        throw Exception('이미 등록된 이메일입니다.');
      }

      // 이미 등록된 사용자 이름인지 확인
      final existingUsernames = await _supabaseClient
          .from('users')
          .select('username')
          .eq('username', username);

      if (existingUsernames.isNotEmpty) {
        throw Exception('이미 사용 중인 사용자 이름입니다.');
      }

      // 회원가입 진행
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('회원가입에 실패했습니다.');
      }

      // Create user profile
      await _supabaseClient.from('users').insert({
        'id': response.user!.id,
        'username': username,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      return await _getUserProfile(response.user!.id);
    } on AuthException catch (e) {
      if (e.statusCode == 422 && e.message.contains('already registered')) {
        throw Exception('이미 등록된 이메일입니다.');
      } else {
        throw Exception('회원가입에 실패했습니다: ${e.message}');
      }
    } catch (e) {
      throw Exception('회원가입에 실패했습니다: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (e) {
      throw Exception('로그아웃에 실패했습니다: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _supabaseClient.auth.currentUser;
      if (user == null) {
        return null;
      }

      return await _getUserProfile(user.id);
    } catch (e) {
      debugPrint('사용자 정보를 가져오는데 실패했습니다: $e');
      return null;
    }
  }

  Future<UserModel> _getUserProfile(String userId) async {
    try {
      final response = await _supabaseClient
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      return UserModel.fromJson(response);
    } catch (e) {
      throw Exception('사용자 프로필을 가져오는데 실패했습니다: $e');
    }
  }
}
