import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mobile/models/photo_model.dart';
import 'package:mobile/models/trend_model.dart';

part 'trend_repository.g.dart';

@riverpod
TrendRepository trendRepository(TrendRepositoryRef ref) {
  final supabase = Supabase.instance.client;
  return TrendRepository(supabase);
}

class TrendRepository {
  final SupabaseClient _supabaseClient;

  TrendRepository(this._supabaseClient);

  Future<List<TrendModel>> getTrends() async {
    try {
      final response = await _supabaseClient
          .from('trends')
          .select()
          .eq('date', DateTime.now().toIso8601String().split('T')[0])
          .order('trend_score', ascending: false)
          .limit(10);

      return response.map((trend) => TrendModel.fromJson(trend)).toList();
    } catch (e) {
      throw Exception('Failed to get trends: $e');
    }
  }

  Future<List<PhotoModel>> getTrendingPhotos() async {
    try {
      // Get top trending locations
      final trends = await getTrends();
      if (trends.isEmpty) {
        return [];
      }

      // Get photos from trending locations
      final trendingLocations = trends.map((trend) => trend.location).toList();
      final response = await _supabaseClient
          .from('photos')
          .select('*, users:user_id(username, profile_image_url)')
          .inFilter('location', trendingLocations)
          .order('uploaded_at', ascending: false)
          .limit(20);

      return response
          .map((photo) => PhotoModel.fromJson({
                ...photo,
                'username': photo['users']['username'],
                'user_profile_url': photo['users']['profile_image_url'],
              }))
          .toList();
    } catch (e) {
      throw Exception('Failed to get trending photos: $e');
    }
  }

  Future<TrendModel?> getTopTrend() async {
    try {
      final trends = await getTrends();
      if (trends.isEmpty) {
        return null;
      }
      return trends.first;
    } catch (e) {
      throw Exception('Failed to get top trend: $e');
    }
  }
}
