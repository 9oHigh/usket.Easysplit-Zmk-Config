# ZMK 로컬 빌드 환경 세팅 가이드

이 문서는 `easysplit-zmk-config` 저장소를 기준으로, 개인 노트북 또는 다른 Mac에서 ZMK 로컬 빌드 환경을 다시 구성하기 위한 절차를 정리한다.

목표는 아래 상태까지 도달하는 것이다.

```text
XIAO nRF52840 / XIAO BLE 대상 ZMK 펌웨어를 로컬에서 빌드할 수 있다.
settings_reset 빌드가 가능하다.
easysplit_1key 커스텀 쉴드 빌드가 가능하다.
```

---

## 1. 현재 프로젝트 구조

권장 폴더 구조는 아래와 같다.

```text
/Users/<username>/personal/easysplit-zmk-config
/Users/<username>/personal/zmk-workspace
/Users/<username>/personal/zephyr-sdk-0.16.8
```

| 경로 | 역할 |
| --- | --- |
| `easysplit-zmk-config` | 내가 관리하는 EasySplit 키보드 설정 저장소 |
| `zmk-workspace` | ZMK 본체, Zephyr, modules를 내려받는 로컬 빌드 워크스페이스 |
| `zephyr-sdk-0.16.8` | ARM 펌웨어 빌드용 Zephyr SDK |

`easysplit-zmk-config` 저장소 안에서 `west init -l .`을 실행하면 안 된다. 이 저장소는 ZMK 설정 저장소이지, `west.yml`을 가진 ZMK 워크스페이스가 아니다.

---

## 2. GitHub 저장소 클론

```bash
git clone https://github.com/9oHigh/easysplit-zmk-config.git
cd easysplit-zmk-config
```

---

## 3. 필수 도구 확인

아래 도구들이 필요하다.

```bash
python3 --version
west --version
cmake --version
ninja --version
dtc --version
git --version
brew --version
arm-none-eabi-gcc --version
```

설치가 안 된 도구가 있으면 Homebrew로 설치한다.

```bash
brew install cmake ninja dtc wget
```

`west`가 없다면 설치한다.

```bash
python3 -m pip install --user west
```

---

## 4. Python 3.14 문제

개인 노트북에서 `/opt/homebrew/bin/python3`가 Python 3.14.4를 가리키는 상태에서 `pip` 실행 중 아래 문제가 발생했다.

```text
ImportError: Symbol not found: _XML_SetAllocTrackerActivationThreshold
```

이 문제는 ZMK 문제가 아니라 Homebrew Python 3.14 환경 문제다.

해결 방향은 Python 3.14를 고치지 않고, 이미 설치된 Python 3.13으로 ZMK 전용 가상환경을 만드는 것이다.

---

## 5. ZMK 워크스페이스 만들기

```bash
cd /Users/<username>/personal
mkdir -p zmk-workspace
cd zmk-workspace
```

ZMK 저장소는 루트에 `west.yml`이 있지 않다. 따라서 매니페스트 파일 위치를 명시해야 한다.

```bash
west init -m https://github.com/zmkfirmware/zmk.git --mr main --mf app/west.yml
west update
west zephyr-export
```

성공하면 아래와 유사한 폴더가 생긴다.

```text
zmk.git
zephyr
modules
```

---

## 6. Python 3.13 가상환경 생성

```bash
cd /Users/<username>/personal/zmk-workspace
/opt/homebrew/opt/python@3.13/bin/python3.13 -m venv .venv
source .venv/bin/activate
python --version
pip --version
```

성공 예시:

```text
Python 3.13.1
pip ... /zmk-workspace/.venv/...
```

이후 ZMK 관련 Python 패키지 설치는 반드시 `.venv`가 활성화된 상태에서 진행한다.

---

## 7. Python 의존성 설치

처음에는 아래처럼 잘못 실행했다.

```bash
python -m pip install -r zmk/app/requirements.txt
```

하지만 실제 ZMK 워크스페이스 구조에서는 `zmk`가 아니라 `zmk.git` 폴더가 생겼고, requirements 위치도 아래와 같았다.

```text
./zephyr/scripts/requirements.txt
./zmk.git/app/scripts/requirements.txt
```

따라서 아래 명령을 사용한다.

```bash
cd /Users/<username>/personal/zmk-workspace
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install -r zephyr/scripts/requirements.txt
python -m pip install -r zmk.git/app/scripts/requirements.txt
```

---

## 8. Zephyr SDK 설치

`west build` 실행 시 아래 오류가 발생하면 Zephyr SDK가 설치되지 않은 것이다.

```text
Could not find a package configuration file provided by "Zephyr-sdk"
```

Apple Silicon Mac 기준으로 아래 SDK를 설치한다.

```bash
cd /Users/<username>/personal
curl -L -O https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_macos-aarch64.tar.xz
tar xvf zephyr-sdk-0.16.8_macos-aarch64.tar.xz
cd zephyr-sdk-0.16.8
./setup.sh
```

`./setup.sh` 실행 중 아래 오류가 나오면 `wget`이 없는 것이다.

```text
Zephyr SDK setup requires 'wget' to be installed and available in the PATH.
```

해결:

```bash
brew install wget
cd /Users/<username>/personal/zephyr-sdk-0.16.8
./setup.sh
```

---

## 9. settings_reset 빌드 확인

```bash
cd /Users/<username>/personal/zmk-workspace
source .venv/bin/activate
rm -rf build
west build -s zmk.git/app -b xiao_ble -- -DSHIELD=settings_reset
ls -la build/zephyr | grep zmk
```

성공 기준:

```text
zmk.uf2
```

이 단계가 성공하면 XIAO BLE 대상 펌웨어를 로컬에서 빌드할 수 있다는 뜻이다.

---

## 10. tester_xiao 빌드 확인

ZMK에 포함된 테스트용 XIAO 쉴드를 빌드한다.

```bash
cd /Users/<username>/personal/zmk-workspace
source .venv/bin/activate
rm -rf build
west build -s zmk.git/app -b xiao_ble -- -DSHIELD=tester_xiao
ls -la build/zephyr | grep zmk
```

성공 기준:

```text
zmk.uf2
```

---

## 11. EasySplit 1키 테스트 펌웨어 빌드

`easysplit-zmk-config` 저장소에는 1키 테스트용 쉴드가 추가되어 있다.

```text
config/boards/shields/easysplit_1key/
├── Kconfig.defconfig
├── Kconfig.shield
├── easysplit_1key.keymap
└── easysplit_1key.overlay
```

의미:

```text
XIAO BLE의 D0 핀에 스위치 1개를 연결하고, 누르면 A 키가 입력되는 펌웨어
```

빌드 명령:

```bash
cd /Users/<username>/personal/zmk-workspace
source .venv/bin/activate
rm -rf build
west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=easysplit_1key \
  -DZMK_CONFIG=/Users/<username>/personal/easysplit-zmk-config/config
ls -la build/zephyr | grep zmk
```

성공 기준:

```text
build/zephyr/zmk.uf2
```

---

## 12. 자주 겪은 문제와 해결

### 문제 1. `west init -l .` 실패

오류:

```text
no west.yml found
```

원인:

```text
easysplit-zmk-config는 ZMK 워크스페이스가 아니라 설정 저장소다.
```

해결:

```bash
west init -m https://github.com/zmkfirmware/zmk.git --mr main --mf app/west.yml
```

### 문제 2. `west init -m ...` 실패

오류:

```text
no west.yml found in .west/manifest-tmp
```

원인:

```text
ZMK 매니페스트 파일 위치를 명시하지 않았다.
```

해결:

```bash
west init -m https://github.com/zmkfirmware/zmk.git --mr main --mf app/west.yml
```

### 문제 3. Python 3.14 pip 오류

오류:

```text
ImportError: Symbol not found: _XML_SetAllocTrackerActivationThreshold
```

해결:

```bash
/opt/homebrew/opt/python@3.13/bin/python3.13 -m venv .venv
source .venv/bin/activate
```

### 문제 4. `zmk/app/requirements.txt` 없음

오류:

```text
No such file or directory: zmk/app/requirements.txt
```

해결:

```bash
find . -maxdepth 4 -name requirements.txt -print
python -m pip install -r zmk.git/app/scripts/requirements.txt
```

### 문제 5. Zephyr SDK 없음

오류:

```text
Could not find a package configuration file provided by "Zephyr-sdk"
```

해결:

```bash
curl -L -O https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v0.16.8/zephyr-sdk-0.16.8_macos-aarch64.tar.xz
tar xvf zephyr-sdk-0.16.8_macos-aarch64.tar.xz
cd zephyr-sdk-0.16.8
./setup.sh
```

### 문제 6. `wget` 없음

오류:

```text
Zephyr SDK setup requires 'wget'
```

해결:

```bash
brew install wget
./setup.sh
```

### 문제 7. `.venv` 또는 `zmk.git` 없음

원인:

```text
현재 위치가 /Users/<username>/personal/zmk-workspace가 아닐 가능성이 높다.
```

해결:

```bash
pwd
cd /Users/<username>/personal/zmk-workspace
source .venv/bin/activate
```

---

## 13. 현재 완료 상태

```text
[완료] easysplit-zmk-config 저장소 생성
[완료] ZMK 워크스페이스 생성
[완료] Python 3.13 가상환경 생성
[완료] Zephyr/ZMK Python 의존성 설치
[완료] Zephyr SDK 설치
[완료] settings_reset 빌드 성공
[완료] tester_xiao 빌드 성공
[완료] easysplit_1key 빌드 성공
```

다음 단계는 실제 XIAO nRF52840 보드가 도착한 뒤 `zmk.uf2`를 플래싱하고 D0-GND 스위치 입력을 확인하는 것이다.
