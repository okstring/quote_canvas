# Flutter Quote Canvas App 개발 개요

> 매일 새로운 명언과 함께 영감을 채우는 나만의 지혜 갤러리
>
> Your daily gallery of wisdom, capturing inspiration one quote at a time

## 소개

Quote Canvas는 아름다운 배경과 함께 의미 있는 명언을 제공하는 일일 영감 앱입니다. 이 가이드는 Flutter의 권장 MVVM 아키텍처 패턴을 따라 개발 과정을 설명하며, 기획부터 배포까지 다양한 기능을 갖춘 모바일 애플리케이션을 구축하는 방법을 보여줍니다.

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