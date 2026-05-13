# 부품 도착 후 Bring-up 체크리스트

이 문서는 부품 도착 후 XIAO nRF52840 / XIAO BLE 기반 1키·4키 입력 검증을 순서대로 진행하기 위한 체크리스트다.

## 전체 여정 위치

```text
1. 기술 검증 → 단일 보드 입력 검증
```

## 목표

```text
XIAO BLE 1개에서 ZMK 펌웨어 플래싱과 D0~D3 직접 입력이 정상 동작하는지 확인한다.
```

## 시작 전 조건

```text
[ ] easysplit_1key 빌드 성공
[ ] easysplit_4key 빌드 성공
[ ] build/zephyr/zmk.uf2 생성 가능
[ ] XIAO BLE 보드 1개 이상 도착
[ ] USB-C 데이터 케이블 준비
[ ] 브레드보드, 택트 스위치, 점퍼선 준비
```

## 1. 부품 상태 확인

```text
[ ] XIAO BLE 수량 확인
[ ] 핀헤더 납땜 상태 확인
[ ] 보드 외관 손상 확인
[ ] 브레드보드 수량 확인
[ ] 택트 스위치 수량 확인
[ ] 점퍼선 수량 확인
[ ] USB-C 케이블이 데이터 케이블인지 확인
```

## 2. 보드 부트로더 진입 확인

```text
[ ] XIAO BLE를 USB-C로 Mac에 연결
[ ] 리셋 버튼을 빠르게 두 번 누름
[ ] Mac에 외장 볼륨이 나타나는지 확인
```

확인 명령:

```bash
ls /Volumes
```

성공 기준:

```text
XIAO BLE 관련 외장 볼륨이 보인다.
```

## 3. settings_reset 플래싱

목적:

```text
기존 블루투스 페어링 정보와 설정을 초기화한다.
```

빌드:

```bash
cd ~/personal/easysplit-zmk-config
bash scripts/build-settings-reset.sh
```

플래싱:

```bash
ls /Volumes
cp ~/personal/zmk-workspace/build/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

## 4. 1키 펌웨어 플래싱

빌드:

```bash
cd ~/personal/easysplit-zmk-config
bash scripts/build-1key.sh
```

플래싱:

```bash
ls /Volumes
cp ~/personal/zmk-workspace/build/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

블루투스 페어링:

```text
시스템 설정 → Bluetooth → EasySplit 1Key 연결
```

## 5. 1키 회로 연결

```text
D0 ─ 스위치 ─ GND
```

성공 기준:

```text
스위치를 누르면 A가 입력된다.
```

## 6. 4키 펌웨어 플래싱

빌드:

```bash
cd ~/personal/easysplit-zmk-config
bash scripts/build-4key.sh
```

플래싱:

```bash
ls /Volumes
cp ~/personal/zmk-workspace/build/zephyr/zmk.uf2 /Volumes/<XIAO_볼륨명>/
```

블루투스 페어링:

```text
시스템 설정 → Bluetooth → EasySplit 4Key 연결
```

## 7. 4키 회로 연결

```text
D0 ─ 스위치 ─ GND
D1 ─ 스위치 ─ GND
D2 ─ 스위치 ─ GND
D3 ─ 스위치 ─ GND
```

예상 입력:

```text
D0 → A
D1 → B
D2 → C
D3 → D
```

## 8. 실패 시 판단

### 보드가 안 보임

```text
케이블, USB 포트, 부트로더 진입 확인
```

### 블루투스가 안 잡힘

```text
settings_reset 재플래싱 → 1key/4key 재플래싱 → 기존 페어링 삭제
```

### 입력이 안 됨

```text
D핀 위치, GND 위치, 브레드보드 방향, 스위치 방향 확인
```

### 일부 키만 안 됨

```text
해당 핀 점퍼선 교체
해당 스위치 교체
D0~D3 위치 재확인
```

## 9. Notion에 남길 결과

검증 기록 DB에 아래 정보를 남긴다.

```text
테스트명:
날짜:
보드:
펌웨어:
연결 핀:
성공/실패:
문제:
해결:
다음 단계:
```

## 완료 기준

```text
[ ] settings_reset 플래싱 성공
[ ] 1키 펌웨어 플래싱 성공
[ ] D0-GND 입력 성공
[ ] 4키 펌웨어 플래싱 성공
[ ] D0~D3 입력 성공
[ ] Notion 검증 기록 작성
```

이 단계가 완료되면 다음은 XIAO BLE 2개를 사용하는 좌우 무선 스플릿 2키+2키 검증이다.
