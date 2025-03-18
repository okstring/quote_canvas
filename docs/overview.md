# Flutter Quote Canvas App 개발 개요

![[랭픽:영어명언] '충분한 용기가 있다면 무엇이든 가능하다' - 조앤 롤링 < 영어명언 < 어학 < 라이프 < 기사본문 - 폴리스TV](/Users/okstring/Documents/image/31821_31836_193.png)

> 매일 새로운 명언과 함께 영감을 채우는 나만의 지혜 갤러리
>
> Your daily gallery of wisdom, capturing inspiration one quote at a time



## 소개

Quote Canvas는 아름다운 배경과 함께 의미 있는 명언을 제공하는 일일 영감 앱입니다. 이 가이드는 Flutter의 권장 MVVM 아키텍처 패턴을 따라 개발 과정을 설명하며, 기획부터 배포까지 다양한 기능을 갖춘 모바일 애플리케이션을 구축하는 방법을 보여줍니다.

## 프로젝트 아키텍처 개요

이 앱은 명확한 관심사 분리를 갖춘 Model-View-ViewModel(MVVM) 아키텍처를 따릅니다:

- **UI 레이어**: 뷰(Views)와 뷰모델(ViewModels)
- **데이터 레이어**: 리포지토리(Repositories)와 서비스(Services)

## 개발 단계별 로드맵

### 1. 프로젝트 설정 단계

- 프로젝트 생성 및 기본 구조 설정
- 필요한 패키지 의존성 추가 (http, flutter_local_notifications, shared_preferences 등)
- 기본 애셋 및 리소스 설정

### 2. 데이터 레이어 구현

- 모델 클래스 구현
  - Quote 모델 (API 응답 구조에 맞춘 데이터 클래스)
  - Settings 모델 (사용자 설정 관리)
  - Favorites 모델 (즐겨찾기 기능)
- 서비스 레이어 구현
  - QuoteService (API 통신 담당)
  - NotificationService (로컬 알림 기능)
  - ImageService (이미지 처리 및 저장)
  - ShareService (콘텐츠 공유 기능)
- 리포지토리 레이어 구현
  - QuoteRepository (명언 데이터 관리 및 캐싱)
  - SettingsRepository (설정 상태 관리)
  - FavoritesRepository (즐겨찾기 데이터 관리)

### 3. UI 레이어 구현

- 뷰모델 구현
  - HomeViewModel (메인 화면 로직 처리)
  - SettingsViewModel (설정 화면 로직)
  - FavoritesViewModel (즐겨찾기 관리 로직)
- 공통 위젯 구현
  - QuoteCard (명언 카드 컴포넌트)
  - ImageGenerator (이미지 생성 위젯)
  - 기타 재사용 가능한 UI 컴포넌트
- 뷰 구현
  - HomeView (메인 화면)
  - SettingsView (설정 화면)
  - FavoritesView (즐겨찾기 화면)

### 4. 기능 통합 및 구현

- 화면 간 네비게이션 설정
- 명언 표시 및 새로고침 기능
- 즐겨찾기 저장 및 관리 기능
- 이미지 저장 및 공유 기능
- 로컬 푸시 알림 구현

### 5. UI/UX 최적화

- 다크모드 지원 구현
- 애니메이션 및 전환 효과 추가
- 사용자 경험 개선 및 레이아웃 최적화

### 6. 에러 처리 및 예외 관리

- 오프라인 모드 지원
- 로딩 상태 관리
- 예외 처리 및 사용자 피드백 개선

### 7. 성능 최적화 및 코드 정리

- 메모리 사용량 최적화
- 코드 리팩토링 및 구조 개선
- 불필요한 리빌드 제거

### 8. 테스트 및 디버깅

- 단위 테스트 구현
- 위젯 테스트 추가
- 다양한 디바이스에서 UI 테스트

### 9. 배포 준비

- 앱 아이콘 및 스플래시 스크린 설정
- Android/iOS 빌드 설정
- 앱 스토어 등록 준비 (스크린샷, 설명 등)

## 주요 기능

1. **일일 명언 제공**
   - API를 통한 신선한 명언 제공
   - 사용자 지정 새로고침 옵션
2. **알림 기능**
   - 지정 시간에 로컬 푸시 알림 전송
   - 알림 설정 관리
3. **이미지 생성 및 공유**
   - 명언을 아름다운 배경과 함께 이미지로 생성
   - 소셜 미디어 공유 기능
   - 갤러리 저장 기능
4. **즐겨찾기 관리**
   - 마음에 드는 명언 저장
   - 컬렉션 관리

## 아키텍처 상세 설명

### MVVM 구현 방식

- **View**: Flutter 위젯으로 UI를 표현하며, 사용자 입력을 뷰모델에 전달
- **ViewModel**: 비즈니스 로직 처리 및 UI 상태 관리
- **Repository**: 데이터 소스 추상화 및 비즈니스 로직 관리
- **Service**: 외부 API 통신 및 시스템 서비스 접근

### 상태 관리

- Provider 패키지를 사용한 상태 관리
- 명확한 데이터 흐름: Service → Repository → ViewModel → View

## 기술 스택

- **상태관리**: Provider
- **데이터 저장**: SharedPreferences
- **네트워크**: http 패키지
- **알림**: flutter_local_notifications
- **이미지 처리**: image_gallery_saver
- **공유 기능**: share_plus

이 개발 가이드는 Flutter의 권장 아키텍처를 따르며, 코드 재사용성과 유지보수성을 극대화하는 방식으로 구성되었습니다.
