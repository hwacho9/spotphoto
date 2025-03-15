import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/repositories/photo_repository.dart';
import 'package:mobile/services/storage_service.dart';

part 'photo_service.g.dart';

@riverpod
PhotoService photoService(PhotoServiceRef ref) {
  final photoRepository = ref.watch(photoRepositoryProvider);
  final storageService = ref.watch(storageServiceProvider);
  return PhotoService(photoRepository, storageService);
}

/// 사진 관련 비즈니스 로직을 처리하는 서비스
class PhotoService {
  final PhotoRepository _photoRepository;
  final StorageService _storageService;

  PhotoService(this._photoRepository, this._storageService);

  /// 추천 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getRecommendedPhotos() async {
    return await _photoRepository.getRecommendedPhotos();
  }

  /// 특정 사용자의 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getUserPhotos(String userId) async {
    return await _photoRepository.getUserPhotos(userId);
  }

  /// 사진을 업로드합니다. (이미지 업로드 + 데이터베이스 저장)
  Future<PhotoModel> uploadPhoto({
    required File image,
    required String title,
    required String description,
    required String location,
    List<String> tags = const [],
  }) async {
    try {
      // 현재 로그인한 사용자 확인
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('로그인이 필요합니다');
      }

      // 트랜잭션 처리를 위한 변수
      String? imageUrl;
      Map<String, dynamic>? photoData;

      try {
        // 1. 이미지 파일 업로드
        imageUrl = await _storageService.uploadImage(image);

        // 2. 데이터베이스에 사진 정보 저장
        photoData = await _photoRepository.createPhoto(
          userId: user.id,
          title: title,
          description: description,
          location: location,
          imageUrl: imageUrl,
          tags: tags,
        );

        // 3. PhotoModel 객체 생성 및 반환
        return PhotoModel.fromJson(photoData);
      } catch (e) {
        // 오류 발생 시 롤백 처리
        if (imageUrl != null && photoData == null) {
          // 이미지는 업로드됐지만 데이터베이스 저장에 실패한 경우
          await _storageService.deleteImage(imageUrl);
        }
        rethrow;
      }
    } catch (e) {
      if (e is PostgrestException) {
        print('PostgrestException 코드: ${e.code}');
        print('PostgrestException 메시지: ${e.message}');
        print('PostgrestException 힌트: ${e.hint}');
        print('PostgrestException 세부사항: ${e.details}');
      }
      throw Exception('사진 업로드 실패: $e');
    }
  }

  /// 사진을 삭제합니다. (데이터베이스 + 스토리지)
  Future<void> deletePhoto(PhotoModel photo) async {
    try {
      // 1. 데이터베이스에서 사진 정보 삭제
      await _photoRepository.deletePhoto(photo.id);

      // 2. 스토리지에서 이미지 파일 삭제
      await _storageService.deleteImage(photo.url);
    } catch (e) {
      throw Exception('사진 삭제 실패: $e');
    }
  }

  /// 사진에 좋아요를 추가합니다.
  Future<void> likePhoto(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    await _photoRepository.likePhoto(photoId, user.id);
  }

  /// 사진의 좋아요를 취소합니다.
  Future<void> unlikePhoto(String photoId) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('로그인이 필요합니다');
    }

    await _photoRepository.unlikePhoto(photoId, user.id);
  }
}
