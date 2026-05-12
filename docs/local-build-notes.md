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

## Python 3.13 가상환경
개인 노트북에서 아래 가상환경 구성이 완료됐다.

```bash
cd /Users/leegh/personal/zmk-workspace
/opt/homebrew/opt/python@3.13/bin/python3.13 -m venv .venv
source .venv/bin/activate
python --version
pip --version
```

확인 결과:

```text
Python 3.13.1
pip 24.3.1 from /Users/leegh/personal/zmk-workspace/.venv/lib/python3.13/site-packages/pip
```

이후 ZMK 관련 Python 패키지 설치는 반드시 `.venv`가 활성화된 상태에서 진행한다.

## requirements 경로 문제
`zmk/app/requirements.txt`가 없다는 오류가 발생했다.

```text
ERROR: Could not open requirements file: No such file or directory: 'zmk/app/requirements.txt'
```

이 경우 추측으로 경로를 바꾸지 말고, 먼저 워크스페이스 안에서 실제 `requirements.txt` 위치를 찾는다.

```bash
cd /Users/leegh/personal/zmk-workspace
source .venv/bin/activate
find . -maxdepth 4 -name requirements.txt -print
```

나온 경로를 기준으로 필요한 requirements 파일만 설치한다.
