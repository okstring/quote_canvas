# Quote Canvas 📖✨

> 매일 새로운 명언과 함께 영감을 채우는 나만의 지혜 갤러리
>
> Your daily gallery of wisdom, capturing inspiration one quote at a time

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)![SQLite](https://img.shields.io/badge/SQLite-07405E?style=for-the-badge&logo=sqlite&logoColor=white)

<img src="https://github.com/user-attachments/assets/df51174e-f7b0-4238-b211-49556a12db1f" width="300"/><img src="https://github.com/user-attachments/assets/570a7f1b-de64-4dec-a911-1a5075ca0bb2" width="300"/>



## 📱 프로젝트 소개

Quote Canvas는 선택한 색의 배경과 함께 의미 있는 명언을 제공하는 일일 영감 모바일 App입니다. 사용자는 다양한 명언을 감상하고 커스터마이징된 명언 카드를 이미지로 저장하고 공유할 수 있습니다.

### ✨ 주요 기능

- **📋 일일 명언**: 매일 새로운 영감을 주는 명언 제공
- **🎨 커스터마이징**: 배경색과 글자색을 자유롭게 변경
- **⭐ 즐겨찾기**: 마음에 드는 명언을 저장하고 관리
- **📤 공유 기능**: 명언 카드를 이미지로 저장하거나 SNS 공유
- **🌙 다크 모드**: 라이트/다크/시스템 테마 지원
- **🗄️ 데이터 관리**: 로컬 데이터 저장 및 관리

### 🗓️ 개발 기간

2025.04 ~ 진행중

## 🛠️ 기술 스택

### 🏗️ 아키텍처 패턴
- **MVVM (Model-View-ViewModel)**: 비즈니스 로직과 UI 분리
- **Provider**: Flutter 권장 상태 관리 솔루션
- **Repository Pattern**: 데이터 소스 추상화
- **Dependency Injection**: GetIt을 활용한 의존성 주입

### 📊 데이터 관리
- **SQLite (sqflite)**: 로컬 데이터베이스
- **SharedPreferences**: 사용자 설정 저장
- **HTTP**: REST API 통신

### 🔧 주요 패키지
```yaml
dependencies:
  # 상태 관리
  provider: ^6.1.4
  
  # 네트워킹
  http: ^1.1.0
  
  # 로컬 저장소
  sqflite: ^2.4.2
  shared_preferences: ^2.2.0
  
  # 네비게이션
  go_router: ^15.0.0
  
  # 의존성 주입
  get_it: ^8.0.3
  
  # 데이터 모델링
  freezed: ^3.0.6
  json_annotation: ^4.9.0
  
  # 파일 처리
  path_provider: ^2.1.5
  permission_handler: ^11.4.0
  
  # 공유 기능
  share_plus: ^10.1.4
  flutter_image_gallery_saver: ^0.0.2
  
  # 유틸리티
  uuid: ^4.5.1
  url_launcher: ^6.3.1
  package_info_plus: ^8.3.0
```

## 📁 프로젝트 구조

```
lib/
├── core/                          # 핵심 기능
│   ├── di/                       # 의존성 주입
│   ├── exceptions/               # 예외 처리
│   ├── presentation/             # 공통 프레젠테이션 로직
│   ├── result.dart              # Result 패턴
│   └── routing/                 # 라우팅 설정
├── data/                         # 데이터 레이어
│   ├── data_source/             # 데이터 소스 (API, DB, File)
│   ├── dto/                     # 데이터 전송 객체
│   ├── dto_mapper/              # DTO 매핑
│   ├── model/                   # 도메인 모델
│   ├── model_mapper/            # 모델 매핑
│   └── repository/              # 리포지토리 구현
├── presentation/                 # 프레젠테이션 레이어
│   ├── components/              # 재사용 가능한 UI 컴포넌트
│   ├── home/                    # 홈 화면
│   ├── settings/                # 설정 화면
│   └── splash/                  # 스플래시 화면
├── ui/                          # UI 관련
│   ├── app_colors.dart          # 색상 정의
│   ├── app_text_styles.dart     # 텍스트 스타일
│   └── app_theme.dart           # 앱 테마
└── utils/                       # 유틸리티
    ├── extensions/              # 확장 메서드
    └── logger.dart              # 로깅 시스템
```



## 🏛️ 아키텍처 설명

### MVVM 패턴
이 프로젝트는 Flutter에서 권장하는 **MVVM (Model-View-ViewModel)** 아키텍처 패턴을 따릅니다.

- **View**: Flutter 위젯으로 UI를 표현하며, 사용자 입력을 ViewModel에 전달
- **ViewModel**: 비즈니스 로직 처리 및 UI 상태 관리 (ChangeNotifier 사용)
- **Model**: 데이터 구조 정의 (Freezed를 활용한 불변 객체)
- **Repository**: 데이터 소스 추상화 및 비즈니스 로직 관리

### 상태 관리
**Provider 패키지**를 사용하여 상태를 관리합니다. Provider는 Flutter 팀에서 공식적으로 권장하는 상태 관리 솔루션으로, InheritedWidget을 기반으로 하여 위젯 트리를 통해 상태를 효율적으로 전파합니다.

### 의존성 주입
**GetIt**을 사용하여 서비스 로케이터 패턴을 구현했습니다. 이를 통해 의존성을 중앙에서 관리하고, 테스트 가능한 코드를 작성할 수 있습니다.

### Result 패턴
에러 처리를 위해 **Result 패턴**을 구현했습니다. 이는 Rust의 Result 타입에서 영감을 받아 성공(`Success`)과 실패(`Error`) 상태를 명시적으로 처리할 수 있게 합니다.

## 🔧 주요 기능 설명

### 1. 명언 관리 시스템
- **API 연동**: ZenQuotes API를 통한 영어 명언 제공
- **로컬 저장**: SQLite를 활용한 명언 캐싱
- **한국어 지원**: Assets에서 로드하는 한국어 명언

### 2. 커스터마이징 기능
- **색상 선택**: 16가지 미리 정의된 색상 팔레트
- **텍스트 색상**: 흰색/검정색 텍스트 선택
- **실시간 미리보기**: 선택한 스타일의 실시간 적용

### 3. 이미지 처리
- **RepaintBoundary**: 위젯을 이미지로 캡처
- **Permission Handling**: 갤러리 저장을 위한 권한 관리
- **Share Plus**: 다양한 플랫폼으로 이미지 공유



## 🙏 제공

- [ZenQuotes API](https://zenquotes.io/) - 영어 명언 제공


