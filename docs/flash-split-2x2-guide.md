# XIAO BLE 좌우 무선 스플릿 2키+2키 플래싱 가이드

이 문서는 XIAO nRF52840 / XIAO BLE 보드 2개를 사용해 좌우 무선 스플릿 입력을 검증하기 위한 절차를 정리한다.

## 전체 여정 위치

```text
1. 기술 검증 → 좌우 무선 스플릿 입력 검증
```

## 목표

```text
왼쪽 보드 D0 → A
왼쪽 보드 D1 → B
오른쪽 보드 D0 → C
오른쪽 보드 D1 → D
```

두 개의 XIAO BLE 보드가 하나의 키보드처럼 동작하는지 확인한다.

## 준비물

| 항목 | 수량 | 목적 |
| --- | --- | --- |
| XIAO nRF52840 / XIAO BLE | 2개 | 좌측/우측 보드 |
| USB-C 데이터 케이블 | 1~2개 | 플래싱 |
| 브레드보드 | 2개 권장 | 좌우 분리 실험 |
| 택트 스위치 | 4개 | 좌측 2키, 우측 2키 |
| 점퍼선 | 최소 6개 | D0/D1/GND 연결 |

## 1. 좌측 펌웨어 빌드

```bash
cd ~/personal/easysplit-zmk-config
bash scripts/build-split-2x2-left.sh
```

산출물:

```text
~/personal/zmk-workspace/build-left/zephyr/zmk.uf2
```

## 2. 우측 펌웨어 빌드

```bash
cd ~/personal/easysplit-zmk-config
bash scripts/build-split-2x2-right.sh
```

산출물:

```text
~/personal/zmk-workspace/build-right/zephyr/zmk.uf2
```

## 3. 보드 구분

보드 2개를 반드시 구분한다.

```text
왼쪽 보드 = central 역할
오른쪽 보드 = peripheral 역할
```

권장:

```text
왼쪽 보드에 L 스티커
오른쪽 보드에 R 스티커
```

## 4. 플래싱 순서

### 왼쪽 보드

1. 왼쪽 보드를 USB-C로 연결한다.
2. 리셋 버튼을 빠르게 두 번 눌러 부트로더 모드에 들어간다.
3. 아래 파일을 복사한다.

```bash
cp ~/personal/zmk-workspace/build-left/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

### 오른쪽 보드

1. 오른쪽 보드를 USB-C로 연결한다.
2. 리셋 버튼을 빠르게 두 번 눌러 부트로더 모드에 들어간다.
3. 아래 파일을 복사한다.

```bash
cp ~/personal/zmk-workspace/build-right/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

## 5. 블루투스 페어링

보통 central 역할인 왼쪽 보드를 컴퓨터와 페어링한다.

```text
시스템 설정 → Bluetooth → EasySplit 2x2 연결
```

## 6. 배선

왼쪽 보드:

```text
D0 ─ 스위치 ─ GND → A
D1 ─ 스위치 ─ GND → B
```

오른쪽 보드:

```text
D0 ─ 스위치 ─ GND → C
D1 ─ 스위치 ─ GND → D
```

## 7. 성공 기준

```text
왼쪽 D0 입력 시 A
왼쪽 D1 입력 시 B
오른쪽 D0 입력 시 C
오른쪽 D1 입력 시 D
```

위 4개 입력이 하나의 블루투스 키보드에서 정상 처리되면 성공이다.

## 8. 실패 시 확인

### 왼쪽 키만 입력됨

```text
오른쪽 보드 플래싱 확인
오른쪽 보드 전원 확인
좌우 split 연결 대기 시간 확인
```

### 블루투스 장치가 안 보임

```text
왼쪽 보드가 central로 빌드되었는지 확인
settings_reset 후 다시 플래싱
기존 페어링 삭제
```

### 오른쪽 입력이 엉뚱한 키로 들어옴

```text
right overlay의 col-offset 확인
keymap 순서 확인
```

### 양쪽 모두 입력 안 됨

```text
페어링 확인
D0/D1/GND 배선 확인
펌웨어가 올바른 보드에 올라갔는지 확인
```

## 다음 단계

이 검증이 성공하면 USB 전원 상태의 좌우 무선 스플릿 입력이 검증된 것이다.

다음 후보:

```text
1. 재연결 안정성 테스트
2. 배터리 구동 테스트
3. 더 많은 키 수로 확장한 실험
```
