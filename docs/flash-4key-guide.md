# XIAO BLE 4키 펌웨어 플래싱 가이드

이 문서는 부품 도착 후 XIAO nRF52840 / XIAO BLE 보드에 `easysplit_4key` 펌웨어를 올리고, D0~D3 입력을 확인하기 위한 절차를 정리한다.

## 전체 여정 위치

```text
0. 준비 → 1. 기술 검증 → 단일 보드 4키 입력 검증
```

## 목표

```text
D0 → A
D1 → B
D2 → C
D3 → D
```

XIAO BLE 보드 1개에서 4개 스위치 입력이 각각 정상 입력되는지 검증한다.

## 준비물

| 항목 | 수량 | 목적 |
| --- | --- | --- |
| XIAO nRF52840 / XIAO BLE | 1개 | 테스트 보드 |
| USB-C 데이터 케이블 | 1개 | 보드 연결 및 플래싱 |
| 브레드보드 | 1개 | 스위치 고정 |
| 택트 스위치 | 4개 | 4키 입력 테스트 |
| 점퍼선 | 최소 5개 | D0~D3 + GND 연결 |

## 1. 4키 펌웨어 빌드

```bash
cd /Users/leegh/personal/zmk-workspace
source .venv/bin/activate
rm -rf build
west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=easysplit_4key \
  -DZMK_CONFIG=/Users/leegh/personal/easysplit-zmk-config/config
ls -la build/zephyr | grep zmk
```

성공 기준:

```text
build/zephyr/zmk.uf2
```

## 2. XIAO BLE에 펌웨어 복사

1. XIAO BLE를 USB-C 케이블로 Mac에 연결한다.
2. 보드의 리셋 버튼을 빠르게 두 번 눌러 부트로더 모드로 진입한다.
3. Mac에 나타난 XIAO BLE 볼륨에 `build/zephyr/zmk.uf2`를 복사한다.

터미널 복사 예시:

```bash
ls /Volumes
cp /Users/leegh/personal/zmk-workspace/build/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

## 3. 4키 회로 연결

초기 테스트는 다이오드 없이 진행한다.

```text
D0 ─ 스위치 ─ GND
D1 ─ 스위치 ─ GND
D2 ─ 스위치 ─ GND
D3 ─ 스위치 ─ GND
```

| XIAO BLE 핀 | 입력 결과 |
| --- | --- |
| D0 | A |
| D1 | B |
| D2 | C |
| D3 | D |

주의:

```text
3V3, 5V, VUSB에는 스위치를 연결하지 않는다.
```

## 4. 입력 테스트

메모 앱이나 텍스트 편집기를 열고 각 스위치를 누른다.

성공 기준:

```text
A B C D가 각각 입력된다.
```

## 5. 실패 시 확인 순서

### 아무 입력도 안 됨

- 블루투스 페어링 상태 확인
- 보드가 `EasySplit 4Key`로 잡히는지 확인
- D0~D3와 GND 연결 확인
- 브레드보드 연결 방향 확인

### 일부 키만 안 됨

- 해당 핀 점퍼선 확인
- 해당 택트 스위치 방향 확인
- 다른 스위치와 바꿔보기

### 입력 문자가 다름

- `easysplit_4key.keymap` 확인
- 현재 매핑은 `A B C D`다.

## 6. 완료 기록

성공하면 아래를 기록한다.

```text
날짜:
보드:
펌웨어:
D0 결과:
D1 결과:
D2 결과:
D3 결과:
문제:
해결:
다음 작업:
```

## 현재 결론

4키 테스트가 성공하면 단일 보드의 다중 GPIO 직접 입력이 검증된다.

다음 단계는 XIAO BLE 2개를 사용한 좌우 무선 스플릿 2키+2키 입력 검증이다.
