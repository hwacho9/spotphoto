import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:mobile/features/upload/view_models/upload_state.dart';
import 'package:mobile/services/upload_service.dart';

part 'upload_view_model.g.dart';

@riverpod
class UploadViewModel extends _$UploadViewModel {
  @override
  UploadState build() {
    return const UploadState();
  }

  Future<void> uploadPhoto({
    required File image,
    required String title,
    required String description,
    required String location,
    List<String> tags = const [],
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    try {
      final uploadService = ref.read(uploadServiceProvider);

      await uploadService.uploadPhoto(
        image: image,
        title: title,
        description: description,
        location: location,
        tags: tags,
      );

      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }
}
