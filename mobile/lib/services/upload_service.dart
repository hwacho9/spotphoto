import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:mobile/services/photo_service.dart';

part 'upload_service.g.dart';

@riverpod
UploadService uploadService(UploadServiceRef ref) {
  final photoService = ref.watch(photoServiceProvider);
  return UploadService(photoService);
}

/// 사진 업로드 기능을 제공하는 서비스 (레거시 코드와의 호환성을 위해 유지)
/// @deprecated PhotoService를 직접 사용하는 것을 권장합니다.
class UploadService {
  final PhotoService _photoService;

  UploadService(this._photoService);

  final _supabase = Supabase.instance.client;
  final _uuid = const Uuid();

  /// 사진을 업로드합니다.
  Future<void> uploadPhoto({
    required File image,
    required String title,
    required String description,
    required String location,
    List<String> tags = const [],
  }) async {
    try {
      // PhotoService의 uploadPhoto 메서드 호출
      await _photoService.uploadPhoto(
        image: image,
        title: title,
        description: description,
        location: location,
        tags: tags,
      );
    } catch (e) {
      // 오류 처리는 PhotoService에서 이미 수행하므로 그대로 전달
      rethrow;
    }
  }
}
