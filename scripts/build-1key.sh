#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/personal/zmk-workspace}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/personal/easysplit-zmk-config/config}"

cd "$WORKSPACE_DIR"
source .venv/bin/activate

rm -rf build

west build \
  -s zmk.git/app \
  -b xiao_ble \
  -- \
  -DSHIELD=easysplit_1key \
  -DZMK_CONFIG="$CONFIG_DIR"

ls -la build/zephyr | grep zmk

echo "easysplit_1key 빌드 완료: $WORKSPACE_DIR/build/zephyr/zmk.uf2"
