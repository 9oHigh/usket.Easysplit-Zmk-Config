#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_DIR="${WORKSPACE_DIR:-$HOME/personal/zmk-workspace}"
CONFIG_DIR="${CONFIG_DIR:-$HOME/personal/easysplit-zmk-config/config}"

cd "$WORKSPACE_DIR"
source .venv/bin/activate

rm -rf build-left

west build \
  -s zmk.git/app \
  -b xiao_ble \
  -d build-left \
  -- \
  -DSHIELD=easysplit_split_2x2_left \
  -DZMK_CONFIG="$CONFIG_DIR"

ls -la build-left/zephyr | grep zmk

echo "easysplit_split_2x2_left 빌드 완료: $WORKSPACE_DIR/build-left/zephyr/zmk.uf2"
