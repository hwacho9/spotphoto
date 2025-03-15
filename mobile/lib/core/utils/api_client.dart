import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class ApiClient {
  final SupabaseClient _supabaseClient;
  final Logger _logger = Logger();

  ApiClient(this._supabaseClient);

  // Generic method to handle Supabase queries with error handling
  Future<T> handleQuery<T>(Future<T> Function() query) async {
    try {
      final result = await query();
      return result;
    } catch (e, stackTrace) {
      _logger.e('API Error', error: e, stackTrace: stackTrace);
      throw Exception('API 요청 중 오류가 발생했습니다: $e');
    }
  }

  // Get current authenticated user
  User? get currentUser => _supabaseClient.auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => currentUser != null;

  // Get Supabase client instance
  SupabaseClient get client => _supabaseClient;
}

// Singleton instance for easy access
class ApiClientSingleton {
  static final ApiClientSingleton _instance = ApiClientSingleton._internal();
  late ApiClient apiClient;

  factory ApiClientSingleton() {
    return _instance;
  }

  ApiClientSingleton._internal() {
    apiClient = ApiClient(Supabase.instance.client);
  }

  static ApiClient get instance => _instance.apiClient;
}
