# XIAO BLE 1키 펌웨어 플래싱 가이드

이 문서는 부품 도착 후 XIAO nRF52840 / XIAO BLE 보드에 `easysplit_1key` 펌웨어를 올리고, D0-GND 스위치 입력을 확인하기 위한 절차를 정리한다.

## 전체 여정 위치

```text
0. 준비 → 1. 기술 검증 → 단일 블루투스 1키 입력 검증
```

## 목표

```text
XIAO BLE 보드 1개에 zmk.uf2를 복사해서 펌웨어를 올린다.
보드가 블루투스 키보드로 인식된다.
D0-GND에 연결한 스위치를 누르면 A 키가 입력된다.
```

## 준비물

| 항목 | 수량 | 목적 |
| --- | --- | --- |
| XIAO nRF52840 / XIAO BLE | 1개 | 테스트 보드 |
| USB-C 데이터 케이블 | 1개 | 보드 연결 및 플래싱 |
| 브레드보드 | 1개 | 스위치 고정 |
| 택트 스위치 | 1개 | 1키 입력 테스트 |
| 점퍼선 | 2개 | D0-GND 연결 |

## 1. 1키 펌웨어 빌드

```bash
cd /Users/leegh/personal/zmk-workspace
source .venv/bin/activate
rm -rf build
west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=easysplit_1key \
  -DZMK_CONFIG=/Users/leegh/personal/easysplit-zmk-config/config
ls -la build/zephyr | grep zmk
```

성공 기준:

```text
build/zephyr/zmk.uf2
```

## 2. XIAO BLE를 부트로더 모드로 진입

1. XIAO BLE를 USB-C 케이블로 Mac에 연결한다.
2. 보드의 리셋 버튼을 빠르게 두 번 누른다.
3. Mac에 외장 드라이브처럼 XIAO 관련 볼륨이 나타나는지 확인한다.

볼륨 이름은 환경에 따라 다를 수 있다.

예상 후보:

```text
XIAO-SENSE
XIAO-BLE
NICENANO
Arduino
```

정확한 이름은 실제 연결 후 확인한다.

## 3. zmk.uf2 복사

Finder에서 `build/zephyr/zmk.uf2` 파일을 XIAO BLE 볼륨으로 드래그해서 복사한다.

또는 터미널에서 볼륨 이름을 확인한 뒤 복사한다.

```bash
ls /Volumes
cp /Users/leegh/personal/zmk-workspace/build/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

복사 후 보드가 자동으로 재부팅될 수 있다.

## 4. 블루투스 페어링

Mac 기준:

```text
시스템 설정 → Bluetooth → 새 키보드 장치 검색 → EasySplit 1Key 선택
```

이름은 `Kconfig.defconfig`의 `ZMK_KEYBOARD_NAME` 값에 따라 표시된다.

현재 설정:

```text
EasySplit 1Key
```

## 5. 1키 회로 연결

초기 테스트 회로:

```text
D0 ─ 스위치 ─ GND
```

연결 방식:

| XIAO BLE 핀 | 연결 대상 |
| --- | --- |
| D0 | 스위치 한쪽 다리 |
| GND | 스위치 반대쪽 다리 |

주의:

```text
3V3, 5V, VUSB에는 스위치를 연결하지 않는다.
```

## 6. 입력 테스트

텍스트 편집기나 메모 앱을 열고 스위치를 누른다.

성공 기준:

```text
A가 입력된다.
```

## 7. 실패 시 확인 순서

### 보드가 외장 드라이브로 안 보임

- USB-C 케이블이 데이터 케이블인지 확인한다.
- 리셋 버튼을 빠르게 두 번 눌렀는지 확인한다.
- 다른 USB 포트나 허브 없이 직접 연결해본다.

### 블루투스 장치가 안 보임

- 기존 페어링 정보를 삭제한다.
- `settings_reset` 펌웨어를 한 번 올린 뒤 다시 `easysplit_1key`를 올린다.
- 보드를 재부팅한다.

### 스위치를 눌러도 입력이 안 됨

- D0와 GND 위치를 다시 확인한다.
- 스위치 다리 방향을 확인한다.
- 브레드보드 내부 연결 방향을 확인한다.
- 멀티미터가 있다면 스위치가 눌릴 때 두 다리가 연결되는지 확인한다.

### 다른 키가 입력됨

- `easysplit_1key.keymap`의 바인딩을 확인한다.
- 현재 기본 입력은 `A`다.

## 8. 완료 기록

성공하면 아래 정보를 기록한다.

```text
날짜:
보드:
펌웨어:
입력 핀:
입력 결과:
문제:
해결:
다음 작업:
```

## 현재 결론

이 테스트가 성공하면 XIAO BLE + ZMK + 단일 스위치 입력 경로가 검증된다.

다음 단계는 4키 입력 테스트다.
