import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

part 'storage_service.g.dart';

@riverpod
StorageService storageService(StorageServiceRef ref) {
  return StorageService();
}

/// 파일 업로드 및 스토리지 관련 작업을 담당하는 서비스
class StorageService {
  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  /// 버킷 이름
  static const String photoBucket = 'photos';

  /// 이미지 파일을 스토리지에 업로드하고 URL을 반환합니다.
  Future<String> uploadImage(File image) async {
    try {
      // 파일 이름 생성
      final fileExtension = path.extension(image.path);
      final fileName = '${_uuid.v4()}$fileExtension';

      // 스토리지에 이미지 업로드
      await _supabase.storage.from(photoBucket).upload(
            fileName,
            image,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
          );

      // 이미지 URL 반환
      final imageUrl =
          _supabase.storage.from(photoBucket).getPublicUrl(fileName);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  /// 스토리지에서 이미지를 삭제합니다.
  Future<void> deleteImage(String imageUrl) async {
    try {
      // URL에서 파일 이름 추출
      final uri = Uri.parse(imageUrl);
      final pathSegments = uri.pathSegments;
      final fileName = pathSegments.last;

      // 스토리지에서 이미지 삭제
      await _supabase.storage.from(photoBucket).remove([fileName]);
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }
}
