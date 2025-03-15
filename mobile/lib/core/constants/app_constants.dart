class AppConstants {
  // API URLs
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // Storage Buckets
  static const String photoBucket = 'photos';
  static const String profileImageBucket = 'profiles';

  // Database Tables
  static const String usersTable = 'users';
  static const String photosTable = 'photos';
  static const String likesTable = 'likes';
  static const String trendsTable = 'trends';
  static const String followsTable = 'follows';
  static const String searchesTable = 'searches';

  // Pagination
  static const int defaultPageSize = 20;

  // Map
  static const double defaultZoomLevel = 14.0;
  static const double nearbyRadius = 5000; // 5km in meters

  // Trend Calculation
  static const double searchWeight = 0.3;
  static const double uploadWeight = 0.4;
  static const double likeWeight = 0.3;

  // UI Constants
  static const double cardBorderRadius = 12.0;
  static const double defaultPadding = 16.0;

  // Error Messages
  static const String networkErrorMessage = '네트워크 연결을 확인해주세요.';
  static const String defaultErrorMessage = '오류가 발생했습니다. 다시 시도해주세요.';
  static const String authErrorMessage = '인증에 실패했습니다. 다시 시도해주세요.';

  // Success Messages
  static const String loginSuccessMessage = '로그인에 성공했습니다.';
  static const String registerSuccessMessage = '회원가입에 성공했습니다.';
  static const String uploadSuccessMessage = '사진 업로드에 성공했습니다.';

  // Empty States
  static const String emptyPhotosMessage = '아직 사진이 없습니다.';
  static const String emptyTrendsMessage = '아직 트렌드 데이터가 없습니다.';
  static const String emptySearchMessage = '검색 결과가 없습니다.';

  // Feature Flags
  static const bool enablePushNotifications = false;
  static const bool enableLocationTracking = true;
  static const bool enableDarkMode = true;
}
