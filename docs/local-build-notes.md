# 로컬 ZMK 빌드 메모

## 현재 상황
`easysplit-zmk-config` 저장소는 내가 관리하는 키보드 설정 저장소다.

따라서 이 저장소 루트에서 바로 아래 명령을 실행하면 실패한다.

```bash
west init -l .
```

이 명령은 현재 폴더에 `west.yml` 매니페스트가 있을 때 사용하는 방식이다. 현재 저장소는 아직 `west.yml`을 가진 ZMK 워크스페이스가 아니므로 `no west.yml found` 오류가 정상이다.

## 로컬 작업 방향
개인 노트북에서는 아래처럼 작업한다.

```text
~/personal/easysplit-zmk-config   = 내가 관리하는 키보드 설정 저장소
~/personal/zmk-workspace          = ZMK 본체와 Zephyr를 내려받는 빌드 워크스페이스
```

즉, 설정 저장소와 ZMK 워크스페이스를 분리한다.

## 주의: ZMK 매니페스트 위치
ZMK 저장소는 루트에 `west.yml`이 있는 구조가 아니다.

따라서 아래 명령도 실패할 수 있다.

```bash
west init -m https://github.com/zmkfirmware/zmk.git --mr main
```

ZMK의 매니페스트 파일 위치를 명시해야 한다.

## 권장 초기화 명령
기존 실패 흔적을 지운 뒤 아래 순서로 진행한다.

```bash
cd /Users/leegh/personal/zmk-workspace
rm -rf .west zmk zephyr modules tools bootloader
west init -m https://github.com/zmkfirmware/zmk.git --mr main --mf app/west.yml
west update
west zephyr-export
```

## 완료 기준
아래 폴더들이 생성되면 ZMK 워크스페이스 초기화가 된 것이다.

```text
zmk
zephyr
modules
```

## Python 3.14 pip 문제
현재 개인 노트북에서 `/opt/homebrew/bin/python3`가 Python 3.14.4를 가리킨다.

`pip` 실행 중 `pyexpat` 로딩 오류가 발생했다.

```text
ImportError: Symbol not found: _XML_SetAllocTrackerActivationThreshold
```

이는 ZMK 문제가 아니라 Homebrew Python 3.14 환경 문제다.

해결 방향은 Python 3.14를 고치는 것이 아니라, 이미 설치되어 있는 Python 3.13을 ZMK 전용 가상환경으로 사용하는 것이다.

권장 방향:

```text
Python 3.13 전용 가상환경 생성 → 가상환경 안에서 pip 의존성 설치 → ZMK 빌드
```
