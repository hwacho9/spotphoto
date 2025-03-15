# 사진 스팟 앱 (SpotPhoto)

사진 스팟 앱은 사진 촬영에 좋은 장소를 공유하고 탐색할 수 있는 모바일 애플리케이션입니다. 사용자들은 자신이 발견한 좋은 사진 촬영 장소를 공유하고, 다른 사용자들이 공유한 장소를 탐색하여 방문할 수 있습니다.

## 주요 기능

- **사용자 인증**: 회원가입, 로그인, 로그아웃 기능
- **스팟 탐색**: 다른 사용자들이 공유한 사진 스팟 탐색
- **지도 보기**: 지도에서 주변의 사진 스팟 확인
- **스팟 업로드**: 새로운 사진 스팟 공유
- **프로필 관리**: 사용자 프로필 및 업로드한 스팟 관리

## 기술 스택

- **프레임워크**: Flutter
- **상태 관리**: Riverpod
- **라우팅**: GoRouter
- **백엔드**: Supabase
- **코드 생성**: Freezed, Riverpod Generator
- **기타 라이브러리**: Flutter Hooks, Google Maps Flutter

## 프로젝트 구조

프로젝트는 MVVM(Model-View-ViewModel) 아키텍처를 따르며, 다음과 같은 구조로 구성되어 있습니다:

```
lib/
├── core/                  # 핵심 컴포넌트
│   ├── constants/         # 상수
│   ├── router/            # 라우팅 설정
│   ├── theme/             # 테마 설정
│   └── widgets/           # 공통 위젯
├── features/              # 기능별 모듈
│   ├── auth/              # 인증 관련 기능
│   ├── explore/           # 탐색 기능
│   ├── home/              # 홈 화면
│   ├── map/               # 지도 기능
│   ├── profile/           # 프로필 관리
│   ├── splash/            # 스플래시 화면
│   └── upload/            # 업로드 기능
├── models/                # 데이터 모델
├── repositories/          # 데이터 접근 계층
└── services/              # 서비스 계층
```

## 환경 설정

### 요구 사항

- Flutter 3.19.0 이상
- Dart 3.3.0 이상
- Android Studio 또는 VS Code
- iOS 개발을 위한 Xcode (Mac OS에서만 필요)

### 환경 변수 설정

프로젝트 루트에 `.env` 파일을 생성하고 다음 내용을 추가합니다:

```
SUPABASE_URL=YOUR_SUPABASE_URL
SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

## 빌드 및 실행 방법

### 1. 의존성 설치

```bash
cd mobile
flutter pub get
```

### 2. 코드 생성

프로젝트는 코드 생성을 사용하므로, 다음 명령어를 실행하여 필요한 코드를 생성합니다:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 애플리케이션 실행

#### 디버그 모드로 실행

```bash
flutter run
```

#### 릴리스 모드로 실행

```bash
flutter run --release
```

### 4. 빌드

#### Android APK 빌드

```bash
flutter build apk
```

#### iOS IPA 빌드 (Mac OS에서만 가능)

```bash
flutter build ios
```

그 후 Xcode에서 Archive를 통해 IPA 파일을 생성합니다.

## 테스트

### 단위 테스트 실행

```bash
flutter test
```

### 통합 테스트 실행

```bash
flutter test integration_test
```

## 문제 해결

### 빌드 오류

- **iOS 빌드 오류**: iOS 빌드 시 최소 iOS 버전 관련 오류가 발생하는 경우, `ios/Podfile`과 `ios/Runner/Info.plist` 파일에서 최소 iOS 버전을 14.0으로 설정해야 합니다.

- **코드 생성 오류**: 코드 생성 중 오류가 발생하는 경우, 다음 명령어를 실행하여 캐시를 정리한 후 다시 시도합니다:
  ```bash
  flutter clean
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

## 라이센스

이 프로젝트는 MIT 라이센스 하에 배포됩니다.
