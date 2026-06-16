# GitHub Actions 클라우드 빌드

로컬에 ZMK 빌드 환경(west / Zephyr SDK / arm-gcc)을 설치하지 않고, GitHub Actions에서
펌웨어(`.uf2`)를 빌드하는 방법이다. 이게 **제품 빌드/배포의 기본 경로**다.
로컬 빌드(`zmk-local-setup-guide.md`)는 빠른 실험용 fallback으로만 유지한다.

## 왜 이걸 쓰나

- 로컬 디스크/도구 설치 0 (워크스페이스+SDK 약 16GB 불필요)
- Public 저장소면 Actions 무료, ZMK 빌드 1회 약 3~5분
- push할 때마다 자동 빌드 → 펌웨어 배포 파이프라인이 그대로 완성됨
- 라이선스: ZMK=MIT, Zephyr=Apache 2.0 → 상업 판매/비공개 배포 가능

## 구성 파일 (3개)

| 파일 | 역할 |
| --- | --- |
| `config/west.yml` | `zmkfirmware/zmk` 소스를 가져오는 west 매니페스트 |
| `build.yaml` (저장소 루트) | 빌드 매트릭스. `board` x `shield` 조합마다 `.uf2` 1개 생성 |
| `.github/workflows/build.yml` | ZMK 공식 `build-user-config` 재사용 워크플로 |

### 빌드 매트릭스 (`build.yaml`)

```yaml
include:
  - board: xiao_ble//zmk
    shield: easysplit_1key
  - board: xiao_ble//zmk
    shield: easysplit_4key
  - board: xiao_ble//zmk
    shield: easysplit_split_2x2_left   # central
  - board: xiao_ble//zmk
    shield: easysplit_split_2x2_right
  - board: xiao_ble//zmk
    shield: settings_reset             # BLE 페어링 초기화용
```

## 보드명 주의 (중요)

보드는 **`xiao_ble//zmk`** 로 적는다. 그냥 `xiao_ble`로 쓰면 빌드가
`The selected board is not set up for ZMK and there is a ZMK variant available`
오류로 실패한다.

- 이유: Zephyr 4.1부터 ZMK가 보드 variant 표기를 요구한다.
  (Seeed XIAO BLE: `seeeduino_xiao_ble` → `xiao_ble//zmk`)
- `//` 의 가운데가 비는 건 이 보드에 SoC가 하나(nRF52840)뿐이라 SoC 식별자를 생략하기 때문.
- 참고: https://zmk.dev/blog/2025/12/09/zephyr-4-1#zmk-board-variant

## 빌드 실행

- `main`/브랜치에 push하거나 PR을 올리면 자동 실행
- 수동 실행: GitHub → Actions 탭 → "Build ZMK firmware" → Run workflow

## 펌웨어 받기 / 플래싱

1. GitHub → Actions → 해당 run 클릭
2. 페이지 하단 **Artifacts** 에서 shield별 zip 다운로드
3. zip 안의 `.uf2` 추출
4. XIAO BLE를 USB로 연결 → 리셋 더블탭으로 부트로더 진입 → 나타난 드라이브에 `.uf2` 드래그&드롭
5. 스플릿은 **left=central**. 양쪽 보드에 각각 left/right 펌웨어를 넣는다.

## 고객 배포 (제품용)

- 검증된 `.uf2`를 **GitHub Releases**에 버전 태그(예: `v1.0.0`)와 함께 첨부
- 고객은 GitHub 계정 없이 다운로드 → 위와 같은 방식으로 플래싱
- 펌웨어 업데이트도 동일: 코드 수정 → push → 빌드 → 새 Release 발행
