import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/photo_model.dart';

part 'photo_repository.g.dart';

@riverpod
PhotoRepository photoRepository(PhotoRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return PhotoRepository(supabase);
}

/// 사진 관련 데이터베이스 작업을 담당하는 Repository
class PhotoRepository {
  final SupabaseClient _supabaseClient;

  PhotoRepository(this._supabaseClient);

  /// 추천 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getRecommendedPhotos() async {
    try {
      final response = await _supabaseClient
          .from('photos')
          .select('*, users:user_id(username, profile_image_url)')
          .order('uploaded_at', ascending: false)
          .limit(10);

      return response
          .map((photo) => PhotoModel.fromJson({
                ...photo,
                'username': photo['users']['username'],
                'user_profile_url': photo['users']['profile_image_url'],
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get recommended photos: $e');
    }
  }

  /// 특정 사용자의 사진 목록을 가져옵니다.
  Future<List<PhotoModel>> getUserPhotos(String userId) async {
    try {
      final response = await _supabaseClient
          .from('photos')
          .select()
          .eq('user_id', userId)
          .order('uploaded_at', ascending: false);

      return response.map((photo) => PhotoModel.fromJson(photo)).toList();
    } catch (e) {
      throw Exception('Failed to get user photos: $e');
    }
  }

  /// 특정 ID의 사진을 가져옵니다.
  Future<Map<String, dynamic>> getPhotoById(String photoId) async {
    try {
      final response = await _supabaseClient
          .from('photos')
          .select('*, users:user_id(username)')
          .eq('id', photoId)
          .single();

      return {
        ...response,
        'username': response['users']?['username'],
      };
    } catch (e) {
      throw Exception('Failed to get photo by ID: $e');
    }
  }

  /// 사진 정보를 데이터베이스에 저장합니다.
  Future<Map<String, dynamic>> createPhoto({
    required String userId,
    required String title,
    required String description,
    required String location,
    required String imageUrl,
    List<String> tags = const [],
  }) async {
    try {
      final result = await _supabaseClient
          .from('photos')
          .insert({
            'user_id': userId,
            'title': title,
            'description': description,
            'location': location,
            'url': imageUrl,
            'tags': tags,
            'uploaded_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();

      return result;
    } catch (e) {
      throw Exception('Failed to create photo: $e');
    }
  }

  /// 사진 정보를 업데이트합니다.
  Future<void> updatePhoto({
    required String photoId,
    String? title,
    String? description,
    String? location,
    String? imageUrl,
    List<String>? tags,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (location != null) updates['location'] = location;
      if (imageUrl != null) updates['image_url'] = imageUrl;
      if (tags != null) updates['tags'] = tags;
      updates['updated_at'] = DateTime.now().toIso8601String();

      await _supabaseClient.from('photos').update(updates).eq('id', photoId);
    } catch (e) {
      throw Exception('Failed to update photo: $e');
    }
  }

  /// 사진을 삭제합니다.
  Future<void> deletePhoto(String photoId) async {
    try {
      await _supabaseClient.from('photos').delete().eq('id', photoId);
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  /// 사진에 좋아요를 추가합니다.
  Future<void> likePhoto(String photoId, String userId) async {
    try {
      await _supabaseClient.from('likes').insert({
        'user_id': userId,
        'photo_id': photoId,
      });
    } catch (e) {
      throw Exception('Failed to like photo: $e');
    }
  }

  /// 사진의 좋아요를 취소합니다.
  Future<void> unlikePhoto(String photoId, String userId) async {
    try {
      await _supabaseClient
          .from('likes')
          .delete()
          .match({'user_id': userId, 'photo_id': photoId});
    } catch (e) {
      throw Exception('Failed to unlike photo: $e');
    }
  }
}
