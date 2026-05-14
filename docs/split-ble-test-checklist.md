# 좌우 무선 스플릿 2키+2키 검증 체크리스트

## 전체 여정 위치

```text
1. 기술 검증 → 좌우 무선 스플릿 입력 검증
```

## 시작 전 조건

```text
[ ] 1키 입력 검증 성공
[ ] 4키 입력 검증 성공
[ ] XIAO BLE 보드 2개 준비
[ ] 좌측/우측 보드 구분 완료
[ ] split 2x2 left/right 빌드 성공
```

## 빌드

```text
[ ] scripts/build-split-2x2-left.sh 실행
[ ] build-left/zephyr/zmk.uf2 생성 확인
[ ] scripts/build-split-2x2-right.sh 실행
[ ] build-right/zephyr/zmk.uf2 생성 확인
```

## 플래싱

```text
[ ] 왼쪽 보드에 build-left/zephyr/zmk.uf2 복사
[ ] 오른쪽 보드에 build-right/zephyr/zmk.uf2 복사
[ ] 좌우 보드 라벨 확인
```

## 페어링

```text
[ ] 왼쪽 보드가 Bluetooth 장치로 보이는지 확인
[ ] EasySplit 2x2 페어링
[ ] 기존 페어링이 꼬이면 settings_reset 후 재시도
```

## 배선

왼쪽 보드:

```text
[ ] D0-GND 스위치 연결
[ ] D1-GND 스위치 연결
```

오른쪽 보드:

```text
[ ] D0-GND 스위치 연결
[ ] D1-GND 스위치 연결
```

## 입력 확인

```text
[ ] 왼쪽 D0 → A
[ ] 왼쪽 D1 → B
[ ] 오른쪽 D0 → C
[ ] 오른쪽 D1 → D
```

## 성공 기준

```text
좌우 보드의 4개 입력이 하나의 블루투스 키보드로 처리된다.
```

## 실패 시 기록

```text
실패 위치:
증상:
사용 펌웨어:
왼쪽 보드 상태:
오른쪽 보드 상태:
해결 시도:
다음 조치:
```

## 성공 후 다음 단계

```text
[ ] Notion 검증 기록 DB에 결과 기록
[ ] 의사결정 기록에 다음 단계 진행 여부 기록
[ ] 재연결 안정성 테스트 또는 배터리 테스트 준비
```
