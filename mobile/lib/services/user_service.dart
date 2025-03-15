import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/repositories/user_repository.dart';

part 'user_service.g.dart';

@riverpod
UserService userService(UserServiceRef ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserService(userRepository);
}

/// 사용자 관련 비즈니스 로직을 처리하는 서비스
class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  /// 현재 로그인한 사용자의 프로필 정보를 가져옵니다.
  Future<UserModel?> getCurrentUserProfile() async {
    return await _userRepository.getCurrentUserProfile();
  }

  /// 사용자 프로필 정보를 가져옵니다.
  Future<UserModel?> getUserProfile(String userId) async {
    return await _userRepository.getUserProfile(userId);
  }

  /// 사용자 이름으로 사용자를 검색합니다.
  Future<List<UserModel>> searchUsersByUsername(String query) async {
    return await _userRepository.searchUsersByUsername(query);
  }

  /// 인기 있는 사용자 목록을 가져옵니다.
  Future<List<UserModel>> getPopularUsers({int limit = 10}) async {
    return await _userRepository.getPopularUsers(limit: limit);
  }

  /// 사용자 추천 목록을 가져옵니다.
  Future<List<UserModel>> getSuggestedUsers({int limit = 5}) async {
    return await _userRepository.getSuggestedUsers(limit: limit);
  }
}
