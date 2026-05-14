# EasySplit ZMK Config

EasySplit의 ZMK 펌웨어 검증용 설정 저장소다.

이 저장소는 완제품 펌웨어 저장소가 아니라, XIAO nRF52840 / XIAO BLE 기반으로 아래 기술 검증을 빠르게 실행하기 위한 저장소다.

```text
1. settings_reset
2. 단일 보드 1키 입력
3. 단일 보드 4키 입력
4. 좌우 무선 스플릿 2키+2키 입력
```

## 현재 여정 위치

```text
0. 준비 → 1. 기술 검증 준비
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

## 빠른 시작

새 Mac에서 환경을 다시 만들 때:

```bash
bash scripts/setup-zmk-local-macos.sh
```

이미 환경이 준비되어 있을 때:

```bash
bash scripts/build-settings-reset.sh
bash scripts/build-1key.sh
bash scripts/build-4key.sh
bash scripts/build-split-2x2-left.sh
bash scripts/build-split-2x2-right.sh
```

## 테스트 펌웨어

| 이름 | 목적 | 예상 입력 |
| --- | --- | --- |
| `settings_reset` | BLE 설정 초기화 | 없음 |
| `easysplit_1key` | 단일 GPIO 입력 검증 | D0 → A |
| `easysplit_4key` | 다중 GPIO 입력 검증 | D0/D1/D2/D3 → A/B/C/D |
| `easysplit_split_2x2_left` | 좌측 스플릿 보드 | D0/D1 → A/B |
| `easysplit_split_2x2_right` | 우측 스플릿 보드 | D0/D1 → C/D |

## 주요 경로

```text
config/boards/shields/   ZMK shield 설정
scripts/                 빌드 스크립트
docs/                    셋업, 플래싱, 배선, 체크리스트 문서
```

문서 전체 목록은 아래에서 본다.

```text
docs/index.md
```

## 부품 도착 후 실행 순서

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

상세 절차는 아래 문서를 따른다.

```text
docs/bring-up-checklist.md
```

## GitHub와 Notion 역할

GitHub:

```text
빌드 가능한 설정, 스크립트, 플래싱 가이드, 회로 연결 가이드 관리
```

Notion:

```text
제품 방향, 펀딩 일정, 작업 상태, 검증 결과, 의사결정 관리
```

## 다음 단계

부품이 도착하면 `docs/bring-up-checklist.md`를 열고 순서대로 실행한다.

최우선 검증:

```text
XIAO BLE 1개 + D0-GND 스위치 1개 → A 입력 성공
```