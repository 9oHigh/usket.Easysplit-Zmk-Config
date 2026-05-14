# EasySplit ZMK 문서 허브

이 문서는 `easysplit-zmk-config` 저장소의 문서 진입점이다.

README는 빠른 시작용이고, 자세한 절차는 이 문서에서 목적별로 찾는다.

## 전체 여정 위치

```text
0. 준비 → 1. 기술 검증 준비
```

## 1. 로컬 환경 세팅

| 문서 | 목적 |
| --- | --- |
| `zmk-local-setup-guide.md` | 새 Mac에서 ZMK 로컬 빌드 환경을 처음부터 재현 |
| `local-build-notes.md` | 실제 셋업 중 겪은 문제와 해결 기록 |

먼저 볼 문서:

```text
zmk-local-setup-guide.md
```

## 2. 부품 도착 후 실행

| 문서 | 목적 |
| --- | --- |
| `bring-up-checklist.md` | 부품 도착 후 전체 실행 순서 |
| `hardware-test-wiring.md` | D0~D3와 GND 배선 기준 |

부품이 도착하면 먼저 볼 문서:

```text
bring-up-checklist.md
```

## 3. 단일 보드 검증

| 문서 | 목적 |
| --- | --- |
| `flash-1key-guide.md` | XIAO BLE 1개에 1키 펌웨어 플래싱 |
| `flash-4key-guide.md` | XIAO BLE 1개에 4키 펌웨어 플래싱 |

검증 순서:

```text
settings_reset → 1key → 4key
```

## 4. 좌우 무선 스플릿 검증

| 문서 | 목적 |
| --- | --- |
| `flash-split-2x2-guide.md` | left/right 펌웨어 빌드와 플래싱 절차 |
| `split-ble-test-checklist.md` | 좌우 스플릿 2키+2키 입력 검증 체크리스트 |

검증 목표:

```text
왼쪽 D0 → A
왼쪽 D1 → B
오른쪽 D0 → C
오른쪽 D1 → D
```

## 5. 문서 역할 기준

GitHub 문서는 아래 기준으로 관리한다.

```text
빌드 명령어
플래싱 절차
배선 방법
오류 해결
재현 가능한 셋업
```

Notion에서 관리할 것은 아래다.

```text
작업 상태
검증 결과
다음 단계 판단
제품 방향
펀딩 전략
```

## 6. 현재 문서 상태

| 문서 | 상태 | 비고 |
| --- | --- | --- |
| `zmk-local-setup-guide.md` | 핵심 | 새 Mac 환경 재현용 |
| `local-build-notes.md` | 참고 | 실제 이슈 히스토리 |
| `bring-up-checklist.md` | 핵심 | 부품 도착 후 실행 시작점 |
| `hardware-test-wiring.md` | 핵심 | 배선 실수 방지 |
| `flash-1key-guide.md` | 핵심 | 1키 검증 |
| `flash-4key-guide.md` | 핵심 | 4키 검증 |
| `flash-split-2x2-guide.md` | 핵심 | 좌우 스플릿 검증 |
| `split-ble-test-checklist.md` | 핵심 | 좌우 스플릿 검증 체크리스트 |

## 7. 현재 다음 단계

```text
부품 도착 후 bring-up-checklist.md 실행
```

실험 결과는 GitHub가 아니라 Notion 검증 기록 DB에 남긴다.
