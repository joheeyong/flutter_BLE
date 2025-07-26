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

## 빌드 및 실행 방법

1. Flutter SDK와 Android Studio 또는 VS Code 설치
2. 프로젝트 루트 디렉터리에서 의존성 설치
   ```bash
   flutter pub get
   ```
3. Android 에뮬레이터 실행 또는 USB로 기기 연결 후
   ```bash
   flutter run
   ```

---

## 상태 관리 설계 설명

* Provider + ChangeNotifier 패턴을 기반으로 구현

  * BleProvider
  BLE 디바이스 목록 및 선택 상태 관리
  디바이스 연결 및 재시도 로직 수행
  
  * DeviceDetailProvider
  개별 디바이스 연결 상태 관리
  데이터 송신 후 응답 생성 및 로그 관리
  랜덤 수신 메시지 주기적 추가

  * 모든 UI(DeviceListScreen, DeviceDetailScreen)는 Consumer를 사용하여 상태 변화를 즉시 반영

---

## Mock 데이터 및 연결 시뮬레이션

  * MockBleRepository
    * 가상의 BLE 디바이스 목록(RSSI 포함)을 반환
    * 실제 스캔을 대체하여 개발/테스트 환경에서 사용

  * 연결 시뮬레이션
    * 연결 시 2초 지연 후 성공 처리
    * 송신 메시지 → 1초 후 가상 응답 메시지 생성
    * 주기적으로 랜덤 수신 메시지를 자동 추가 (실제 통신 환경 모방)

---

## 테스트 방법 및 커버리지

* 단위 테스트(Unit Test)
  DeviceDetailProvider, MockBleRepository의 상태 변화 및 데이터 로직 검증
* 위젯 테스트(Widget Test)
  DeviceListScreen, DeviceDetailScreen 주요 UI 요소 및 상태 변화 검증
* 테스트 실행 및 커버리지 측정
  ```bash
  flutter test --coverage
  ```
  테스트 결과(coverage/lcov.info)는 CI에서 자동 수집 및 검증되며, 커버리지 확인이 가능

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
    - 디바이스 연결 시뮬레이션 (RSSI 기반 성공 확률 적용)
    - 연결 재시도 로직 (최대 3회) 및 재시도 상태 관리
- DeviceListScreen UI 구현
    - RSSI 기반 연결 상태 표시
    - 체크박스 선택/해제 기능 및 리스트 애니메이션 적용
    - 연결 시도 버튼 및 연결 재시도 상태 표시
    - 연결 성공 시 DeviceDetailScreen으로 화면 전환
    - 연결된 디바이스 정보 리스트 상단 노출
- DeviceDetailScreen UI 구현 (StatelessWidget)
    - 선택된 디바이스의 ID 및 RSSI 신호 세기 표시
    - 연결 상태에 따른 UI 변경 (연결 중 로딩, 연결됨 표시 등)
    - 데이터 송신 입력 및 수신 로그, 송신 로그 영역 UI 구현
    - 주기적 Mock 응답 수신 메시지 자동 추가 기능 포함
    - 연결 해제 버튼 눈에 잘 띄도록 배치
- DeviceDetailProvider 구현 (ChangeNotifier)
    - 디바이스 연결/연결 해제 상태 관리
    - 데이터 전송 및 가상 응답 처리 기능 포함
    - 송신 및 수신 메시지 로그 관리
    - Mock 응답 메시지 주기적 랜덤 생성 기능 포함
- Flutter 테스트 코드 작성 및 기본 위젯 테스트 통과
- equatable 패키지 의존성 추가 및 적용
- 기본 CI (GitHub Actions) 파이프라인 적용  
