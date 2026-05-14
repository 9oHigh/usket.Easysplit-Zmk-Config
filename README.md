# EasySplit ZMK Config

입문형 무선 스플릿 키보드 `EasySplit`의 ZMK 펌웨어 설정 저장소다.

이 저장소의 현재 목적은 완제품 펌웨어가 아니라, 부품 도착 전후로 XIAO nRF52840 / XIAO BLE 기반 입력 검증을 빠르게 진행하기 위한 테스트 설정을 관리하는 것이다.

## 현재 여정 위치

```text
0. 준비 → 1. 기술 검증 준비 → 단일 보드 입력 + 좌우 무선 스플릿 입력 검증 준비
```

현재 완료 상태:

```text
[완료] 로컬 ZMK 빌드 환경 구축
[완료] settings_reset 빌드 성공
[완료] tester_xiao 빌드 성공
[완료] easysplit_1key 빌드 성공
[완료] easysplit_4key 빌드 성공
[완료] easysplit_split_2x2_left 빌드 성공
[완료] easysplit_split_2x2_right 빌드 성공
[대기] 실제 XIAO BLE 보드 도착 후 플래싱 및 입력 검증
```

## 저장소 구조

```text
config/
└── boards/
    └── shields/
        ├── easysplit_1key/
        ├── easysplit_4key/
        └── easysplit_split_2x2/

docs/
├── zmk-local-setup-guide.md
├── local-build-notes.md
├── bring-up-checklist.md
├── hardware-test-wiring.md
├── flash-1key-guide.md
├── flash-4key-guide.md
├── flash-split-2x2-guide.md
└── split-ble-test-checklist.md

scripts/
├── setup-zmk-local-macos.sh
├── build-settings-reset.sh
├── build-1key.sh
├── build-4key.sh
├── build-split-2x2-left.sh
└── build-split-2x2-right.sh
```

## 테스트 펌웨어

### settings_reset

목적:

```text
XIAO BLE의 기존 블루투스 페어링/설정 상태 초기화
```

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

### easysplit_split_2x2

```text
왼쪽 보드 D0 → A
왼쪽 보드 D1 → B
오른쪽 보드 D0 → C
오른쪽 보드 D1 → D
```

목적:

```text
XIAO BLE 2개가 좌우 무선 스플릿 키보드처럼 동작하는지 검증
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

### 좌우 무선 스플릿 2키+2키

```bash
bash scripts/build-split-2x2-left.sh
bash scripts/build-split-2x2-right.sh
```

빌드 성공 기준:

```text
settings_reset / 1key / 4key:
~/personal/zmk-workspace/build/zephyr/zmk.uf2

split 2x2 left:
~/personal/zmk-workspace/build-left/zephyr/zmk.uf2

split 2x2 right:
~/personal/zmk-workspace/build-right/zephyr/zmk.uf2
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
8. easysplit_split_2x2 left/right 플래싱
9. 좌우 무선 스플릿 2키+2키 입력 확인
10. 결과를 Notion 검증 기록 DB에 남김
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

## 좌우 스플릿 검증 문서

```text
docs/flash-split-2x2-guide.md
docs/split-ble-test-checklist.md
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

그다음 검증은 아래다.

```text
XIAO BLE 1개 + D0~D3-GND 스위치 4개 → A/B/C/D 입력 성공
XIAO BLE 2개 + 좌우 split 2x2 → A/B/C/D 입력 성공
```