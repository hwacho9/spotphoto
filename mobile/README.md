# 사진 스팟 앱 (Photo Spot App)

사진 스팟 탐색 및 공유 어플리케이션입니다. 사용자가 사진 스팟을 쉽게 탐색하고, 트렌드를 확인하며, 사진을 공유하고, 다른 유저를 팔로우하여 소셜 네트워크를 형성할 수 있는 플랫폼을 제공합니다.

## 주요 기능

- **트렌드 분석**: 검색 빈도, 사진 업로드 수, 좋아요 수를 기반으로 매일 트렌드 업데이트
- **위치 기반 탐색**: 내 주변 사진 스팟 추천 및 지도 뷰 제공
- **사진 업로드 및 관리**: 사용자가 사진을 업로드하고 Pinterest 스타일 갤러리로 관리
- **탐색 및 추천**: 키워드 검색, 필터링, 개인화된 추천, 팔로잉 피드 제공
- **팔로우/팔로잉**: 유저 간 팔로우 관계 형성 및 소셜 상호작용

## 기술 스택

- **프론트엔드**: Flutter
- **상태 관리**: Riverpod, Flutter Hooks
- **백엔드**: Supabase (PostgreSQL, 스토리지, 인증, REST API)
- **지도**: Google Maps Flutter
- **UI 라이브러리**: Masonry Grid (Pinterest 스타일)

## 프로젝트 구조

프로젝트는 MVVM (Model-View-ViewModel) 패턴을 따릅니다:

```
lib/
├── core/                  # 핵심 유틸리티 및 공통 코드
│   ├── constants/         # 앱 상수
│   ├── router/            # 라우팅 설정
│   ├── theme/             # 테마 설정
│   ├── utils/             # 유틸리티 함수
│   └── widgets/           # 공통 위젯
├── features/              # 기능별 모듈
│   ├── auth/              # 인증 관련 기능
│   ├── home/              # 홈 화면 기능
│   ├── explore/           # 탐색 화면 기능
│   ├── map/               # 지도 화면 기능
│   ├── profile/           # 프로필 화면 기능
│   └── upload/            # 업로드 화면 기능
├── models/                # 데이터 모델
├── repositories/          # 데이터 액세스 레이어
├── services/              # 비즈니스 로직
└── view_models/           # 뷰 모델 (상태 관리)
```

## 설치 및 실행

1. Flutter 설치 (https://flutter.dev/docs/get-started/install)
2. 의존성 설치:
   ```
   flutter pub get
   ```
3. 코드 생성:
   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```
4. 앱 실행:
   ```
   flutter run
   ```

## Supabase 설정

1. Supabase 프로젝트 생성 (https://supabase.com)
2. `lib/main.dart` 파일에서 Supabase URL과 Anon Key 설정:
   ```dart
   await Supabase.initialize(
     url: 'YOUR_SUPABASE_URL',
     anonKey: 'YOUR_SUPABASE_ANON_KEY',
   );
   ```

## 개발자

- 개발자 이름

## 라이센스

MIT
