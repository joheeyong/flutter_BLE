# flutter_ble

Flutter 기반 BLE 시뮬레이터 과제 프로젝트.

## 프로젝트 개요

이 프로젝트는 실제 BLE 하드웨어 없이 **사전에 정의된 Mock BLE 디바이스 리스트**를 기반으로,  
BLE 디바이스 검색, 연결 시뮬레이션, 데이터 송수신 기능을 구현하는 것을 목표로 합니다.

---

## 개발 환경

- Flutter 3.24.5
- Dart 3.5.4
- 지원 플랫폼: Android, iOS
- IDE: Android Studio (MacOS)

---

## 사용 라이브러리

- **Provider**: 상태 관리
- **Mockito**: 테스트 더블(Mock) 생성
- **build_runner**: Mockito 코드 생성 지원
- **equatable**: 모델 비교 편의성
- **flutter_test**: Flutter 기본 테스트 지원

---

## 프로젝트 구조

- lib/
  - models/ # 데이터 모델 (BLE 디바이스 등)
  - providers/ # 상태 관리 (Provider 기반)
  - repository/ # Mock 데이터 소스 및 로직
  - views/ # 화면(UI) 레이어
  - widgets/ # 공용 위젯
- test/
  - providers/ # Provider 단위 테스트
  - views/ # 위젯/기능 테스트

---

1. **네이밍 규칙**
    - 클래스, enum, typedef → `UpperCamelCase`
    - 변수, 함수, 파라미터, private field → `lowerCamelCase`
    - 상수 → `SCREAMING_SNAKE_CASE`
    - private 변수는 `_` 접두어 사용

2. **코드 스타일**
    - 2 space 들여쓰기 (Dart 공식 스타일)
    - 80~100자 넘는 라인은 줄바꿈
    - 매개변수가 많은 함수는 trailing comma로 자동 정렬

3. **파일 구성**
    - 한 파일에는 한 클래스만 정의
    - 기능별 폴더링 (models, providers, views, widgets)

4. **테스트 네이밍**
    - `given_when_then` 패턴을 따르며, 테스트 이름은 **한국어** 사용

---

## 현재 상태

- BleDevice 모델 클래스 구현 (Equatable 적용)
- MockBleRepository 작성 및 단위 테스트 완료
- BleProvider 구현 (ChangeNotifier 사용)
    - 디바이스 목록 로드 (fetchDevices)
    - 디바이스 선택 및 선택 해제 기능
- BleProvider 단위 테스트 완료
- equatable 패키지 의존성 추가 및 적용
- 기본 CI (GitHub Actions) 파이프라인 적용