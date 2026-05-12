#!/usr/bin/env bash
set -euo pipefail

# ZMK 로컬 빌드 환경 자동 세팅 스크립트
# 대상: Apple Silicon macOS + Homebrew
# 사용 위치 예:
#   cd ~/personal/easysplit-zmk-config
#   bash scripts/setup-zmk-local-macos.sh

PERSONAL_DIR="${PERSONAL_DIR:-$HOME/personal}"
CONFIG_REPO_DIR="${CONFIG_REPO_DIR:-$PERSONAL_DIR/easysplit-zmk-config}"
WORKSPACE_DIR="${WORKSPACE_DIR:-$PERSONAL_DIR/zmk-workspace}"
SDK_VERSION="${SDK_VERSION:-0.16.8}"
SDK_DIR="${SDK_DIR:-$PERSONAL_DIR/zephyr-sdk-$SDK_VERSION}"
SDK_ARCHIVE="zephyr-sdk-${SDK_VERSION}_macos-aarch64.tar.xz"
SDK_URL="https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${SDK_VERSION}/${SDK_ARCHIVE}"
PY313="/opt/homebrew/opt/python@3.13/bin/python3.13"

log() {
  echo "\n==> $1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "필수 명령어가 없습니다: $1"
    exit 1
  fi
}

log "기본 도구 확인"
require_command git
require_command brew
require_command cmake
require_command ninja
require_command dtc
require_command arm-none-eabi-gcc

if ! command -v wget >/dev/null 2>&1; then
  log "wget 설치"
  brew install wget
fi

if ! command -v west >/dev/null 2>&1; then
  log "west 설치"
  python3 -m pip install --user west
fi

if [ ! -x "$PY313" ]; then
  log "python@3.13 설치"
  brew install python@3.13
fi

log "작업 폴더 준비"
mkdir -p "$PERSONAL_DIR"
mkdir -p "$WORKSPACE_DIR"

if [ ! -d "$CONFIG_REPO_DIR/.git" ]; then
  log "easysplit-zmk-config 클론"
  git clone https://github.com/9oHigh/easysplit-zmk-config.git "$CONFIG_REPO_DIR"
else
  log "easysplit-zmk-config 업데이트"
  git -C "$CONFIG_REPO_DIR" pull --ff-only || true
fi

log "ZMK 워크스페이스 초기화"
cd "$WORKSPACE_DIR"

if [ ! -d "$WORKSPACE_DIR/.west" ]; then
  west init -m https://github.com/zmkfirmware/zmk.git --mr main --mf app/west.yml
else
  echo ".west가 이미 있어 west init은 건너뜁니다."
fi

west update
west zephyr-export

log "Python 3.13 가상환경 준비"
cd "$WORKSPACE_DIR"
if [ ! -d ".venv" ]; then
  "$PY313" -m venv .venv
fi

# shellcheck disable=SC1091
source .venv/bin/activate
python --version
pip --version

log "Python 의존성 설치"
python -m pip install --upgrade pip
python -m pip install -r zephyr/scripts/requirements.txt
python -m pip install -r zmk.git/app/scripts/requirements.txt

log "Zephyr SDK 확인"
cd "$PERSONAL_DIR"
if [ ! -d "$SDK_DIR" ]; then
  curl -L -O "$SDK_URL"
  tar xvf "$SDK_ARCHIVE"
fi

cd "$SDK_DIR"
./setup.sh

log "settings_reset 빌드 테스트"
cd "$WORKSPACE_DIR"
# shellcheck disable=SC1091
source .venv/bin/activate
rm -rf build
west build -s zmk.git/app -b xiao_ble -- -DSHIELD=settings_reset
ls -la build/zephyr | grep zmk

log "easysplit_1key 빌드 테스트"
rm -rf build
west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=easysplit_1key \
  -DZMK_CONFIG="$CONFIG_REPO_DIR/config"
ls -la build/zephyr | grep zmk

log "완료"
echo "ZMK 로컬 빌드 환경 세팅과 easysplit_1key 빌드 검증이 완료되었습니다."
