# EasySplit ZMK Config

입문형 무선 스플릿 키보드 `EasySplit`의 ZMK 펌웨어 설정 저장소다.

이 저장소의 현재 목적은 완제품 펌웨어가 아니라, 부품 도착 전후로 XIAO nRF52840 / XIAO BLE 기반 입력 검증을 빠르게 진행하기 위한 테스트 설정을 관리하는 것이다.

## 현재 여정 위치

```text
0. 준비 → 1. 기술 검증 준비 → 단일 보드 입력 검증 준비
```

현재 완료 상태:

```text
[완료] 로컬 ZMK 빌드 환경 구축
[완료] settings_reset 빌드 성공
[완료] tester_xiao 빌드 성공
[완료] easysplit_1key 빌드 성공
[완료] easysplit_4key 빌드 성공
[대기] 실제 XIAO BLE 보드 도착 후 플래싱 및 입력 검증
```

## 저장소 구조

```text
config/
└── boards/
    └── shields/
        ├── easysplit_1key/
        └── easysplit_4key/

docs/
├── zmk-local-setup-guide.md
├── local-build-notes.md
├── flash-1key-guide.md
├── flash-4key-guide.md
├── bring-up-checklist.md
└── hardware-test-wiring.md

scripts/
├── setup-zmk-local-macos.sh
├── build-settings-reset.sh
├── build-1key.sh
└── build-4key.sh
```

## 테스트 펌웨어

### easysplit_1key

```text
D0 → A
```

목적:

```text
XIAO BLE + ZMK + 단일 스위치 입력 경로 검증
```

### easysplit_4key

```text
D0 → A
D1 → B
D2 → C
D3 → D
```

목적:

```text
단일 보드에서 여러 GPIO 직접 입력이 정상 동작하는지 검증
```

## 로컬 빌드 환경 세팅

새 Mac에서 한 번에 준비하려면 아래 문서를 먼저 본다.

```text
docs/zmk-local-setup-guide.md
```

자동 세팅 스크립트:

```bash
bash scripts/setup-zmk-local-macos.sh
```

기본 경로:

```text
~/personal/easysplit-zmk-config
~/personal/zmk-workspace
~/personal/zephyr-sdk-0.16.8
```

## 빌드 명령

### settings_reset

```bash
bash scripts/build-settings-reset.sh
```

### 1키 테스트

```bash
bash scripts/build-1key.sh
```

### 4키 테스트

```bash
bash scripts/build-4key.sh
```

각 빌드 성공 기준:

```text
~/personal/zmk-workspace/build/zephyr/zmk.uf2
```

## 부품 도착 후 실행 순서

부품 도착 후에는 아래 문서를 따른다.

```text
docs/bring-up-checklist.md
```

권장 순서:

```text
1. 부품 수량과 외관 확인
2. XIAO BLE 부트로더 진입 확인
3. settings_reset 플래싱
4. easysplit_1key 플래싱
5. D0-GND 1키 입력 확인
6. easysplit_4key 플래싱
7. D0~D3-GND 4키 입력 확인
8. 결과를 Notion 검증 기록 DB에 남김
```

## 회로 연결 문서

```text
docs/hardware-test-wiring.md
```

핵심 원칙:

```text
스위치는 D0~D3 같은 입력 핀과 GND 사이에 연결한다.
3V3, 5V, VUSB에는 스위치를 연결하지 않는다.
```

## GitHub와 Notion 역할 분리

GitHub:

```text
빌드 가능한 설정, 스크립트, 플래싱 가이드, 회로 연결 가이드 관리
```

Notion:

```text
제품 방향, 펀딩 일정, 작업 상태, 검증 결과, 의사결정 관리
```

## 다음 단계

실제 부품이 도착하면 `docs/bring-up-checklist.md`를 열고 순서대로 진행한다.

현재 최우선 검증은 다음이다.

```text
XIAO BLE 1개 + D0-GND 스위치 1개 → A 입력 성공
```