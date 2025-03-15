import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/core/utils/api_client.dart';

part 'photo_repository.g.dart';

@riverpod
PhotoRepository photoRepository(PhotoRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return PhotoRepository(supabase);
}

class PhotoRepository {
  final SupabaseClient _supabaseClient;

  PhotoRepository(this._supabaseClient);

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

  Future<void> uploadPhoto({
    required String userId,
    required String url,
    required String location,
    List<String> tags = const [],
    String? description,
  }) async {
    try {
      await _supabaseClient.from('photos').insert({
        'user_id': userId,
        'url': url,
        'location': location,
        'tags': tags,
        'description': description,
        'uploaded_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to upload photo: $e');
    }
  }

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
